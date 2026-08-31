// ============================================================================
// GS Operational System — Edge Function: parse-po  (deployed slug: swift-action)
// v2 — two modes:
//   * default (receiving): { supplier, ref_number, items:[{item_name, qty, unit}] }
//   * mode "invoice" (supplier payment): also extracts prices + currency and
//     converts to IDR using a live exchange rate.
//
// TO UPDATE THE DEPLOYED FUNCTION (Supabase Dashboard):
//   Edge Functions → parse-po (swift-action) → edit code → replace ALL code
//   with THIS FILE → Deploy. Secret ANTHROPIC_API_KEY must stay set.
// ============================================================================

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const json = (obj: unknown, status = 200) =>
  new Response(JSON.stringify(obj), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });

const RECEIVING_PROMPT = `This document is a supplier purchase order (PO) or invoice, possibly in Indonesian.
Extract:
- "supplier": the supplier / vendor company name (string or null)
- "ref_number": the PO number or invoice number (string or null)
- "items": EVERY line item as {"item_name": string, "qty": number, "unit": string|null}
  * qty is the ordered quantity (default 1 if not stated)
  * unit examples: pcs, box, kg, roll, set — null if not stated
  * ignore prices, discounts, taxes, shipping, and totals
Reply with ONLY the JSON object, no other text:
{"supplier": ..., "ref_number": ..., "items": [...]}`;

const PROOF_PROMPT = `This document is a bank transfer / remittance receipt or payment proof (bukti transfer), possibly in Indonesian, from a banking app, remittance service, or bank statement.
Receipts often show SEVERAL amounts: the payment/principal amount, separate fee lines (transfer fee, remittance fee, cable/handling charge, komisi, biaya admin, correspondent charges, tax), and a total debited/charged. Extract them separately:
- "amount": the payment / principal amount sent to the beneficiary, as a plain number (no separators). NOT including fees.
- "fees": the SUM of all fee/charge lines as a plain number (null if none shown)
- "total_debited": the total amount charged to the sender including fees (null if not shown)
- "currency": ISO 4217 code of the amounts ("IDR" for Rupiah / Rp)
- "date": the transfer date as "YYYY-MM-DD" (null if unreadable)
- "to_account": the destination/beneficiary account number (string or null)
- "to_name": the beneficiary name (string or null)
- "bank": the destination bank name (string or null)
- "reference": the transaction reference number (string or null)
Reply with ONLY the JSON object, no other text:
{"amount": ..., "fees": ..., "total_debited": ..., "currency": ..., "date": ..., "to_account": ..., "to_name": ..., "bank": ..., "reference": ...}`;

const INVOICE_PROMPT = `This document is a supplier invoice or purchase order, possibly in Indonesian.
Extract:
- "supplier": the supplier / vendor company name (string or null)
- "ref_number": the invoice number or PO number (string or null)
- "currency": the ISO 4217 currency code of the prices (e.g. "IDR", "USD", "SGD", "EUR", "JPY", "CNY"). Rupiah amounts written like "Rp 1.500.000" are "IDR".
- "items": EVERY line item as {"item_name": string, "qty": number, "unit": string|null, "unit_price": number}
  * unit_price is the NET effective price per unit actually charged, in that currency (plain number, no separators, up to 2 decimals). If a line shows a discounted price, use the discounted price.
  * qty defaults to 1 if not stated
  * IMPORTANT — discounts are layered and must ALL end up inside the unit prices, never as separate lines:
      1. LINE-level discounts (a discount shown on a specific item row) apply only to THAT item's unit_price.
      2. DOCUMENT-level discounts (e.g. "Discount 5%", "Special discount Rp 500.000" on the total) are then PRORATED proportionally across ALL items, on top of any line-level discounts. Example: unit price 1129 with a 5% document discount becomes unit_price 1072.55.
      3. If both exist, apply the line discount first, then prorate the document discount over the already-discounted prices.
    After prorating, the items must add up to the payable grand total; if rounding leaves a difference of a few cents, adjust the last item's unit_price so the sum matches exactly.
  * DO include as separate lines when present: shipping / freight / handling charges, and tax (VAT / PPN) if added on top of item prices — these are real payable components, not discounts.
  * exclude subtotal, discount, and grand-total rows themselves from items
- "total": the payable grand total in that currency, after discounts and charges (number or null)
Reply with ONLY the JSON object, no other text:
{"supplier": ..., "ref_number": ..., "currency": ..., "items": [...], "total": ...}`;

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  try {
    const { data, media_type, mode } = await req.json();
    if (!data || !media_type) return json({ error: "Missing file data." }, 400);

    const key = Deno.env.get("ANTHROPIC_API_KEY");
    if (!key) return json({ error: "ANTHROPIC_API_KEY secret is not set in Supabase." }, 500);

    const allowed = ["application/pdf", "image/jpeg", "image/png", "image/webp", "image/gif"];
    if (!allowed.includes(media_type)) return json({ error: "Unsupported file type: " + media_type }, 400);

    const fileBlock =
      media_type === "application/pdf"
        ? { type: "document", source: { type: "base64", media_type, data } }
        : { type: "image", source: { type: "base64", media_type, data } };

    const prompt =
      mode === "invoice" ? INVOICE_PROMPT :
      mode === "payment_proof" ? PROOF_PROMPT :
      RECEIVING_PROMPT;

    const resp = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": key,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 3000,
        messages: [{ role: "user", content: [fileBlock, { type: "text", text: prompt }] }],
      }),
    });

    if (!resp.ok) {
      const t = await resp.text();
      return json({ error: "Anthropic API error: " + t.slice(0, 300) }, 502);
    }

    const out = await resp.json();
    const text = (out.content || [])
      .filter((b: { type: string }) => b.type === "text")
      .map((b: { text: string }) => b.text)
      .join("");

    const m = text.match(/\{[\s\S]*\}/);
    if (!m) return json({ error: "Could not read items from this document." }, 422);

    const parsed = JSON.parse(m[0]);
    if (mode === "payment_proof") return json(parsed);
    if (!Array.isArray(parsed.items)) parsed.items = [];

    // invoice mode: convert foreign currency to IDR with a live rate
    if (mode === "invoice") {
      const cur = String(parsed.currency || "IDR").toUpperCase();
      parsed.currency = cur;
      const computedTotal = parsed.items.reduce(
        (s: number, it: { qty?: number; unit_price?: number }) =>
          s + (Number(it.qty) || 1) * (Number(it.unit_price) || 0),
        0,
      );
      if (parsed.total == null || !(Number(parsed.total) > 0)) parsed.total = computedTotal;

      if (cur !== "IDR") {
        try {
          const fx = await fetch("https://open.er-api.com/v6/latest/" + cur);
          const fxData = await fx.json();
          const rate = fxData?.rates?.IDR;
          if (rate && Number(rate) > 0) {
            parsed.fx_rate = Number(rate);
            parsed.idr_total = Math.round(Number(parsed.total) * rate);
            parsed.items = parsed.items.map((it: Record<string, unknown>) => ({
              ...it,
              idr_estimate: Math.round((Number(it.qty) || 1) * (Number(it.unit_price) || 0) * rate),
            }));
          } else {
            parsed.fx_error = "Live IDR rate for " + cur + " unavailable.";
          }
        } catch (_e) {
          parsed.fx_error = "Could not fetch a live exchange rate.";
        }
      }
    }

    return json(parsed);
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});

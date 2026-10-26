// ============================================================================
// GS Operational System — Edge Function: parse-po  (deployed slug: swift-action)
// v13 — modes: receiving (default), invoice, payment_proof, match_names (Name Finder: Opus 5.5 + web search)
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
  * OPTIONS ARE PART OF THE NAME. If the document has a separate Options /
    Specification / Variant / Description column, or option lines sitting under
    an item (flex, shaft, iron number, loft, lie, length, grip, hand, colour,
    size), append them to item_name separated by " — " and commas, e.g.
    "FUJIKURA AXIOM 75 IRON SHAFTS (.355) — Iron: #6, Flex: R".
    Several lines on the same invoice often share an identical base product name
    and differ ONLY by these options; without them the lines cannot be told
    apart when the goods are checked in. Never merge such lines together.
  * If a product code / SKU column is present, prefix it: "SFJAXI75I6-R · FUJIKURA
    AXIOM 75 IRON SHAFTS (.355) — Iron: #6, Flex: R".
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
- "items": EVERY line item as {"item_name": string, "item_code": string|null, "qty": number, "unit": string|null, "unit_price": number}
  * unit_price is the NET effective price per unit actually charged, in that currency (plain number, no separators, up to 2 decimals). If a line shows a discounted price, use the discounted price.
  * qty defaults to 1 if not stated
  * IMPORTANT — discounts are layered and must ALL end up inside the unit prices, never as separate lines:
      1. LINE-level discounts (a discount shown on a specific item row) apply only to THAT item's unit_price.
      2. DOCUMENT-level discounts (e.g. "Discount 5%", "Special discount Rp 500.000" on the total) are then PRORATED proportionally across ALL items, on top of any line-level discounts. Example: unit price 1129 with a 5% document discount becomes unit_price 1072.55.
      3. If both exist, apply the line discount first, then prorate the document discount over the already-discounted prices.
    After prorating, the items must add up to the payable grand total; if rounding leaves a difference of a few cents, adjust the last item's unit_price so the sum matches exactly.
  * items must contain GOODS/SERVICES ONLY — never tax, shipping, or other charges, and never subtotal/discount/total rows.
  * OPTIONS ARE PART OF THE NAME. If the invoice has a separate Options /
    Specification / Variant column, or option lines under an item (flex, shaft,
    iron number, loft, lie, length, grip, hand, colour, size), append them to
    item_name separated by " — " and commas, e.g.
    "FUJIKURA AXIOM 75 IRON SHAFTS (.355) — Iron: #6, Flex: R".
    Many invoices repeat the same base product name across several lines that
    differ ONLY by these options and by price; without the options those lines
    are indistinguishable. Keep every line separate — never merge or sum lines
    that share a base name.
  * If the invoice has a product code / SKU column, put it in "item_code";
    otherwise set item_code to null. Do not put the code inside item_name.
- "charges": additional payable charges that are NOT goods, as [{"name": string, "amount": number}]
  * examples: tax ("PPN 11%", VAT), shipping ("Biaya Kirim", freight, ongkir), handling, admin fee, insurance
  * use the charge's name exactly as printed on the document
  * empty array if none
- "total": the payable grand total in that currency = items + charges, after discounts (number or null)
- "invoice_date": the invoice/bill date as "YYYY-MM-DD" (null if unreadable)
- "due_date": the payment due date as "YYYY-MM-DD" (null if not stated)
- "buyer": the customer/buyer the invoice is addressed to (string or null)
- "payment_terms": the payment terms as printed, e.g. "C.O.D", "Bank Transfer", "30 days" (string or null)
- "gross_subtotal": the items subtotal BEFORE any discount, as printed (number or null)
- "discount_total": the total discount amount, as printed — a positive number (0 if none)
- "bank_name": the bank the supplier asks to be paid into (string or null)
- "bank_account_number": that bank account number (string or null)
- "bank_account_name": the account holder name (string or null)
Reply with ONLY the JSON object, no other text:
{"supplier": ..., "ref_number": ..., "currency": ..., "items": [...], "charges": [...], "total": ..., "invoice_date": ..., "due_date": ..., "buyer": ..., "payment_terms": ..., "gross_subtotal": ..., "discount_total": ..., "bank_name": ..., "bank_account_number": ..., "bank_account_name": ...}`;

const NAMES_PROMPT = `You identify golf club components (heads, shafts, grips, accessories) from the short descriptions a supplier, a stock sheet or a fitter writes, and name them in the Golf Solutions house convention.

For EACH line you get: the description, a draft from a keyword matcher, and up to 8 nearest products from the Golf Solutions master (sku + name). The master is the reference for spelling of models, the item-category names, and the attribute order used for each model.

Work out what the line really is. Where the description is ambiguous or uses a model label that is not a spec (e.g. "MODUS 105" is a model name — that shaft weighs 111g; "Ventus TR 6" is a weight class, not grams), use web search on the manufacturer's site to confirm the real specification. At most two searches per line; none when the nearest master items already settle it.

Then for each line return:
- "status": "in master" when the line is the SAME product and SAME spec as a master item (the line may say less than the master — a missing hand or flex is fine; a different loft/flex/weight/colour is not) → "gs_sku" is that master sku and "gs_name" that master name, exactly.
  "new" when the brand or model is clear but this exact spec is not in the master → propose "gs_name" and "gs_sku" in the house convention.
  "unknown" when it cannot be identified.
- "brand": manufacturer as the master spells it (NIPPON SHAFT, GRAPHITE DESIGN, MITSUBISHI CHEMICAL, TRUE TEMPER, GOLF PRIDE, …).
- "type": the item category as the master names it (SHAFT IRON, SHAFT DRIVER, SHAFT HYBRID, SHAFT PUTTER, DRIVER HEAD, FW HEAD, HYBRID HEAD, IRON HEAD, WEDGE HEAD, GRIP, PUTTER GRIP, COMPONENT, GOLF BAG, GLOVE, ACCESSORY). A wedge shaft is SHAFT IRON unless the master shows otherwise.
- "version": the model as the manufacturer writes it (e.g. "N.S.PRO MODUS³ Wedge 105", "TOUR AD DI", "G440 MAX").
- "spec1", "spec2", "spec3": the three specs that identify the unit, most important first — weight in g, flex, colour/finish, loft, hand, wood/iron number, tip (.355 taper / .370 parallel), length. Empty string when not applicable.
- "gs_name": "<BRAND> <TYPE> <MODEL IN CAPS> (<attributes separated by " / ">)", attributes in the order the master uses for that model (look at the nearest items); e.g. NIPPON SHAFT SHAFT IRON N.S.PRO MODUS³ WEDGE 105 (111G / S / LUXURY BLACK / .355 TAPER 37").
- "gs_sku": "<CATEGORY PREFIX>-<BRAND CODE>-<MODEL CODE>-<attribute codes>", reusing the model and brand codes from the nearest master items; prefixes HD/HF/HH/HI/HW for heads, SF/SI/SH/SP for shafts, GR grips, CO components; colour codes BLK BLU RED GRN ORG WHT GLD SLV GRY CHR; weight as the number, with G where the master does so.
- "note": one short sentence a buyer would want — what was confirmed, or what the description got wrong (e.g. "105 here is a model label, not a weight — the shaft is 111g."). Empty string when there is nothing to say.

Never invent a spec the description or the manufacturer data does not support. Keep the master's exact spelling of model names.
Reply with ONLY this JSON, no prose before or after it:
{"results":[{"i":number,"status":"in master"|"new"|"unknown","brand":string,"type":string,"version":string,"spec1":string,"spec2":string,"spec3":string,"gs_name":string,"gs_sku":string,"note":string}]}`;

// The Name Finder's AI pass: identifies each line like a fitter would — with
// the manufacturer's data when the description is ambiguous — and names it.
// Opus 5.5 with web search; a few lines per call so the function finishes
// well inside the edge-function time limit.
async function matchNames(key: string, lines: unknown[]) {
  const resp = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": key,
      "anthropic-version": "2023-06-01",
      "anthropic-beta": "server-side-fallback-2026-07-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-opus-5-5",
      max_tokens: 16000,
      output_config: { effort: "medium" },
      // a policy decline is re-run on a fallback model inside the same call
      fallbacks: "default",
      tools: [{ type: "web_search_20260209", name: "web_search", max_uses: Math.min(2 * lines.length, 16) }],
      messages: [{ role: "user", content: [{ type: "text", text: NAMES_PROMPT + "\n\nLINES:\n" + JSON.stringify(lines) }] }],
    }),
  });
  if (!resp.ok) return json({ error: "Anthropic API error: " + (await resp.text()).slice(0, 300) }, 502);
  const out = await resp.json();
  if (out.stop_reason === "refusal") return json({ error: "The AI reader declined this request." }, 422);
  if (out.stop_reason === "max_tokens") return json({ error: "The answer was cut off — try fewer lines." }, 422);
  const blocks = Array.isArray(out.content) ? out.content : [];
  const searches = blocks.filter((b: { type: string }) => b.type === "server_tool_use").length;
  const text = blocks.filter((b: { type: string }) => b.type === "text").map((b: { text: string }) => b.text).join("");
  const m = text.match(/\{[\s\S]*\}/);
  if (!m) return json({ error: "Could not read the matches." }, 422);
  try {
    const parsed = JSON.parse(m[0]);
    parsed.searches = searches;
    parsed.usage = out.usage;
    return json(parsed);
  } catch (_e) {
    return json({ error: "The matches came back incomplete — try fewer lines." }, 422);
  }
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  try {
    const body = await req.json();
    const { data, media_type, mode } = body;

    // text-only mode: match product descriptions against the master
    if (mode === "match_names") {
      const key = Deno.env.get("ANTHROPIC_API_KEY");
      if (!key) return json({ error: "ANTHROPIC_API_KEY secret is not set in Supabase." }, 500);
      const lines = Array.isArray(body.lines) ? body.lines.slice(0, 12) : [];
      if (!lines.length) return json({ error: "No lines to match." }, 400);
      return await matchNames(key, lines);
    }

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
        // Long invoices run to dozens of line items across several pages;
        // 3000 was too small and truncated the JSON mid-array.
        max_tokens: 16000,
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

    // The model ran out of room: the JSON is cut off part-way through the item
    // list. Never return a partial invoice — a half-read item list would look
    // complete but total up wrong.
    if (out.stop_reason === "max_tokens") {
      return json({
        error:
          "This document is too long to read in one pass — the item list was cut off. " +
          "Enter the lines manually, or split the PDF and read it in parts.",
      }, 422);
    }

    const m = text.match(/\{[\s\S]*\}/);
    if (!m) return json({ error: "Could not read items from this document." }, 422);

    let parsed;
    try {
      parsed = JSON.parse(m[0]);
    } catch (_e) {
      return json({
        error:
          "The document was read but the result came back incomplete, so no items were imported. " +
          "Try again, or enter the lines manually.",
      }, 422);
    }
    if (mode === "payment_proof") return json(parsed);
    if (!Array.isArray(parsed.items)) parsed.items = [];

    // invoice mode: convert foreign currency to IDR with a live rate
    if (mode === "invoice") {
      const cur = String(parsed.currency || "IDR").toUpperCase();
      parsed.currency = cur;
      if (!Array.isArray(parsed.charges)) parsed.charges = [];
      const computedTotal =
        parsed.items.reduce(
          (s: number, it: { qty?: number; unit_price?: number }) =>
            s + (Number(it.qty) || 1) * (Number(it.unit_price) || 0),
          0,
        ) + parsed.charges.reduce((s: number, c: { amount?: number }) => s + (Number(c.amount) || 0), 0);
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

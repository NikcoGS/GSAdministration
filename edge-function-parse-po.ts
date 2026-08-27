// ============================================================================
// GS Operational System — Edge Function: parse-po
// Reads a PO / supplier invoice (PDF or photo) with Claude and returns
// { supplier, ref_number, items: [{ item_name, qty, unit }] }.
//
// DEPLOY (Supabase Dashboard, no CLI needed):
//   1. Dashboard → Edge Functions → Deploy a new function → "Via Editor"
//   2. Name it exactly:  parse-po
//   3. Replace the template code with THIS ENTIRE FILE → Deploy
//   4. Edge Functions → parse-po → Secrets (or Settings → Secrets):
//        add  ANTHROPIC_API_KEY = sk-ant-...   (your key — keep it secret)
//   5. Keep "Verify JWT" ON (default) so only logged-in employees can call it.
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

const PROMPT = `This document is a supplier purchase order (PO) or invoice, possibly in Indonesian.
Extract:
- "supplier": the supplier / vendor company name (string or null)
- "ref_number": the PO number or invoice number (string or null)
- "items": EVERY line item as {"item_name": string, "qty": number, "unit": string|null}
  * qty is the ordered quantity (default 1 if not stated)
  * unit examples: pcs, box, kg, roll, set — null if not stated
  * ignore prices, discounts, taxes, shipping, and totals
Reply with ONLY the JSON object, no other text:
{"supplier": ..., "ref_number": ..., "items": [...]}`;

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  try {
    const { data, media_type } = await req.json();
    if (!data || !media_type) return json({ error: "Missing file data." }, 400);

    const key = Deno.env.get("ANTHROPIC_API_KEY");
    if (!key) return json({ error: "ANTHROPIC_API_KEY secret is not set in Supabase." }, 500);

    const allowed = ["application/pdf", "image/jpeg", "image/png", "image/webp", "image/gif"];
    if (!allowed.includes(media_type)) return json({ error: "Unsupported file type: " + media_type }, 400);

    const fileBlock =
      media_type === "application/pdf"
        ? { type: "document", source: { type: "base64", media_type, data } }
        : { type: "image", source: { type: "base64", media_type, data } };

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
        messages: [{ role: "user", content: [fileBlock, { type: "text", text: PROMPT }] }],
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
    if (!Array.isArray(parsed.items)) parsed.items = [];
    return json(parsed);
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});

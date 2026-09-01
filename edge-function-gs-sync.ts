// ============================================================================
// GS Operational System — Edge Function: gs-sync
// Thin, authenticated proxy to the Google Apps Script sync endpoint.
//
// Why a proxy: the Apps Script needs a secret token, and a secret must never
// ship inside the web app that employees load. The browser calls this function
// (Supabase checks the employee's login), and only this function — server-side
// — knows the token.
//
// DEPLOY (Supabase Dashboard; this is a SECOND function, leave parse-po alone):
//   1. Edge Functions → Deploy a new function → Via Editor
//   2. Name it:  gs-sync        (note the URL slug it actually creates)
//   3. Paste THIS ENTIRE FILE → Deploy
//   4. Edge Functions → Secrets → add both:
//        GS_APPS_SCRIPT_URL   = the Apps Script /exec URL
//        GS_APPS_SCRIPT_TOKEN = the SECRET string from the Apps Script
//   5. Keep "Verify JWT" ON so only logged-in staff can call it.
// ============================================================================

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};
const json = (o: unknown, s = 200) =>
  new Response(JSON.stringify(o), { status: s, headers: { ...CORS, "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  try {
    const url = Deno.env.get("GS_APPS_SCRIPT_URL");
    const token = Deno.env.get("GS_APPS_SCRIPT_TOKEN");
    if (!url || !token) {
      return json({ error: "GS_APPS_SCRIPT_URL / GS_APPS_SCRIPT_TOKEN secrets are not set in Supabase." }, 500);
    }

    const body = await req.json();
    const allowed = ["sheet", "file", "ping"];
    if (!allowed.includes(body.action)) return json({ error: "Unknown action: " + body.action }, 400);

    // Apps Script answers with a 302 to googleusercontent; fetch follows it.
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ...body, token }),
      redirect: "follow",
    });

    const text = await res.text();
    let data;
    try {
      data = JSON.parse(text);
    } catch {
      // usually means the deployment isn't public or wasn't authorised yet
      return json(
        {
          error:
            "The Apps Script did not return JSON — check that the deployment's access is set to " +
            '"Anyone" and that you authorised it. First 200 chars: ' + text.slice(0, 200),
        },
        502,
      );
    }
    if (data.error) return json({ error: data.error }, 400);
    return json(data);
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});

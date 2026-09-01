// ============================================================================
// GS Operational System — Edge Function: gs-sync
// Writes the purchasing compilation into a Google Sheet and uploads invoice /
// payment-proof files into a Google Drive folder, using a service account.
//
// DEPLOY (Supabase Dashboard — this is a SECOND function, keep parse-po as is):
//   1. Edge Functions → Deploy a new function → Via Editor
//   2. Name it:  gs-sync      (note the URL slug it gives you — tell Claude)
//   3. Paste THIS ENTIRE FILE → Deploy
//   4. Edge Functions → Secrets → add:
//        GOOGLE_SERVICE_ACCOUNT = <the whole service-account JSON, one line>
//   5. Keep "Verify JWT" ON so only logged-in staff can call it.
//
// The service account's client_email must be given Editor access to both the
// target spreadsheet and the target Drive folder (share them with that email).
// ============================================================================

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};
const json = (o: unknown, s = 200) =>
  new Response(JSON.stringify(o), { status: s, headers: { ...CORS, "Content-Type": "application/json" } });

const b64url = (bytes: Uint8Array) => {
  let s = "";
  bytes.forEach((b) => (s += String.fromCharCode(b)));
  return btoa(s).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
};
const b64urlStr = (str: string) => b64url(new TextEncoder().encode(str));

function pemToPkcs8(pem: string): ArrayBuffer {
  const body = pem.replace(/-----[^-]+-----/g, "").replace(/\s+/g, "");
  const bin = atob(body);
  const buf = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) buf[i] = bin.charCodeAt(i);
  return buf.buffer;
}

// service-account JWT -> OAuth access token
async function getAccessToken(sa: { client_email: string; private_key: string }) {
  const now = Math.floor(Date.now() / 1000);
  const header = b64urlStr(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claim = b64urlStr(
    JSON.stringify({
      iss: sa.client_email,
      scope: "https://www.googleapis.com/auth/spreadsheets https://www.googleapis.com/auth/drive",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    }),
  );
  const unsigned = `${header}.${claim}`;
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToPkcs8(sa.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(unsigned));
  const jwt = `${unsigned}.${b64url(new Uint8Array(sig))}`;

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });
  const data = await res.json();
  if (!data.access_token) throw new Error("Google auth failed: " + JSON.stringify(data).slice(0, 300));
  return data.access_token as string;
}

// make sure a tab exists, then replace its contents
async function writeTab(token: string, spreadsheetId: string, tab: string, rows: unknown[][]) {
  const metaRes = await fetch(
    `https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}?fields=sheets.properties.title`,
    { headers: { Authorization: `Bearer ${token}` } },
  );
  const meta = await metaRes.json();
  if (!metaRes.ok) throw new Error("Cannot open spreadsheet: " + JSON.stringify(meta).slice(0, 300));
  const titles: string[] = (meta.sheets || []).map((s: { properties: { title: string } }) => s.properties.title);

  if (!titles.includes(tab)) {
    await fetch(`https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}:batchUpdate`, {
      method: "POST",
      headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
      body: JSON.stringify({ requests: [{ addSheet: { properties: { title: tab } } }] }),
    });
  }

  const range = encodeURIComponent(`${tab}!A1:ZZ200000`);
  await fetch(`https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}/values/${range}:clear`, {
    method: "POST",
    headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
    body: "{}",
  });

  const put = await fetch(
    `https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}/values/${encodeURIComponent(tab + "!A1")}?valueInputOption=RAW`,
    {
      method: "PUT",
      headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
      body: JSON.stringify({ values: rows }),
    },
  );
  const out = await put.json();
  if (!put.ok) throw new Error("Sheet write failed: " + JSON.stringify(out).slice(0, 300));
  return out.updatedRows || rows.length;
}

// upload one file into a Drive folder (skips if the same name is already there)
async function uploadFile(
  token: string,
  folderId: string,
  filename: string,
  mimeType: string,
  dataB64: string,
) {
  const q = encodeURIComponent(`name='${filename.replace(/'/g, "\\'")}' and '${folderId}' in parents and trashed=false`);
  const exist = await fetch(
    `https://www.googleapis.com/drive/v3/files?q=${q}&fields=files(id,name)&supportsAllDrives=true&includeItemsFromAllDrives=true`,
    { headers: { Authorization: `Bearer ${token}` } },
  );
  const found = await exist.json();
  if (found.files?.length) return { skipped: true, id: found.files[0].id, name: filename };

  const boundary = "gsboundary" + Math.random().toString(36).slice(2);
  const metadata = JSON.stringify({ name: filename, parents: [folderId] });
  const body =
    `--${boundary}\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n${metadata}\r\n` +
    `--${boundary}\r\nContent-Type: ${mimeType}\r\nContent-Transfer-Encoding: base64\r\n\r\n${dataB64}\r\n` +
    `--${boundary}--`;

  const up = await fetch(
    "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&supportsAllDrives=true&fields=id,name,webViewLink",
    {
      method: "POST",
      headers: { Authorization: `Bearer ${token}`, "Content-Type": `multipart/related; boundary=${boundary}` },
      body,
    },
  );
  const out = await up.json();
  if (!up.ok) throw new Error("Drive upload failed: " + JSON.stringify(out).slice(0, 300));
  return { skipped: false, id: out.id, name: out.name, link: out.webViewLink };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  try {
    const raw = Deno.env.get("GOOGLE_SERVICE_ACCOUNT");
    if (!raw) return json({ error: "GOOGLE_SERVICE_ACCOUNT secret is not set in Supabase." }, 500);
    let sa;
    try { sa = JSON.parse(raw); } catch { return json({ error: "GOOGLE_SERVICE_ACCOUNT is not valid JSON." }, 500); }
    if (!sa.client_email || !sa.private_key) return json({ error: "Service account JSON is missing client_email / private_key." }, 500);

    const body = await req.json();
    const token = await getAccessToken(sa);

    if (body.action === "sheet") {
      const { spreadsheetId, tabs } = body;
      if (!spreadsheetId || !Array.isArray(tabs)) return json({ error: "spreadsheetId and tabs[] are required." }, 400);
      const results = [];
      for (const t of tabs) {
        const n = await writeTab(token, spreadsheetId, t.name, t.rows || []);
        results.push({ tab: t.name, rows: n });
      }
      return json({ ok: true, service_account: sa.client_email, results });
    }

    if (body.action === "file") {
      const { folderId, filename, mimeType, data } = body;
      if (!folderId || !filename || !data) return json({ error: "folderId, filename and data are required." }, 400);
      const r = await uploadFile(token, folderId, filename, mimeType || "application/octet-stream", data);
      return json({ ok: true, ...r });
    }

    if (body.action === "ping") {
      return json({ ok: true, service_account: sa.client_email });
    }

    return json({ error: "Unknown action. Use 'sheet', 'file' or 'ping'." }, 400);
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});

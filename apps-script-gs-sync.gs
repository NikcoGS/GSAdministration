/**
 * GS Operational System — Google Apps Script sync endpoint
 * ---------------------------------------------------------------------------
 * Runs inside your own Google account, so it can already reach your Sheet and
 * Drive folder. No Google Cloud project, no service account, no downloadable
 * key — nothing for the "Secure by Default" org policy to block.
 *
 * SETUP
 *   1. Go to https://script.google.com → New project → name it "GS Ops Sync".
 *   2. Delete the sample code, paste THIS ENTIRE FILE.
 *   3. Replace SECRET below with a long random string of your own (30+ chars).
 *      Keep it private — it is the password for this endpoint.
 *   4. Deploy → New deployment → gear icon → Web app
 *        Execute as:      Me (your@golfsolutionsid.com)
 *        Who has access:  Anyone
 *      → Deploy → Authorize access (approve the Google prompts) → copy the
 *      Web app URL ending in /exec.
 *   5. In Supabase → Edge Functions → Secrets, add:
 *        GS_APPS_SCRIPT_URL   = the /exec URL
 *        GS_APPS_SCRIPT_TOKEN = the same SECRET string
 *
 * "Who has access: Anyone" is safe here because every request must carry the
 * secret token, and the token lives only in Supabase's secret store — never in
 * the web app that employees load.
 */

var SECRET = 'PUT_A_LONG_RANDOM_STRING_HERE';

function doPost(e) {
  try {
    var body = JSON.parse(e.postData.contents);
    if (!SECRET || SECRET === 'PUT_A_LONG_RANDOM_STRING_HERE') {
      return out({ error: 'Set the SECRET constant in the Apps Script first.' });
    }
    if (body.token !== SECRET) return out({ error: 'Unauthorized.' });

    if (body.action === 'ping') {
      return out({ ok: true, running_as: Session.getEffectiveUser().getEmail() });
    }

    // ---- write tables into the spreadsheet ----
    if (body.action === 'sheet') {
      var ss = SpreadsheetApp.openById(body.spreadsheetId);
      var results = [];
      (body.tabs || []).forEach(function (t) {
        var sh = ss.getSheetByName(t.name) || ss.insertSheet(t.name);
        sh.clear();
        var rows = t.rows || [];
        if (rows.length) {
          var width = 1;
          rows.forEach(function (r) { if (r.length > width) width = r.length; });
          var norm = rows.map(function (r) {
            var c = r.slice();
            while (c.length < width) c.push('');
            return c;
          });
          sh.getRange(1, 1, norm.length, width).setValues(norm);
          sh.setFrozenRows(1);
          sh.getRange(1, 1, 1, width).setFontWeight('bold');
        }
        results.push({ tab: t.name, rows: rows.length });
      });
      return out({ ok: true, results: results });
    }

    // ---- file an attachment into the Drive folder ----
    if (body.action === 'file') {
      var folder = DriveApp.getFolderById(body.folderId);
      var existing = folder.getFilesByName(body.filename);
      if (existing.hasNext()) {
        return out({ ok: true, skipped: true, id: existing.next().getId() });
      }
      var blob = Utilities.newBlob(
        Utilities.base64Decode(body.data),
        body.mimeType || 'application/octet-stream',
        body.filename
      );
      var f = folder.createFile(blob);
      return out({ ok: true, skipped: false, id: f.getId(), link: f.getUrl() });
    }

    return out({ error: 'Unknown action: ' + body.action });
  } catch (err) {
    return out({ error: String(err) });
  }
}

function out(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}

// ============================================================================
// GS Operational System — configuration
// ----------------------------------------------------------------------------
// Paste your Supabase project details below.
// Find them in: Supabase Dashboard -> Project Settings -> API
//   * "Project URL"      -> SUPABASE_URL
//   * "anon public" key  -> SUPABASE_ANON_KEY   (safe to expose in frontend code)
// ============================================================================

window.GS_CONFIG = {
  SUPABASE_URL: "https://wmcpczxncadwvtnzkzbm.supabase.co",
  SUPABASE_ANON_KEY: "sb_publishable_1eB8nda2e4bgjeBmwO0fog_Q3h_Gj1o",

  // Cosmetic
  COMPANY_NAME: "Golf Solutions",
  APP_NAME: "GS Operational System",

  // --------------------------------------------------------------------------
  // Google sync (optional) — needs the "gs-sync" edge function deployed, plus
  // the Apps Script web app (apps-script-gs-sync.gs) and its two Supabase
  // secrets: GS_APPS_SCRIPT_URL and GS_APPS_SCRIPT_TOKEN. The script runs as
  // you, so the Sheet and Drive folder need no extra sharing.
  // Leave GOOGLE_SYNC_ENABLED false to keep everything manual.
  // --------------------------------------------------------------------------
  GOOGLE_SYNC_ENABLED: false,
  GOOGLE_SYNC_FUNCTION: "gs-sync",                 // the deployed function's URL slug
  // GS_Purchasing_Compilation (Google Sheets version)
  GOOGLE_SHEET_ID: "1ZGdOjWeNFL9LS8X8U94cErSGnrvxb2RcvO0509AqFlQ",
  GOOGLE_SHEET_TAB_INVOICES: "App Invoice Summary",
  GOOGLE_SHEET_TAB_ITEMS: "App Item Detail",
  // "GS Purchasing" folder in Drive — invoices and payment proofs are filed here
  GOOGLE_DRIVE_FOLDER_ID: "1OnzZGhKDePldyMT1140Se14lC-htwqkP",
};

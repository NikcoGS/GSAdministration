/* ============================================================================
   GS Operational System — front-end application
   Feature 1: Payment Requests (create, track status, admin approval)
   ============================================================================ */

(function () {
  "use strict";

  const cfg = window.GS_CONFIG || {};
  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  // ---- Guard: config not filled in yet -------------------------------------
  const configOk =
    cfg.SUPABASE_URL &&
    cfg.SUPABASE_ANON_KEY &&
    !cfg.SUPABASE_URL.includes("PASTE_") &&
    !cfg.SUPABASE_ANON_KEY.includes("PASTE_");

  if (!configOk) {
    document.body.innerHTML =
      '<div class="card config-warn"><h2>⚙️ Almost there</h2>' +
      "<p>Open <code>config.js</code> and paste your Supabase <code>Project URL</code> " +
      "and <code>anon public</code> key (Supabase Dashboard → Project Settings → API), " +
      "then reload this page.</p></div>";
    return;
  }

  const sb = window.supabase.createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);

  // ---- App state -----------------------------------------------------------
  const state = {
    user: null,        // supabase auth user
    profile: null,     // { id, full_name, role, ... }
    adminFilter: "pending",
    adminModule: "payment", // "payment" | "trip" | "petty"
  };

  // Apply cosmetic config
  if (cfg.APP_NAME) {
    $("#brand-title").textContent = cfg.APP_NAME;
    $("#side-title").textContent = cfg.COMPANY_NAME || cfg.APP_NAME;
    document.title = cfg.APP_NAME;
  }

  // ---- Helpers -------------------------------------------------------------
  const el = (html) => {
    const t = document.createElement("template");
    t.innerHTML = html.trim();
    return t.content.firstElementChild;
  };
  const esc = (s) =>
    String(s ?? "").replace(/[&<>"']/g, (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c])
    );
  const money = (amount, currency) => {
    const n = Number(amount || 0);
    try {
      return new Intl.NumberFormat("en-US", {
        style: "currency", currency: currency || "IDR", minimumFractionDigits: 0,
      }).format(n);
    } catch {
      return (currency || "") + " " + n.toLocaleString();
    }
  };
  const fmtDate = (d) =>
    d ? new Date(d).toLocaleDateString("en-GB", { day: "2-digit", month: "short", year: "numeric" }) : "—";

  let toastTimer;
  function toast(msg, kind = "ok") {
    const t = $("#toast");
    t.textContent = msg;
    t.className = "toast " + kind;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => t.classList.add("hidden"), 3200);
  }

  function openModal(html) {
    $("#modal-card").innerHTML = "";
    $("#modal-card").append(typeof html === "string" ? el(html) : html);
    $("#modal").classList.remove("hidden");
  }
  function closeModal() {
    $("#modal").classList.add("hidden");
    $("#modal-card").innerHTML = "";
  }
  $("#modal").addEventListener("click", (e) => {
    if (e.target.hasAttribute("data-close")) closeModal();
  });

  // ==========================================================================
  //  AUTH
  // ==========================================================================
  function setAuthMsg(text, kind = "") {
    const m = $("#auth-msg");
    m.textContent = text || "";
    m.className = "msg " + kind;
  }

  // tab switching
  $$(".tab").forEach((tab) =>
    tab.addEventListener("click", () => {
      $$(".tab").forEach((t) => t.classList.toggle("active", t === tab));
      const isLogin = tab.dataset.tab === "login";
      $("#login-form").classList.toggle("hidden", !isLogin);
      $("#register-form").classList.toggle("hidden", isLogin);
      setAuthMsg("");
    })
  );

  $("#login-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const btn = $("#login-form button[type=submit]");
    const f = e.target;
    btn.disabled = true;
    setAuthMsg("Logging in…");
    const { error } = await sb.auth.signInWithPassword({
      email: f.email.value.trim(),
      password: f.password.value,
    });
    btn.disabled = false;
    if (error) setAuthMsg(error.message, "error");
    else setAuthMsg("");
  });

  $("#register-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const btn = $("#register-form button[type=submit]");
    const f = e.target;
    btn.disabled = true;
    setAuthMsg("Creating account…");
    const { data, error } = await sb.auth.signUp({
      email: f.email.value.trim(),
      password: f.password.value,
      options: { data: { full_name: f.full_name.value.trim() } },
    });
    btn.disabled = false;
    if (error) {
      setAuthMsg(error.message, "error");
    } else if (data.session) {
      setAuthMsg(""); // auto logged in
    } else {
      setAuthMsg("Account created. Please check your email to confirm, then log in.", "ok");
    }
  });

  $("#logout-btn").addEventListener("click", async () => {
    await sb.auth.signOut();
  });

  // React to auth changes
  sb.auth.onAuthStateChange((_event, session) => {
    handleSession(session);
  });

  async function handleSession(session) {
    if (session && session.user) {
      state.user = session.user;
      await loadProfile();
      showApp();
    } else {
      state.user = null;
      state.profile = null;
      showAuth();
    }
  }

  async function loadProfile() {
    // Try to read the profile; the trigger creates it on signup.
    let { data, error } = await sb
      .from("profiles")
      .select("*")
      .eq("id", state.user.id)
      .maybeSingle();

    if (!data && !error) {
      // Fallback: create it if the trigger hasn't (rare)
      await sb.from("profiles").insert({
        id: state.user.id,
        email: state.user.email,
        full_name: state.user.user_metadata?.full_name || "",
      });
      ({ data } = await sb.from("profiles").select("*").eq("id", state.user.id).maybeSingle());
    }
    state.profile = data || {
      id: state.user.id,
      email: state.user.email,
      full_name: state.user.user_metadata?.full_name || state.user.email,
      role: "employee",
    };
  }

  // ==========================================================================
  //  SHELL / ROUTING
  // ==========================================================================
  function showAuth() {
    $("#app-shell").classList.add("hidden");
    $("#auth-screen").classList.remove("hidden");
  }

  function showApp() {
    $("#auth-screen").classList.add("hidden");
    $("#app-shell").classList.remove("hidden");

    const p = state.profile;
    const name = p.full_name || p.email;
    $("#user-name").textContent = name;
    $("#user-role").textContent = p.role;
    $("#user-avatar").textContent = (name || "?").trim().charAt(0);

    const isAdmin = p.role === "admin";
    $$(".admin-only").forEach((n) => n.classList.toggle("hidden", !isAdmin));

    route();
  }

  $$('[data-view]').forEach((node) => {
    node.addEventListener("click", (e) => {
      const view = node.dataset.view;
      if (node.tagName === "BUTTON") {
        e.preventDefault();
        location.hash = "#" + view;
      }
    });
  });
  window.addEventListener("hashchange", route);

  // mobile drawer
  const closeNav = () => $("#app-shell").classList.remove("nav-open");
  $("#menu-btn").addEventListener("click", () => $("#app-shell").classList.toggle("nav-open"));
  $("#nav-backdrop").addEventListener("click", closeNav);
  $$(".nav-item").forEach((n) => n.addEventListener("click", closeNav));
  window.addEventListener("hashchange", closeNav);

  function route() {
    if (!state.profile) return;
    let view = (location.hash || "#dashboard").slice(1);
    const adminViews = ["admin", "disburse"];
    if (adminViews.includes(view) && state.profile.role !== "admin") view = "dashboard";
    if (!["dashboard", "new", "trips", "newtrip", "petty", "newpetty", "admin", "disburse", "settings"].includes(view))
      view = "dashboard";

    $$(".nav-item").forEach((n) => n.classList.toggle("active", n.dataset.view === view));

    const titles = {
      dashboard: "My Requests",
      new: "New Payment Request",
      trips: "My Trip Claims",
      newtrip: "New Trip Reimbursement Claim",
      petty: "My Petty Cash",
      newpetty: "New Petty Cash Reimbursement",
      admin: "Admin Approvals",
      disburse: "Disburse",
      settings: "My Settings",
    };
    $("#view-title").textContent = titles[view];

    // context-aware top-bar "new" button
    const topNew = $("#topbar-new");
    const topNewFor = { dashboard: ["➕ New Request", "new"], trips: ["➕ New Trip Claim", "newtrip"], petty: ["➕ New Petty Cash", "newpetty"] };
    if (topNewFor[view]) {
      topNew.classList.remove("hidden");
      topNew.textContent = topNewFor[view][0];
      topNew.dataset.view = topNewFor[view][1];
    } else {
      topNew.classList.add("hidden");
    }

    if (view === "dashboard") renderDashboard();
    else if (view === "new") renderNewRequest();
    else if (view === "trips") renderTrips();
    else if (view === "newtrip") renderNewTrip();
    else if (view === "petty") renderPetty();
    else if (view === "newpetty") renderNewPetty();
    else if (view === "admin") renderAdmin();
    else if (view === "disburse") renderDisburse();
    else if (view === "settings") renderSettings();
  }

  // ==========================================================================
  //  VIEW: DASHBOARD (my requests)
  // ==========================================================================
  async function renderDashboard() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading your requests…</div>';

    const { data, error } = await sb
      .from("payment_requests")
      .select("*")
      .eq("requester_id", state.user.id)
      .order("created_at", { ascending: false });

    if (error) { root.innerHTML = errorBox(error.message); return; }

    if (!data.length) {
      root.innerHTML =
        '<div class="card panel empty"><div class="big">🧾</div>' +
        "<h3>No payment requests yet</h3>" +
        '<p class="sub">Create your first request to get started.</p>' +
        '<button class="btn btn-primary" onclick="location.hash=\'#new\'">➕ New Payment Request</button></div>';
      return;
    }

    root.innerHTML = requestsTable(data, false);
    wireRowClicks(root, data, false);
  }

  // ==========================================================================
  //  VIEW: NEW REQUEST
  // ==========================================================================
  function renderNewRequest() {
    const root = $("#view-root");
    root.innerHTML = `
      <form id="pr-form" class="card panel" style="max-width:820px">
        <h3>New Payment Request</h3>
        <p class="sub">Fill in the payment details and attach the invoice or bill.</p>
        <div class="form-grid">
          <label class="full">Purpose / Title
            <input name="title" required placeholder="e.g. Course equipment purchase — June" />
          </label>
          <label>Payee / Vendor name
            <input name="payee_name" required placeholder="Who receives the money" />
          </label>
          <label>Amount
            <input name="amount" type="number" step="0.01" min="0" required placeholder="0" />
          </label>
          <label>Currency
            <select name="currency">
              <option value="IDR" selected>IDR — Indonesian Rupiah</option>
              <option value="USD">USD — US Dollar</option>
              <option value="SGD">SGD — Singapore Dollar</option>
              <option value="EUR">EUR — Euro</option>
            </select>
          </label>
          <label>Transaction / transfer date
            <input name="transaction_date" type="date" />
          </label>
          <label>Bank name
            <input name="bank_name" placeholder="e.g. BCA" />
          </label>
          <label>Bank account name
            <input name="bank_account_name" placeholder="Account holder name" />
          </label>
          <label class="full">Bank account number
            <input name="bank_account_number" placeholder="Account number to transfer to" />
          </label>
          <label class="full">Notes / details
            <textarea name="description" placeholder="Any extra detail the approver should know"></textarea>
          </label>
          <div class="full">
            <label>Invoice / bill attachment</label>
            <label class="file-drop" id="file-drop">
              <input type="file" name="invoice" accept=".pdf,.png,.jpg,.jpeg,.webp,.gif" />
              <span id="file-label">📎 Click to attach a PDF or image (max 10&nbsp;MB)</span>
            </label>
          </div>
        </div>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Submit request</button>
          <button type="button" class="btn btn-ghost" onclick="location.hash='#dashboard'">Cancel</button>
        </div>
        <p id="pr-msg" class="msg"></p>
      </form>`;

    const fileInput = $('#pr-form input[name=invoice]');
    fileInput.addEventListener("change", () => {
      const f = fileInput.files[0];
      $("#file-label").innerHTML = f
        ? '<span class="file-name">📎 ' + esc(f.name) + "</span> — click to change"
        : "📎 Click to attach a PDF or image (max 10&nbsp;MB)";
    });

    $("#pr-form").addEventListener("submit", submitRequest);
  }

  async function submitRequest(e) {
    e.preventDefault();
    const form = e.target;
    const btn = form.querySelector("button[type=submit]");
    const msg = $("#pr-msg");
    const file = form.invoice.files[0];

    if (file && file.size > 10 * 1024 * 1024) {
      msg.textContent = "File is larger than 10 MB.";
      msg.className = "msg error";
      return;
    }

    btn.disabled = true;
    msg.className = "msg";
    msg.textContent = "Submitting…";

    try {
      let invoicePath = null;
      if (file) {
        const safe = file.name.replace(/[^\w.\-]+/g, "_").slice(-60);
        invoicePath = `${state.user.id}/${Date.now()}-${safe}`;
        const up = await sb.storage.from("invoices").upload(invoicePath, file, {
          cacheControl: "3600",
          upsert: false,
        });
        if (up.error) throw up.error;
      }

      const payload = {
        requester_id: state.user.id,
        title: form.title.value.trim(),
        payee_name: form.payee_name.value.trim(),
        amount: Number(form.amount.value),
        currency: form.currency.value,
        transaction_date: form.transaction_date.value || null,
        bank_name: form.bank_name.value.trim() || null,
        bank_account_name: form.bank_account_name.value.trim() || null,
        bank_account_number: form.bank_account_number.value.trim() || null,
        description: form.description.value.trim() || null,
        invoice_path: invoicePath,
      };

      const { error } = await sb.from("payment_requests").insert(payload);
      if (error) throw error;

      toast("Payment request submitted ✔");
      location.hash = "#dashboard";
    } catch (err) {
      msg.textContent = err.message || "Something went wrong.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
    }
  }

  // ==========================================================================
  //  VIEW: MY TRIP CLAIMS
  // ==========================================================================
  async function renderTrips() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading your trip claims…</div>';

    const { data, error } = await sb
      .from("trip_reimbursements")
      .select("*")
      .eq("requester_id", state.user.id)
      .order("created_at", { ascending: false });

    if (error) { root.innerHTML = errorBox(error.message); return; }

    if (!data.length) {
      root.innerHTML =
        '<div class="card panel empty"><div class="big">🚗</div>' +
        "<h3>No trip claims yet</h3>" +
        '<p class="sub">Submit your first trip reimbursement claim.</p>' +
        '<button class="btn btn-primary" onclick="location.hash=\'#newtrip\'">➕ New Trip Claim</button></div>';
      return;
    }

    root.innerHTML = tripsTable(data, false);
    wireRowClicks(root, data, false, {}, "trip");
  }

  // ==========================================================================
  //  VIEW: NEW TRIP REIMBURSEMENT CLAIM  (matches the Golf Solutions form)
  // ==========================================================================
  function renderNewTrip() {
    const root = $("#view-root");
    const claimItems = ["Parking fees", "Toll charges", "Other"];
    root.innerHTML = `
      <form id="trip-form" class="card panel" style="max-width:820px">
        <h3>Trip Reimbursement Claim</h3>
        <p class="sub">Complete your trip details and attach the map screenshot and receipt.</p>
        <div class="form-grid">
          <label>Name
            <input name="claimant_name" required value="${esc(state.profile.full_name || "")}" />
          </label>
          <label>Date of Trip
            <input name="trip_date" type="date" required />
          </label>
          <label>Vehicle Option
            <select name="vehicle_option" required>
              <option value="" disabled selected>Select…</option>
              <option value="Motorcycle">Motorcycle</option>
              <option value="Car">Car</option>
            </select>
          </label>
          <label>Total Kilometer (Round Trip)
            <input name="total_km" type="number" step="0.1" min="0" placeholder="e.g. 24" />
          </label>
          <label class="full">Trip Purpose
            <input name="trip_purpose" required placeholder="e.g. Site visit to Pondok Indah course" />
          </label>
          <label>Amount claimed <span class="hint">(optional)</span>
            <input name="amount" type="number" step="0.01" min="0" placeholder="Total to reimburse" />
          </label>
          <label>Currency
            <select name="currency">
              <option value="IDR" selected>IDR</option>
              <option value="USD">USD</option>
              <option value="SGD">SGD</option>
              <option value="EUR">EUR</option>
            </select>
          </label>
          <div class="full">
            <label>Which items are included in your reimbursement claim? <span class="hint">(select all that apply)</span></label>
            <div class="check-grid" id="claim-items">
              ${claimItems
                .map((it) => `<label><input type="checkbox" name="claim_item" value="${esc(it)}" /> ${esc(it)}</label>`)
                .join("")}
            </div>
            <input name="claim_items_other" placeholder="If 'Other', describe here" style="margin-top:8px" />
          </div>
          <div class="full">
            <label>Google Map Screenshots <span class="hint">(required)</span></label>
            <label class="file-drop" id="map-drop">
              <input type="file" name="map_screenshot" accept="image/*,.pdf" required />
              <span id="map-label">🗺️ Click to attach the Google Maps route screenshot</span>
            </label>
          </div>
          <div class="full">
            <label>Trip Receipt</label>
            <label class="file-drop" id="receipt-drop">
              <input type="file" name="receipt" accept="image/*,.pdf" />
              <span id="receipt-label">📎 Click to attach the trip receipt (toll / parking / fuel)</span>
            </label>
          </div>
        </div>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Submit claim</button>
          <button type="button" class="btn btn-ghost" onclick="location.hash='#trips'">Cancel</button>
        </div>
        <p id="trip-msg" class="msg"></p>
      </form>`;

    const wireFile = (inputName, labelId, defaultText) => {
      const inp = $(`#trip-form input[name=${inputName}]`);
      inp.addEventListener("change", () => {
        const f = inp.files[0];
        $("#" + labelId).innerHTML = f
          ? '<span class="file-name">📎 ' + esc(f.name) + "</span> — click to change"
          : defaultText;
      });
    };
    wireFile("map_screenshot", "map-label", "🗺️ Click to attach the Google Maps route screenshot");
    wireFile("receipt", "receipt-label", "📎 Click to attach the trip receipt (toll / parking / fuel)");

    $("#trip-form").addEventListener("submit", submitTrip);
  }

  async function submitTrip(e) {
    e.preventDefault();
    const form = e.target;
    const btn = form.querySelector("button[type=submit]");
    const msg = $("#trip-msg");
    const mapFile = form.map_screenshot.files[0];
    const receiptFile = form.receipt.files[0];

    for (const f of [mapFile, receiptFile]) {
      if (f && f.size > 10 * 1024 * 1024) {
        msg.textContent = "Each file must be under 10 MB.";
        msg.className = "msg error";
        return;
      }
    }

    btn.disabled = true;
    msg.className = "msg";
    msg.textContent = "Submitting…";

    const uploadTo = async (file, tag) => {
      if (!file) return null;
      const safe = file.name.replace(/[^\w.\-]+/g, "_").slice(-50);
      const path = `${state.user.id}/${tag}-${Date.now()}-${safe}`;
      const up = await sb.storage.from("trip-files").upload(path, file, { cacheControl: "3600", upsert: false });
      if (up.error) throw up.error;
      return path;
    };

    try {
      const mapPath = await uploadTo(mapFile, "map");
      const receiptPath = await uploadTo(receiptFile, "receipt");

      const items = $$('#trip-form input[name=claim_item]:checked').map((c) => c.value);

      const payload = {
        requester_id: state.user.id,
        claimant_name: form.claimant_name.value.trim(),
        trip_date: form.trip_date.value || null,
        vehicle_option: form.vehicle_option.value || null,
        trip_purpose: form.trip_purpose.value.trim(),
        total_km: form.total_km.value ? Number(form.total_km.value) : null,
        amount: form.amount.value ? Number(form.amount.value) : null,
        currency: form.currency.value,
        claim_items: items,
        claim_items_other: form.claim_items_other.value.trim() || null,
        map_screenshot_path: mapPath,
        receipt_path: receiptPath,
      };

      const { error } = await sb.from("trip_reimbursements").insert(payload);
      if (error) throw error;

      toast("Trip claim submitted ✔");
      location.hash = "#trips";
    } catch (err) {
      msg.textContent = err.message || "Something went wrong.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
    }
  }

  // ==========================================================================
  //  VIEW: MY PETTY CASH
  // ==========================================================================
  async function renderPetty() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading your petty cash claims…</div>';

    const { data, error } = await sb
      .from("petty_cash_claims")
      .select("*")
      .eq("requester_id", state.user.id)
      .order("created_at", { ascending: false });

    if (error) { root.innerHTML = errorBox(error.message); return; }

    if (!data.length) {
      root.innerHTML =
        '<div class="card panel empty"><div class="big">🧾</div>' +
        "<h3>No petty cash claims yet</h3>" +
        '<p class="sub">Create a claim and add each expense as a line.</p>' +
        '<button class="btn btn-primary" onclick="location.hash=\'#newpetty\'">➕ New Petty Cash</button></div>';
      return;
    }

    root.innerHTML = pettyTable(data, false);
    wireRowClicks(root, data, false, {}, "petty");
  }

  // ==========================================================================
  //  VIEW: NEW PETTY CASH (multi-line: keterangan, total, picture + grand total)
  // ==========================================================================
  function renderNewPetty() {
    const root = $("#view-root");
    root.innerHTML = `
      <form id="petty-form" class="card panel" style="max-width:900px">
        <h3>Petty Cash Reimbursement</h3>
        <p class="sub">Add each expense as a line — description (keterangan), total, and a photo of the receipt.</p>
        <div class="form-grid">
          <label>Title <span class="hint">(optional)</span>
            <input name="title" placeholder="e.g. Office supplies — week 30" />
          </label>
          <label>Claim date
            <input name="claim_date" type="date" />
          </label>
          <label>Currency
            <select name="currency">
              <option value="IDR" selected>IDR</option>
              <option value="USD">USD</option>
              <option value="SGD">SGD</option>
              <option value="EUR">EUR</option>
            </select>
          </label>
        </div>

        <div class="lines-head"><span>Keterangan</span><span>Total</span><span>Photo</span><span></span></div>
        <div id="lines"></div>
        <button type="button" class="btn btn-ghost btn-sm" id="add-line">➕ Add line</button>

        <div class="grand"><span>Grand total</span><span class="amount" id="grand-total">IDR 0</span></div>

        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Submit claim</button>
          <button type="button" class="btn btn-ghost" onclick="location.hash='#petty'">Cancel</button>
        </div>
        <p id="petty-msg" class="msg"></p>
      </form>`;

    $("#add-line").addEventListener("click", () => addPettyLine());
    $('#petty-form select[name=currency]').addEventListener("change", recomputePettyTotal);
    addPettyLine();
    addPettyLine();
    $("#petty-form").addEventListener("submit", submitPetty);
  }

  function addPettyLine() {
    const row = el(`
      <div class="line-row">
        <input type="text" class="ln-ket" placeholder="Description of expense" />
        <input type="number" class="ln-amt" step="0.01" min="0" placeholder="0" />
        <label class="ln-file-btn" title="Attach receipt photo">📷
          <input type="file" class="ln-file" accept="image/*,.pdf" />
        </label>
        <button type="button" class="ln-del" title="Remove line">✕</button>
      </div>`);

    row.querySelector(".ln-amt").addEventListener("input", recomputePettyTotal);
    row.querySelector(".ln-file").addEventListener("change", (e) => {
      const btn = row.querySelector(".ln-file-btn");
      const has = e.target.files.length > 0;
      btn.classList.toggle("has-file", has);
      btn.firstChild.textContent = has ? "✓" : "📷";
    });
    row.querySelector(".ln-del").addEventListener("click", () => {
      row.remove();
      recomputePettyTotal();
    });

    $("#lines").append(row);
  }

  function recomputePettyTotal() {
    const currency = $('#petty-form select[name=currency]').value;
    let total = 0;
    $$("#lines .ln-amt").forEach((i) => (total += Number(i.value) || 0));
    $("#grand-total").textContent = money(total, currency);
  }

  async function submitPetty(e) {
    e.preventDefault();
    const form = e.target;
    const btn = form.querySelector("button[type=submit]");
    const msg = $("#petty-msg");

    // collect non-empty lines
    const rowEls = $$("#lines .line-row");
    const lines = [];
    for (const row of rowEls) {
      const keterangan = row.querySelector(".ln-ket").value.trim();
      const amountRaw = row.querySelector(".ln-amt").value;
      const file = row.querySelector(".ln-file").files[0] || null;
      if (!keterangan && !amountRaw && !file) continue; // skip blank row
      if (!keterangan) { msg.textContent = "Every line needs a keterangan (description)."; msg.className = "msg error"; return; }
      if (file && file.size > 10 * 1024 * 1024) { msg.textContent = `"${file.name}" is over 10 MB.`; msg.className = "msg error"; return; }
      lines.push({ keterangan, amount: Number(amountRaw) || 0, file });
    }
    if (!lines.length) { msg.textContent = "Add at least one line."; msg.className = "msg error"; return; }

    const currency = form.currency.value;
    const total = lines.reduce((s, l) => s + l.amount, 0);

    btn.disabled = true;
    msg.className = "msg";
    msg.textContent = "Submitting…";

    let claimId = null;
    try {
      // 1) insert header
      const { data: header, error: hErr } = await sb
        .from("petty_cash_claims")
        .insert({
          requester_id: state.user.id,
          title: form.title.value.trim() || null,
          claim_date: form.claim_date.value || null,
          currency,
          total_amount: total,
        })
        .select()
        .single();
      if (hErr) throw hErr;
      claimId = header.id;

      // 2) upload each line's picture, then insert lines
      const lineRows = [];
      for (let i = 0; i < lines.length; i++) {
        const l = lines[i];
        let picturePath = null;
        if (l.file) {
          const safe = l.file.name.replace(/[^\w.\-]+/g, "_").slice(-50);
          picturePath = `${state.user.id}/${claimId}/${i}-${Date.now()}-${safe}`;
          const up = await sb.storage.from("petty-cash").upload(picturePath, l.file, { cacheControl: "3600", upsert: false });
          if (up.error) throw up.error;
        }
        lineRows.push({
          claim_id: claimId,
          requester_id: state.user.id,
          keterangan: l.keterangan,
          amount: l.amount,
          picture_path: picturePath,
          position: i,
        });
      }

      const { error: lErr } = await sb.from("petty_cash_lines").insert(lineRows);
      if (lErr) throw lErr;

      toast("Petty cash claim submitted ✔");
      location.hash = "#petty";
    } catch (err) {
      // best-effort rollback of the header if lines failed
      if (claimId) await sb.from("petty_cash_claims").delete().eq("id", claimId);
      msg.textContent = err.message || "Something went wrong.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
    }
  }

  // ==========================================================================
  //  VIEW: ADMIN
  // ==========================================================================
  async function renderAdmin() {
    const root = $("#view-root");
    const mod = state.adminModule;
    const table = TYPES[mod].table;
    root.innerHTML = '<div class="loading">Loading…</div>';

    let query = sb.from(table).select("*").order("created_at", { ascending: false });
    if (state.adminFilter !== "all") query = query.eq("status", state.adminFilter);

    const { data, error } = await query;
    if (error) { root.innerHTML = errorBox(error.message); return; }

    // fetch requester names
    const ids = [...new Set(data.map((r) => r.requester_id))];
    const nameMap = {};
    if (ids.length) {
      const { data: profs } = await sb.from("profiles").select("id,full_name,email").in("id", ids);
      (profs || []).forEach((p) => (nameMap[p.id] = p.full_name || p.email));
    }

    const seg = `
      <div class="seg">
        <button data-mod="payment" class="${mod === "payment" ? "active" : ""}">💳 Payment Requests</button>
        <button data-mod="trip" class="${mod === "trip" ? "active" : ""}">🚗 Trip Reimbursements</button>
        <button data-mod="petty" class="${mod === "petty" ? "active" : ""}">🧾 Petty Cash</button>
      </div>`;

    const filters = ["pending", "approved", "rejected", "all"];
    const pills = filters
      .map(
        (f) =>
          `<button class="filter-pill ${f === state.adminFilter ? "active" : ""}" data-filter="${f}">${
            f[0].toUpperCase() + f.slice(1)
          }</button>`
      )
      .join("");

    let body;
    if (!data.length) {
      body =
        '<div class="card panel empty"><div class="big">✅</div><h3>Nothing here</h3>' +
        `<p class="sub">No ${state.adminFilter === "all" ? "" : state.adminFilter} items.</p></div>`;
    } else if (mod === "trip") {
      body = tripsTable(data, true, nameMap);
    } else if (mod === "petty") {
      body = pettyTable(data, true, nameMap);
    } else {
      body = requestsTable(data, true, nameMap);
    }

    root.innerHTML = seg + `<div class="toolbar">${pills}</div>` + body;

    $$(".seg button").forEach((b) =>
      b.addEventListener("click", () => {
        state.adminModule = b.dataset.mod;
        renderAdmin();
      })
    );
    $$(".filter-pill").forEach((p) =>
      p.addEventListener("click", () => {
        state.adminFilter = p.dataset.filter;
        renderAdmin();
      })
    );
    wireRowClicks(root, data, true, nameMap, mod);
  }

  // ==========================================================================
  //  Shared: request table + detail modal
  // ==========================================================================
  function requestsTable(rows, isAdmin, nameMap = {}) {
    const head = `
      <tr>
        ${isAdmin ? "<th>Requester</th>" : ""}
        <th>Title</th><th>Payee</th><th>Amount</th><th>Date</th><th>Status</th>
      </tr>`;
    const trs = rows
      .map(
        (r) => `
        <tr data-id="${r.id}">
          ${isAdmin ? `<td>${esc(nameMap[r.requester_id] || "—")}</td>` : ""}
          <td>${esc(r.title)}</td>
          <td>${esc(r.payee_name)}</td>
          <td class="amount">${money(r.amount, r.currency)}</td>
          <td>${fmtDate(r.transaction_date || r.created_at)}</td>
          <td><span class="badge ${r.status}">${r.status}</span></td>
        </tr>`
      )
      .join("");
    return `<div class="card table-wrap"><table><thead>${head}</thead><tbody>${trs}</tbody></table></div>`;
  }

  function tripsTable(rows, isAdmin, nameMap = {}) {
    const head = `
      <tr>
        ${isAdmin ? "<th>Requester</th>" : ""}
        <th>Purpose</th><th>Vehicle</th><th>Km</th><th>Amount</th><th>Trip date</th><th>Status</th>
      </tr>`;
    const trs = rows
      .map(
        (r) => `
        <tr data-id="${r.id}">
          ${isAdmin ? `<td>${esc(nameMap[r.requester_id] || "—")}</td>` : ""}
          <td>${esc(r.trip_purpose || "—")}</td>
          <td>${esc(r.vehicle_option || "—")}</td>
          <td class="amount">${r.total_km != null ? esc(r.total_km) : "—"}</td>
          <td class="amount">${r.amount != null ? money(r.amount, r.currency) : "—"}</td>
          <td>${fmtDate(r.trip_date || r.created_at)}</td>
          <td><span class="badge ${r.status}">${r.status}</span></td>
        </tr>`
      )
      .join("");
    return `<div class="card table-wrap"><table><thead>${head}</thead><tbody>${trs}</tbody></table></div>`;
  }

  function pettyTable(rows, isAdmin, nameMap = {}) {
    const head = `
      <tr>
        ${isAdmin ? "<th>Requester</th>" : ""}
        <th>Title</th><th>Claim date</th><th>Grand total</th><th>Status</th>
      </tr>`;
    const trs = rows
      .map(
        (r) => `
        <tr data-id="${r.id}">
          ${isAdmin ? `<td>${esc(nameMap[r.requester_id] || "—")}</td>` : ""}
          <td>${esc(r.title || "Petty cash reimbursement")}</td>
          <td>${fmtDate(r.claim_date || r.created_at)}</td>
          <td class="amount">${money(r.total_amount, r.currency)}</td>
          <td><span class="badge ${r.status}">${r.status}</span></td>
        </tr>`
      )
      .join("");
    return `<div class="card table-wrap"><table><thead>${head}</thead><tbody>${trs}</tbody></table></div>`;
  }

  function wireRowClicks(root, rows, isAdmin, nameMap = {}, type = "payment") {
    $$("tbody tr", root).forEach((tr) =>
      tr.addEventListener("click", () => {
        const r = rows.find((x) => x.id === tr.dataset.id);
        if (r) openDetail(r, isAdmin, nameMap, type);
      })
    );
  }

  // descriptor per record type
  const TYPES = {
    payment: {
      table: "payment_requests", label: "Payment", title: (r) => r.title,
      amount: (r) => r.amount, currency: (r) => r.currency,
    },
    trip: {
      table: "trip_reimbursements", label: "Trip", title: (r) => r.trip_purpose || "Trip reimbursement",
      amount: (r) => r.amount, currency: (r) => r.currency,
    },
    petty: {
      table: "petty_cash_claims", label: "Petty cash", title: (r) => r.title || "Petty cash reimbursement",
      amount: (r) => r.total_amount, currency: (r) => r.currency,
    },
  };

  async function openDetail(r, isAdmin, nameMap = {}, type = "payment") {
    const requester = nameMap[r.requester_id] || (r.requester_id === state.user.id ? "You" : "—");
    let rows, files;

    if (type === "trip") {
      rows = [
        ["Requester", requester],
        ["Claimant name", r.claimant_name],
        ["Date of trip", fmtDate(r.trip_date)],
        ["Vehicle", r.vehicle_option || "—"],
        ["Trip purpose", r.trip_purpose || "—"],
        ["Total km (round trip)", r.total_km != null ? r.total_km + " km" : "—"],
        ["Claim items", (r.claim_items || []).join(", ") + (r.claim_items_other ? " — " + r.claim_items_other : "") || "—"],
        ["Amount claimed", r.amount != null ? money(r.amount, r.currency) : "—"],
        ["Submitted", fmtDate(r.created_at)],
      ];
      files = [
        { label: "🗺️ View Google Map screenshot", bucket: "trip-files", path: r.map_screenshot_path },
        { label: "📎 View trip receipt", bucket: "trip-files", path: r.receipt_path },
      ];
    } else if (type === "petty") {
      rows = [
        ["Requester", requester],
        ["Title", r.title || "—"],
        ["Claim date", fmtDate(r.claim_date)],
        ["Grand total", money(r.total_amount, r.currency)],
        ["Submitted", fmtDate(r.created_at)],
      ];
      files = [];
    } else {
      rows = [
        ["Requester", requester],
        ["Payee / Vendor", r.payee_name],
        ["Amount", money(r.amount, r.currency)],
        ["Transfer date", fmtDate(r.transaction_date)],
        ["Bank name", r.bank_name || "—"],
        ["Account name", r.bank_account_name || "—"],
        ["Account number", r.bank_account_number || "—"],
        ["Submitted", fmtDate(r.created_at)],
      ];
      if (r.description) rows.push(["Notes", r.description]);
      files = [{ label: "📎 View invoice / bill", bucket: "invoices", path: r.invoice_path }];
    }

    if (r.status !== "pending") {
      rows.push(["Reviewed", fmtDate(r.reviewed_at)]);
      if (r.review_note) rows.push(["Review note", r.review_note]);
    }
    if (r.paid_at) rows.push(["💸 Paid on", fmtDate(r.paid_at)]);

    const detailHtml = rows
      .map((x) => `<div class="detail-row"><span class="k">${esc(x[0])}</span><span class="v">${esc(x[1])}</span></div>`)
      .join("");

    const card = el(`
      <div>
        <div style="display:flex;justify-content:space-between;align-items:start;gap:12px">
          <div>
            <h3 style="margin:0 0 4px">${esc(TYPES[type].title(r))}</h3>
            <span class="badge ${r.status}">${r.status}</span>
          </div>
          <button class="btn btn-ghost btn-sm" data-close>✕</button>
        </div>
        <div style="margin-top:16px">${detailHtml}</div>
        <div id="lines-slot" style="margin-top:14px"></div>
        <div id="file-slot" class="chips" style="margin-top:14px"></div>
        <div id="detail-actions" class="modal-actions"></div>
        <p id="detail-msg" class="msg"></p>
      </div>`);

    openModal(card);

    // petty cash: load line items + per-line receipt links
    if (type === "petty") {
      const ls = card.querySelector("#lines-slot");
      ls.innerHTML = '<div class="loading" style="padding:14px">Loading items…</div>';
      const { data: lines, error } = await sb
        .from("petty_cash_lines")
        .select("*")
        .eq("claim_id", r.id)
        .order("position", { ascending: true });

      if (error) {
        ls.innerHTML = errorBox(error.message);
      } else {
        const lineRows = await Promise.all(
          (lines || []).map(async (ln, i) => {
            let link = "—";
            if (ln.picture_path) {
              const { data } = await sb.storage.from("petty-cash").createSignedUrl(ln.picture_path, 120);
              if (data) link = `<a href="${data.signedUrl}" target="_blank" rel="noopener">📎 View</a>`;
            }
            return `<tr><td>${i + 1}</td><td>${esc(ln.keterangan)}</td><td class="amount">${money(
              ln.amount, r.currency
            )}</td><td>${link}</td></tr>`;
          })
        );
        ls.innerHTML =
          '<div class="table-wrap"><table><thead><tr><th>#</th><th>Keterangan</th><th>Total</th><th>Picture</th></tr></thead><tbody>' +
          lineRows.join("") +
          `<tr><td></td><td style="text-align:right;font-weight:700">Grand total</td><td class="amount" style="font-weight:700">${money(
            r.total_amount, r.currency
          )}</td><td></td></tr></tbody></table></div>`;
      }
    }

    // file links (signed URLs)
    const slot = card.querySelector("#file-slot");
    for (const f of files.filter((x) => x.path)) {
      const link = el('<span class="hint">Loading file…</span>');
      slot.append(link);
      const { data, error } = await sb.storage.from(f.bucket).createSignedUrl(f.path, 120);
      if (error) link.textContent = "(attachment unavailable) ";
      else link.replaceWith(
        el(`<a class="btn btn-ghost btn-sm" href="${data.signedUrl}" target="_blank" rel="noopener">${f.label}</a>`)
      );
    }

    const actions = card.querySelector("#detail-actions");

    // Admin: approve / reject (with optional note field shown up front)
    if (isAdmin && r.status === "pending") {
      const noteWrap = el(`
        <label style="display:block;margin:6px 0 12px">Note to requester (optional)
          <input id="detail-note-input" placeholder="Reason / comment" />
        </label>`);
      actions.before(noteWrap);

      const approve = el('<button class="btn btn-success">✔ Approve</button>');
      const reject = el('<button class="btn btn-danger">✕ Reject</button>');
      approve.addEventListener("click", () => reviewRequest(r, "approved", card, approve, reject, type));
      reject.addEventListener("click", () => reviewRequest(r, "rejected", card, approve, reject, type));
      actions.append(approve, reject);
    }

    // Admin: mark an approved & unpaid item as paid (disbursed)
    if (isAdmin && r.status === "approved" && !r.paid_at) {
      const pay = el('<button class="btn btn-primary">💸 Mark as paid</button>');
      pay.addEventListener("click", async () => {
        pay.disabled = true;
        const ok = await markPaid(type, r.id);
        if (ok) closeModal();
        else pay.disabled = false;
      });
      actions.append(pay);
    }

    // Owner: delete own pending request
    if (!isAdmin && r.status === "pending" && r.requester_id === state.user.id) {
      const del = el('<button class="btn btn-danger">Delete</button>');
      del.addEventListener("click", async () => {
        if (!confirm("Delete this pending item?")) return;
        const { error } = await sb.from(TYPES[type].table).delete().eq("id", r.id);
        if (error) { toast(error.message, "error"); return; }
        closeModal();
        toast("Deleted");
        route();
      });
      actions.append(del);
    }
  }

  async function reviewRequest(r, status, card, approveBtn, rejectBtn, type = "payment") {
    const note = card.querySelector("#detail-note-input")?.value?.trim();
    if (approveBtn) approveBtn.disabled = true;
    if (rejectBtn) rejectBtn.disabled = true;

    const msg = card.querySelector("#detail-msg");
    msg.className = "msg";
    msg.textContent = status === "approved" ? "Approving…" : "Rejecting…";

    const { error } = await sb
      .from(TYPES[type].table)
      .update({
        status,
        review_note: note || null,
        reviewed_by: state.user.id,
        reviewed_at: new Date().toISOString(),
      })
      .eq("id", r.id);

    if (error) {
      msg.textContent = error.message;
      msg.className = "msg error";
      if (approveBtn) approveBtn.disabled = false;
      if (rejectBtn) rejectBtn.disabled = false;
      return;
    }
    closeModal();
    toast(status === "approved" ? "Approved ✔" : "Rejected", status === "approved" ? "ok" : "error");
    renderAdmin();
  }

  async function markPaid(type, id) {
    const { error } = await sb
      .from(TYPES[type].table)
      .update({ paid_at: new Date().toISOString(), paid_by: state.user.id })
      .eq("id", id);
    if (error) { toast(error.message, "error"); return false; }
    toast("Marked as paid 💸");
    route(); // refresh whichever view is active
    return true;
  }

  // ==========================================================================
  //  VIEW: DISBURSE (admin) — approved & unpaid items, grouped by user
  // ==========================================================================
  async function renderDisburse() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading items to disburse…</div>';

    const pull = (table) =>
      sb.from(table).select("*").eq("status", "approved").is("paid_at", null).order("reviewed_at", { ascending: true });

    const [pay, trip, petty] = await Promise.all([
      pull("payment_requests"),
      pull("trip_reimbursements"),
      pull("petty_cash_claims"),
    ]);
    const firstErr = pay.error || trip.error || petty.error;
    if (firstErr) { root.innerHTML = errorBox(firstErr.message); return; }

    const items = [
      ...(pay.data || []).map((r) => ({ type: "payment", r })),
      ...(trip.data || []).map((r) => ({ type: "trip", r })),
      ...(petty.data || []).map((r) => ({ type: "petty", r })),
    ];

    if (!items.length) {
      root.innerHTML =
        '<div class="card panel empty"><div class="big">🎉</div><h3>All settled</h3>' +
        '<p class="sub">No approved items are waiting to be paid.</p></div>';
      return;
    }

    // fetch requester profiles (name + rekening)
    const ids = [...new Set(items.map((it) => it.r.requester_id))];
    const profMap = {};
    const { data: profs } = await sb
      .from("profiles")
      .select("id,full_name,email,bank_name,bank_account_number,bank_account_name")
      .in("id", ids);
    const nameMap = {};
    (profs || []).forEach((p) => {
      profMap[p.id] = p;
      nameMap[p.id] = p.full_name || p.email;
    });

    // group by requester
    const groups = {};
    items.forEach((it) => {
      (groups[it.r.requester_id] = groups[it.r.requester_id] || []).push(it);
    });

    const grandCount = items.length;
    let html = `<p class="sub" style="margin:-6px 0 18px">${grandCount} approved item${
      grandCount === 1 ? "" : "s"
    } across ${Object.keys(groups).length} employee${Object.keys(groups).length === 1 ? "" : "s"} awaiting payment.</p>`;

    for (const uid of Object.keys(groups)) {
      const p = profMap[uid] || {};
      const name = p.full_name || p.email || "Unknown user";
      const groupItems = groups[uid];

      // employee rekening (for trip / petty reimbursements)
      const hasRek = p.bank_account_number;
      const bankLine = hasRek
        ? `<div class="dg-bank">${esc(p.bank_name || "Bank")} · <span class="rek">${esc(
            p.bank_account_number
          )}</span>${p.bank_account_name ? " · " + esc(p.bank_account_name) : ""}</div>`
        : `<div class="dg-bank missing">⚠️ No rekening on file — ask ${esc(name)} to set it in My Settings</div>`;

      // per-currency subtotal
      const totals = {};
      groupItems.forEach((it) => {
        const cur = TYPES[it.type].currency(it.r) || "IDR";
        const amt = Number(TYPES[it.type].amount(it.r) || 0);
        totals[cur] = (totals[cur] || 0) + amt;
      });
      const totalStr = Object.entries(totals).map(([c, v]) => money(v, c)).join(" + ");

      const rowsHtml = groupItems
        .map((it) => {
          const { type, r } = it;
          const amt = TYPES[type].amount(r);
          // where the money goes
          let payTo;
          if (type === "payment") {
            payTo = r.bank_account_number
              ? `<span class="rek">${esc(r.bank_name || "")} ${esc(r.bank_account_number)}</span>${
                  r.bank_account_name ? " · " + esc(r.bank_account_name) : ""
                }`
              : `payee: ${esc(r.payee_name || "—")}`;
          } else {
            payTo = hasRek ? `<span class="rek">${esc(p.bank_name || "")} ${esc(p.bank_account_number)}</span>` : "— (no rekening)";
          }
          return `
            <tr data-type="${type}" data-id="${r.id}">
              <td><span class="type-tag ${type}">${TYPES[type].label}</span></td>
              <td>${esc(TYPES[type].title(r))}</td>
              <td>${fmtDate(r.reviewed_at)}</td>
              <td class="amount">${amt != null ? money(amt, TYPES[type].currency(r)) : "—"}</td>
              <td class="paytiny">${payTo}</td>
              <td><button class="btn btn-primary btn-sm mark-paid" data-type="${type}" data-id="${r.id}">Mark paid</button></td>
            </tr>`;
        })
        .join("");

      html += `
        <div class="card panel disburse-group">
          <div class="dg-head">
            <div>
              <div class="dg-user">${esc(name)}</div>
              ${bankLine}
            </div>
            <div style="display:flex;align-items:center;gap:14px">
              <div class="dg-total"><div class="lbl">To pay</div><div class="val">${totalStr}</div></div>
              <button class="btn btn-ghost btn-sm print-group" data-uid="${uid}">🖨️ Print</button>
            </div>
          </div>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Type</th><th>Description</th><th>Approved</th><th>Amount</th><th>Pay to</th><th></th></tr></thead>
              <tbody>${rowsHtml}</tbody>
            </table>
          </div>
        </div>`;
    }

    root.innerHTML = html;

    // row click -> detail modal (ignore clicks on the Mark-paid button)
    $$("tbody tr", root).forEach((tr) => {
      tr.addEventListener("click", (e) => {
        if (e.target.closest(".mark-paid")) return;
        const it = items.find((x) => x.type === tr.dataset.type && x.r.id === tr.dataset.id);
        if (it) openDetail(it.r, true, nameMap, it.type);
      });
    });
    // mark-paid buttons
    $$(".mark-paid", root).forEach((b) =>
      b.addEventListener("click", async (e) => {
        e.stopPropagation();
        b.disabled = true;
        await markPaid(b.dataset.type, b.dataset.id);
      })
    );
    // print buttons (one printable payout sheet per employee)
    $$(".print-group", root).forEach((b) =>
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        printDisbursement(profMap[b.dataset.uid] || {}, groups[b.dataset.uid] || []);
      })
    );
  }

  // Build a printable "Payment Disbursement Instruction" for one employee and
  // open the browser print dialog (where the user can "Save as PDF").
  function printDisbursement(p, groupItems) {
    const name = p.full_name || p.email || "Unknown user";
    const today = new Date().toLocaleDateString("en-GB", { day: "2-digit", month: "long", year: "numeric" });

    const totals = {};
    groupItems.forEach((it) => {
      const cur = TYPES[it.type].currency(it.r) || "IDR";
      totals[cur] = (totals[cur] || 0) + Number(TYPES[it.type].amount(it.r) || 0);
    });
    const totalStr = Object.entries(totals).map(([c, v]) => money(v, c)).join("  +  ");

    const rekText = p.bank_account_number
      ? `${p.bank_name || "Bank"} — ${p.bank_account_number}${p.bank_account_name ? " (" + p.bank_account_name + ")" : ""}`
      : "No rekening on file";

    const rowsHtml = groupItems
      .map((it, i) => {
        const { type, r } = it;
        const amt = TYPES[type].amount(r);
        let payTo;
        if (type === "payment") {
          payTo = r.bank_account_number
            ? `${r.bank_name || ""} ${r.bank_account_number}${r.bank_account_name ? " (" + r.bank_account_name + ")" : ""}`.trim()
            : "Payee: " + (r.payee_name || "—");
        } else {
          payTo = p.bank_account_number ? `${p.bank_name || ""} ${p.bank_account_number}`.trim() : "(no rekening on file)";
        }
        return `<tr>
            <td>${i + 1}</td>
            <td>${esc(TYPES[type].label)}</td>
            <td>${esc(TYPES[type].title(r))}</td>
            <td>${esc(fmtDate(r.reviewed_at))}</td>
            <td class="r">${amt != null ? esc(money(amt, TYPES[type].currency(r))) : "—"}</td>
            <td>${esc(payTo)}</td>
          </tr>`;
      })
      .join("");

    const company = (cfg.COMPANY_NAME || "Company");
    const preparedBy = state.profile.full_name || state.profile.email || "";

    const doc = `<!doctype html><html><head><meta charset="utf-8"><title>Disbursement — ${esc(name)}</title>
      <style>
        :root { color-scheme: light; }
        * { box-sizing: border-box; }
        html, body { background: #ffffff; }
        body { font-family: -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; color: #14211b; margin: 32px; }
        .head { display:flex; justify-content:space-between; align-items:flex-start; border-bottom:3px solid #157347; padding-bottom:14px; margin-bottom:20px; }
        .company { font-size:22px; font-weight:800; color:#0f5132; }
        .doc-title { font-size:13px; letter-spacing:.08em; text-transform:uppercase; color:#5f6f68; margin-top:2px; }
        .meta { text-align:right; font-size:12px; color:#5f6f68; }
        .who { background:#e8f5ee; border-radius:10px; padding:14px 16px; margin-bottom:18px; }
        .who .n { font-size:17px; font-weight:700; }
        .who .r { font-size:14px; margin-top:4px; }
        .who .r b { font-variant-numeric: tabular-nums; }
        table { width:100%; border-collapse:collapse; font-size:13px; margin-top:6px; }
        th, td { text-align:left; padding:9px 10px; border-bottom:1px solid #e2e8e4; vertical-align:top; }
        th { background:#f4f7f5; font-size:11px; text-transform:uppercase; letter-spacing:.04em; color:#5f6f68; }
        td.r, th.r { text-align:right; font-variant-numeric: tabular-nums; white-space:nowrap; }
        .total { display:flex; justify-content:flex-end; gap:24px; align-items:baseline; margin-top:16px; font-size:16px; }
        .total .val { font-size:20px; font-weight:800; color:#0f5132; font-variant-numeric: tabular-nums; }
        .note { margin-top:22px; font-size:12.5px; color:#35443c; }
        .sign { display:flex; gap:60px; margin-top:48px; font-size:12px; color:#5f6f68; }
        .sign .box { flex:1; }
        .sign .line { border-top:1px solid #9aa8a1; margin-top:44px; padding-top:6px; }
        .toolbar { margin-bottom:18px; }
        .btn { font:inherit; font-weight:600; background:#157347; color:#fff; border:0; border-radius:8px; padding:9px 16px; cursor:pointer; }
        @media print { .toolbar { display:none; } body { margin:0; } }
      </style></head><body>
      <div class="toolbar"><button class="btn" onclick="window.print()">🖨️ Print / Save as PDF</button></div>
      <div class="head">
        <div><div class="company">${esc(company)}</div><div class="doc-title">Payment Disbursement Instruction</div></div>
        <div class="meta">Date: ${esc(today)}<br>Ref: DISB-${new Date().getFullYear()}-${esc(
      (name || "XX").slice(0, 3).toUpperCase()
    )}</div>
      </div>
      <div class="who">
        <div class="n">${esc(name)}</div>
        <div class="r">Employee bank account (rekening): <b>${esc(rekText)}</b></div>
      </div>
      <table>
        <thead><tr><th>#</th><th>Type</th><th>Description</th><th>Approved</th><th class="r">Amount</th><th>Pay to account</th></tr></thead>
        <tbody>${rowsHtml}</tbody>
      </table>
      <div class="total"><span>Total to transfer</span><span class="val">${esc(totalStr)}</span></div>
      <div class="note">Please process the transfer(s) listed above to the indicated account(s) and confirm once completed.</div>
      <div class="sign">
        <div class="box"><div class="line">Prepared by${preparedBy ? " — " + esc(preparedBy) : ""}</div></div>
        <div class="box"><div class="line">Transferred by</div></div>
      </div>
      <script>window.addEventListener('load',function(){setTimeout(function(){window.print();},250);});<\/script>
      </body></html>`;

    const w = window.open("", "_blank");
    if (!w) { toast("Allow pop-ups for this site to print", "error"); return; }
    w.document.open();
    w.document.write(doc);
    w.document.close();
  }

  // ==========================================================================
  //  VIEW: MY SETTINGS — bank account (rekening) + name
  // ==========================================================================
  function renderSettings() {
    const root = $("#view-root");
    const p = state.profile;
    root.innerHTML = `
      <form id="settings-form" class="card panel" style="max-width:640px">
        <h3>My Settings</h3>
        <p class="sub">Your bank account is where your trip &amp; petty-cash reimbursements are paid.</p>
        <div class="form-grid">
          <label class="full">Full name
            <input name="full_name" value="${esc(p.full_name || "")}" />
          </label>
          <label>Bank name
            <input name="bank_name" value="${esc(p.bank_name || "")}" placeholder="e.g. BCA" />
          </label>
          <label>Account number (rekening)
            <input name="bank_account_number" value="${esc(p.bank_account_number || "")}" placeholder="Your account number" />
          </label>
          <label class="full">Account holder name
            <input name="bank_account_name" value="${esc(p.bank_account_name || "")}" placeholder="Name on the account" />
          </label>
        </div>
        <div class="detail-row" style="border:0"><span class="k">Email</span><span class="v">${esc(p.email || "")}</span></div>
        <div class="detail-row" style="border:0"><span class="k">Role</span><span class="v" style="text-transform:capitalize">${esc(
          p.role || "employee"
        )}</span></div>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Save settings</button>
        </div>
        <p id="settings-msg" class="msg"></p>
      </form>`;

    $("#settings-form").addEventListener("submit", async (e) => {
      e.preventDefault();
      const form = e.target;
      const btn = form.querySelector("button[type=submit]");
      const msg = $("#settings-msg");
      btn.disabled = true;
      msg.className = "msg";
      msg.textContent = "Saving…";

      const patch = {
        full_name: form.full_name.value.trim(),
        bank_name: form.bank_name.value.trim() || null,
        bank_account_number: form.bank_account_number.value.trim() || null,
        bank_account_name: form.bank_account_name.value.trim() || null,
      };
      const { error } = await sb.from("profiles").update(patch).eq("id", state.user.id);
      btn.disabled = false;
      if (error) { msg.textContent = error.message; msg.className = "msg error"; return; }

      Object.assign(state.profile, patch);
      $("#user-name").textContent = state.profile.full_name || state.profile.email;
      $("#user-avatar").textContent = (state.profile.full_name || state.profile.email || "?").trim().charAt(0);
      msg.textContent = "Saved ✔";
      msg.className = "msg ok";
      toast("Settings saved ✔");
    });
  }

  function errorBox(text) {
    return `<div class="card panel"><p class="msg error">⚠️ ${esc(text)}</p></div>`;
  }

  // ---- Boot ----------------------------------------------------------------
  (async function boot() {
    const { data } = await sb.auth.getSession();
    handleSession(data.session);
  })();
})();

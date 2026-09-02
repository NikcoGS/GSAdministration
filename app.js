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
    users: null,            // cached user_directory rows
    recvFilter: "assigned", // "assigned" | "mine" | "all"
    movFilter: "assigned",
    trackModule: "receiving", // admin tracking: "receiving" | "movement"
    trackFilter: "all",
    purchAll: null,           // cached purchasing book rows
    purchSearch: "",
    purchFilter: "all",
  };

  const LOCATIONS = ["Manhattan", "Sedayu", "Premiere"];

  // ---- feature access -------------------------------------------------------
  const FEATURES = [
    ["payment", "💳 Payment requests"],
    ["trip", "🚗 Trip reimbursement"],
    ["petty", "🧾 Petty cash"],
    ["siteops", "📥 Site operations"],
    ["approval", "🛡️ Admin approvals"],
    ["disburse", "💸 Disburse"],
    ["tracking", "📦 Site ops tracking"],
    ["purchasing", "📚 Purchasing book"],
  ];
  const EMPLOYEE_DEFAULT = ["payment", "trip", "petty", "siteops"];
  const ADMIN_FEATURES = ["approval", "disburse", "tracking", "purchasing"];

  // mirrors public.has_perm() in the database
  function permsOf(profile) {
    if (!profile) return [];
    if (Array.isArray(profile.permissions)) return profile.permissions;
    return profile.role === "admin" ? FEATURES.map((f) => f[0]) : EMPLOYEE_DEFAULT;
  }
  const can = (feature) => permsOf(state.profile).includes(feature);
  const canAny = (list) => list.some((f) => can(f));

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
  const fmtDateTime = (d) =>
    d ? new Date(d).toLocaleString("en-GB", { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" }) : "—";

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

    // hide anything this user has no feature access to
    $$("[data-feat]").forEach((n) => {
      const f = n.dataset.feat;
      const allowed = f === "_anyadmin" ? canAny(ADMIN_FEATURES) || isAdmin : can(f);
      n.classList.toggle("hidden", !allowed);
    });

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

  // delegated navigation for dynamically-rendered buttons (data-nav="#view")
  document.addEventListener("click", (e) => {
    const nav = e.target.closest("[data-nav]");
    if (nav) {
      e.preventDefault();
      location.hash = nav.dataset.nav;
    }
  });

  function route() {
    if (!state.profile) return;
    let view = (location.hash || "#dashboard").slice(1);
    const allViews = ["dashboard", "new", "trips", "newtrip", "petty", "newpetty",
      "receiving", "newreceiving", "movements", "newmovement", "admin", "disburse",
      "tracking", "purchasing", "users", "settings", "noaccess"];
    if (!allViews.includes(view)) view = "dashboard";

    // feature gating: send people to something they can actually open
    const VIEW_FEATURE = {
      dashboard: "payment", new: "payment",
      trips: "trip", newtrip: "trip",
      petty: "petty", newpetty: "petty",
      receiving: "siteops", newreceiving: "siteops", movements: "siteops", newmovement: "siteops",
      admin: "approval", disburse: "disburse", tracking: "tracking", purchasing: "purchasing",
    };
    if (view === "users" && state.profile.role !== "admin") view = "settings";

    // brand-new account with nothing granted yet
    const noAccess = permsOf(state.profile).length === 0 && state.profile.role !== "admin";
    if (noAccess && view !== "settings") view = "noaccess";

    const needed = VIEW_FEATURE[view];
    if (needed && !can(needed)) {
      const firstAllowed = Object.keys(VIEW_FEATURE).find((v) => can(VIEW_FEATURE[v]));
      view = firstAllowed || (noAccess ? "noaccess" : "settings");
    }

    $$(".nav-item").forEach((n) => n.classList.toggle("active", n.dataset.view === view));

    const titles = {
      dashboard: "My Requests",
      new: "New Payment Request",
      trips: "My Trip Claims",
      newtrip: "New Trip Reimbursement Claim",
      petty: "My Petty Cash",
      newpetty: "New Petty Cash Reimbursement",
      receiving: "Item Receiving",
      newreceiving: "New Receiving",
      movements: "Store Movement",
      newmovement: "New Store Movement",
      admin: "Admin Approvals",
      disburse: "Disburse",
      tracking: "Site Ops Tracking",
      purchasing: "Purchasing Book",
      users: "Users & Access",
      settings: "My Settings",
      noaccess: "Welcome",
    };
    $("#view-title").textContent = titles[view];

    // context-aware top-bar "new" button
    const topNew = $("#topbar-new");
    const topNewFor = {
      dashboard: ["➕ New Request", "new"],
      trips: ["➕ New Trip Claim", "newtrip"],
      petty: ["➕ New Petty Cash", "newpetty"],
      receiving: ["➕ New Receiving", "newreceiving"],
      movements: ["➕ New Movement", "newmovement"],
    };
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
    else if (view === "receiving") renderReceiving();
    else if (view === "newreceiving") renderNewReceiving();
    else if (view === "movements") renderMovements();
    else if (view === "newmovement") renderNewMovement();
    else if (view === "admin") renderAdmin();
    else if (view === "disburse") renderDisburse();
    else if (view === "tracking") renderTracking();
    else if (view === "purchasing") renderPurchasing();
    else if (view === "users") renderUsers();
    else if (view === "settings") renderSettings();
    else if (view === "noaccess") renderNoAccess();
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
        '<button class="btn btn-primary" data-nav="#new">➕ New Payment Request</button></div>';
      return;
    }

    root.innerHTML = requestsTable(data, false);
    wireRowClicks(root, data, false);
  }

  // ==========================================================================
  //  VIEW: NEW REQUEST — split into Supplier payment / Expenses payment
  // ==========================================================================
  function renderNewRequest() {
    const root = $("#view-root");
    const t = state.payType || "expense";
    root.innerHTML = `
      <div class="seg">
        <button data-pt="supplier" class="${t === "supplier" ? "active" : ""}">🏭 Supplier payment</button>
        <button data-pt="expense" class="${t === "expense" ? "active" : ""}">🧾 Expenses payment</button>
      </div>
      <div id="pay-form-slot"></div>`;
    $$(".seg button", root).forEach((b) =>
      b.addEventListener("click", () => { state.payType = b.dataset.pt; renderNewRequest(); })
    );
    if (t === "supplier") renderSupplierForm($("#pay-form-slot"));
    else renderExpenseForm($("#pay-form-slot"));
  }

  // Send a file to the parse function and return the extracted data.
  // mode: undefined (receiving PO) | "invoice" | "payment_proof"
  async function readDocument(file, mode) {
    if (file.size > 8 * 1024 * 1024) throw new Error("File is too large to read automatically (max 8 MB).");
    const b64 = await new Promise((res, rej) => {
      const rd = new FileReader();
      rd.onload = () => res(String(rd.result).split(",")[1]);
      rd.onerror = rej;
      rd.readAsDataURL(file);
    });
    const mediaType = file.type || (file.name.toLowerCase().endsWith(".pdf") ? "application/pdf" : "image/jpeg");
    const { data, error } = await sb.functions.invoke("swift-action", {
      body: { data: b64, media_type: mediaType, ...(mode ? { mode } : {}) },
    });
    if (error) {
      let detail = "";
      try { detail = (await error.context?.json())?.error || ""; } catch { /* ignore */ }
      throw new Error(detail || "Document reading is unavailable — is the parse function deployed and up to date?");
    }
    if (data?.error) throw new Error(data.error);
    return data;
  }

  function renderExpenseForm(root) {
    root.innerHTML = `
      <form id="pr-form" class="card panel" style="max-width:820px">
        <h3>New Expenses Payment</h3>
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
            <button type="button" class="btn btn-ghost btn-sm hidden" id="pr-parse" style="margin-top:8px">✨ Read details from invoice</button>
          </div>
        </div>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Submit request</button>
          <button type="button" class="btn btn-ghost" data-nav="#dashboard">Cancel</button>
        </div>
        <p id="pr-msg" class="msg"></p>
      </form>`;

    const fileInput = $('#pr-form input[name=invoice]');
    fileInput.addEventListener("change", () => {
      const f = fileInput.files[0];
      $("#file-label").innerHTML = f
        ? '<span class="file-name">📎 ' + esc(f.name) + "</span> — click to change"
        : "📎 Click to attach a PDF or image (max 10&nbsp;MB)";
      $("#pr-parse").classList.toggle("hidden", !f);
    });

    $("#pr-parse").addEventListener("click", () => parseExpenseInvoice(fileInput.files[0]));
    $("#pr-form").addEventListener("submit", submitRequest);
  }

  // Fill the expense form from an attached invoice / bill.
  async function parseExpenseInvoice(file) {
    if (!file) return;
    const form = $("#pr-form");
    const msg = $("#pr-msg");
    const btn = $("#pr-parse");
    const old = btn.textContent;
    btn.disabled = true;
    btn.textContent = "✨ Reading invoice…";
    msg.className = "msg";
    msg.textContent = "";

    try {
      const p = await readDocument(file, "invoice");
      const setIfEmpty = (field, value) => {
        if (value == null || value === "") return false;
        const input = form[field];
        if (!input || input.value.trim()) return false;
        input.value = value;
        return true;
      };

      const filled = [];
      if (setIfEmpty("payee_name", p.supplier)) filled.push("payee");

      const cur = String(p.currency || "IDR").toUpperCase();
      if (![...form.currency.options].some((o) => o.value === cur)) form.currency.append(el(`<option>${esc(cur)}</option>`));
      form.currency.value = cur;

      const total = Number(p.total) || 0;
      if (total > 0 && !form.amount.value) { form.amount.value = total; filled.push("amount"); }
      if (setIfEmpty("transaction_date", p.due_date || p.invoice_date)) filled.push("date");
      if (setIfEmpty("bank_name", p.bank_name)) filled.push("bank");
      if (setIfEmpty("bank_account_number", p.bank_account_number)) filled.push("account no.");
      if (setIfEmpty("bank_account_name", p.bank_account_name)) filled.push("account name");
      if (!form.title.value.trim() && p.supplier) {
        form.title.value = p.ref_number ? `${p.supplier} — ${p.ref_number}` : String(p.supplier);
        filled.push("title");
      }
      // summarise what the invoice is for, since expenses have no item lines
      if (!form.description.value.trim()) {
        const bits = [];
        if (p.ref_number) bits.push("Invoice " + p.ref_number);
        (p.items || []).forEach((it) => bits.push(`${it.item_name}${it.qty > 1 ? " ×" + it.qty : ""}`));
        (p.charges || []).forEach((c) => bits.push(`${c.name}: ${money(c.amount, cur)}`));
        if (bits.length) form.description.value = bits.join("\n");
      }

      msg.textContent = filled.length
        ? `Read from the invoice (${filled.join(", ")}) — please verify before submitting.`
        : "Nothing new to fill — the fields already have values.";
      msg.className = "msg ok";
      toast("✨ Invoice read");
    } catch (err) {
      msg.textContent = err.message || "Could not read the invoice.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
      btn.textContent = old;
    }
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
  //  SUPPLIER PAYMENT — invoice/PO drop, priced item lines, FX -> IDR estimate
  // ==========================================================================
  const SP_CURRENCIES = ["IDR", "USD", "SGD", "EUR", "JPY", "CNY", "MYR"];
  const fxCache = {};
  async function fetchIdrRate(cur) {
    if (cur === "IDR") return 1;
    if (fxCache[cur]) return fxCache[cur];
    try {
      const r = await fetch("https://open.er-api.com/v6/latest/" + cur);
      const d = await r.json();
      const rate = d?.rates?.IDR;
      if (rate > 0) { fxCache[cur] = rate; return rate; }
    } catch { /* offline or blocked */ }
    return null;
  }

  function renderSupplierForm(root) {
    root.innerHTML = `
      <form id="sp-form" class="card panel" style="max-width:900px">
        <h3>New Supplier Payment</h3>
        <p class="sub">Drop the supplier invoice or PO — items and prices can be read automatically.</p>
        <div class="form-grid">
          <label class="full">Purpose / Title
            <input name="title" required placeholder="e.g. Golf balls restock — PO 0712" />
          </label>
          <label>Supplier name
            <input name="payee_name" required placeholder="Supplier / vendor" />
          </label>
          <label>PO / Invoice number
            <input name="ref_number" placeholder="e.g. INV-2026-0815" />
          </label>
          <label>Currency
            <select name="currency">${SP_CURRENCIES.map((c) => `<option ${c === "IDR" ? "selected" : ""}>${c}</option>`).join("")}</select>
          </label>
          <label>Transaction / transfer date
            <input name="transaction_date" type="date" />
          </label>
          <label>Invoice date <span class="hint">(optional)</span>
            <input name="invoice_date" type="date" />
          </label>
          <label>Buyer entity <span class="hint">(optional)</span>
            <input name="buyer" placeholder="e.g. PT Solusi Golf Indonesia" />
          </label>
          <label>Payment terms <span class="hint">(optional)</span>
            <input name="payment_terms" placeholder="e.g. C.O.D, Bank Transfer" />
          </label>
          <label>Bank name
            <input name="bank_name" placeholder="Supplier's bank" />
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
            <label>Invoice / PO attachment</label>
            <label class="file-drop">
              <input type="file" name="invoice" accept=".pdf,.png,.jpg,.jpeg,.webp,.gif" />
              <span id="sp-file-label">📎 Click to attach the supplier invoice or PO</span>
            </label>
            <button type="button" class="btn btn-ghost btn-sm hidden" id="sp-parse" style="margin-top:8px">✨ Read items &amp; prices from invoice</button>
          </div>
        </div>
        <div class="ln4-head"><span>Item</span><span>Qty</span><span>Unit price</span><span>Line total</span><span></span></div>
        <div id="sp-lines"></div>
        <button type="button" class="btn btn-ghost btn-sm" id="sp-add-line">➕ Add item</button>
        <div class="ch-head"><span>Biaya (PPN, biaya kirim, dll.)</span><span>Amount</span><span></span></div>
        <div id="sp-charges"></div>
        <button type="button" class="btn btn-ghost btn-sm" id="sp-add-charge">➕ Add biaya</button>
        <div class="grand">
          <span>Total <span class="fx-hint" id="sp-fx-hint"></span></span>
          <span style="text-align:right">
            <span class="amount" id="sp-total">IDR 0</span>
            <div class="fx-hint" id="sp-idr-est"></div>
          </span>
        </div>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Submit request</button>
          <button type="button" class="btn btn-ghost" data-nav="#dashboard">Cancel</button>
        </div>
        <p id="sp-msg" class="msg"></p>
      </form>`;

    const linesBox = $("#sp-lines");
    const addSpLine = () => {
      const row = el(`
        <div class="ln4-row">
          <input type="text" class="ln-item" placeholder="Item name" />
          <input type="number" class="ln-qty" step="0.01" min="0" placeholder="1" />
          <input type="number" class="ln-price" step="0.01" placeholder="0 (negative = discount)" />
          <span class="ln-line-total">—</span>
          <button type="button" class="ln-del" title="Remove line">✕</button>
        </div>`);
      row.querySelector(".ln-qty").addEventListener("input", recomputeSp);
      row.querySelector(".ln-price").addEventListener("input", recomputeSp);
      row.querySelector(".ln-del").addEventListener("click", () => { row.remove(); recomputeSp(); });
      linesBox.append(row);
      return row;
    };
    addSpLine(); addSpLine(); addSpLine();
    $("#sp-add-line").addEventListener("click", () => addSpLine());
    $("#sp-form")._addSpLine = addSpLine;

    const chargesBox = $("#sp-charges");
    const addSpCharge = (name = "", amount = "") => {
      const row = el(`
        <div class="ch-row">
          <input type="text" class="ch-name" placeholder="e.g. PPN 11% / Biaya kirim" />
          <input type="number" class="ch-amt" step="0.01" placeholder="0" />
          <button type="button" class="ln-del" title="Remove">✕</button>
        </div>`);
      row.querySelector(".ch-name").value = name;
      if (amount !== "") row.querySelector(".ch-amt").value = amount;
      row.querySelector(".ch-amt").addEventListener("input", recomputeSp);
      row.querySelector(".ln-del").addEventListener("click", () => { row.remove(); recomputeSp(); });
      chargesBox.append(row);
      return row;
    };
    addSpCharge();
    $("#sp-add-charge").addEventListener("click", () => addSpCharge());
    $("#sp-form")._addSpCharge = addSpCharge;

    $('#sp-form select[name=currency]').addEventListener("change", recomputeSp);

    const fi = $('#sp-form input[name=invoice]');
    fi.addEventListener("change", () => {
      const f = fi.files[0];
      $("#sp-file-label").innerHTML = f ? '<span class="file-name">📎 ' + esc(f.name) + "</span> — click to change" : "📎 Click to attach the supplier invoice or PO";
      $("#sp-parse").classList.toggle("hidden", !f);
    });
    $("#sp-parse").addEventListener("click", () => parseInvoice(fi.files[0]));

    $("#sp-form").addEventListener("submit", submitSupplier);
  }

  function spLineTotals() {
    let total = 0;
    $$("#sp-lines .ln4-row").forEach((row) => {
      const qty = Number(row.querySelector(".ln-qty").value) || 0;
      const price = Number(row.querySelector(".ln-price").value) || 0;
      const line = qty * price;
      total += line;
      row.querySelector(".ln-line-total").textContent = line ? line.toLocaleString() : "—";
    });
    $$("#sp-charges .ch-amt").forEach((i) => (total += Number(i.value) || 0));
    return total;
  }

  async function recomputeSp() {
    const form = $("#sp-form");
    if (!form) return;
    const cur = form.currency.value;
    const total = spLineTotals();
    $("#sp-total").textContent = money(total, cur);
    const est = $("#sp-idr-est");
    const hint = $("#sp-fx-hint");
    if (cur === "IDR" || !total) { est.textContent = ""; hint.textContent = ""; form._idrEstimate = null; form._fxRate = null; return; }
    est.textContent = "fetching IDR estimate…";
    const rate = await fetchIdrRate(cur);
    if (form.currency.value !== cur) return; // currency changed meanwhile
    if (rate) {
      form._fxRate = rate;
      form._idrEstimate = Math.round(total * rate);
      est.textContent = "≈ " + money(form._idrEstimate, "IDR");
      hint.textContent = `(1 ${cur} ≈ ${Math.round(rate).toLocaleString()} IDR)`;
    } else {
      form._fxRate = null; form._idrEstimate = null;
      est.textContent = "(IDR estimate unavailable)";
      hint.textContent = "";
    }
  }

  async function parseInvoice(file) {
    const msg = $("#sp-msg");
    const btn = $("#sp-parse");
    if (!file) return;
    if (file.size > 8 * 1024 * 1024) { msg.textContent = "File too large to read automatically (max 8 MB)."; msg.className = "msg error"; return; }

    btn.disabled = true;
    const old = btn.textContent;
    btn.textContent = "✨ Reading invoice…";
    msg.className = "msg"; msg.textContent = "";

    try {
      const parsed = await readDocument(file, "invoice");

      const form = $("#sp-form");
      if (parsed.supplier && !form.payee_name.value.trim()) form.payee_name.value = parsed.supplier;
      if (parsed.ref_number && !form.ref_number.value.trim()) form.ref_number.value = parsed.ref_number;
      if (parsed.supplier && !form.title.value.trim()) form.title.value = `Supplier payment — ${parsed.supplier}`;
      // payment instructions printed on the invoice
      if (parsed.bank_name && !form.bank_name.value.trim()) form.bank_name.value = parsed.bank_name;
      if (parsed.bank_account_number && !form.bank_account_number.value.trim()) form.bank_account_number.value = parsed.bank_account_number;
      if (parsed.bank_account_name && !form.bank_account_name.value.trim()) form.bank_account_name.value = parsed.bank_account_name;
      if (!form.transaction_date.value && (parsed.due_date || parsed.invoice_date)) form.transaction_date.value = parsed.due_date || parsed.invoice_date;
      if (parsed.invoice_date && !form.invoice_date.value) form.invoice_date.value = parsed.invoice_date;
      if (parsed.buyer && !form.buyer.value.trim()) form.buyer.value = parsed.buyer;
      if (parsed.payment_terms && !form.payment_terms.value.trim()) form.payment_terms.value = parsed.payment_terms;
      // keep the printed gross/discount for the purchasing compilation
      form._gross = Number(parsed.gross_subtotal) || null;
      form._discount = Number(parsed.discount_total) || null;

      const cur = String(parsed.currency || "IDR").toUpperCase();
      if (![...form.currency.options].some((o) => o.value === cur)) {
        form.currency.append(el(`<option>${esc(cur)}</option>`));
      }
      form.currency.value = cur;

      const items = Array.isArray(parsed.items) ? parsed.items : [];
      if (!items.length) { msg.textContent = "No priced items found — enter them manually."; msg.className = "msg error"; return; }

      const linesBox = $("#sp-lines");
      $$(".ln4-row", linesBox).forEach((row) => {
        const filled = row.querySelector(".ln-item").value.trim() || row.querySelector(".ln-price").value;
        if (!filled) row.remove();
      });
      items.forEach((it) => {
        const row = form._addSpLine();
        row.querySelector(".ln-item").value = it.item_name || "";
        row.querySelector(".ln-qty").value = it.qty != null && it.qty > 0 ? it.qty : 1;
        row.querySelector(".ln-price").value = it.unit_price != null ? it.unit_price : "";
      });

      // fill the biaya/charges section from the document
      const charges = Array.isArray(parsed.charges) ? parsed.charges.filter((c) => c && c.name) : [];
      $$("#sp-charges .ch-row").forEach((row) => {
        const filled = row.querySelector(".ch-name").value.trim() || row.querySelector(".ch-amt").value;
        if (!filled) row.remove();
      });
      charges.forEach((c) => form._addSpCharge(c.name, Number(c.amount) || 0));

      if (parsed.fx_rate) fxCache[cur] = parsed.fx_rate;
      await recomputeSp();

      // safety check: the document's own grand total vs the sum of the lines
      const lineTotal =
        items.reduce((s, it) => s + (Number(it.qty) || 1) * (Number(it.unit_price) || 0), 0) +
        charges.reduce((s, c) => s + (Number(c.amount) || 0), 0);
      const docTotal = Number(parsed.total);
      if (docTotal && Math.abs(docTotal - lineTotal) > Math.max(1, docTotal * 0.005)) {
        msg.textContent = `⚠ The invoice's grand total is ${money(docTotal, cur)}, but the lines add up to ${money(lineTotal, cur)} — check for missed discounts or charges before submitting.`;
        msg.className = "msg error";
      } else {
        msg.textContent = `Read ${items.length} item${items.length === 1 ? "" : "s"} from the invoice — verify prices before submitting.` + (parsed.fx_error ? " (" + parsed.fx_error + ")" : "");
        msg.className = "msg ok";
      }
      toast(`✨ ${items.length} items read`);
    } catch (err) {
      msg.textContent = err.message || "Could not read the invoice.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
      btn.textContent = old;
    }
  }

  async function submitSupplier(e) {
    e.preventDefault();
    const form = e.target;
    const btn = form.querySelector("button[type=submit]");
    const msg = $("#sp-msg");
    const file = form.invoice.files[0];
    if (file && file.size > 10 * 1024 * 1024) { msg.textContent = "File is larger than 10 MB."; msg.className = "msg error"; return; }

    // collect priced lines
    const items = [];
    for (const row of $$("#sp-lines .ln4-row")) {
      const name = row.querySelector(".ln-item").value.trim();
      const qty = Number(row.querySelector(".ln-qty").value) || 0;
      const price = Number(row.querySelector(".ln-price").value) || 0;
      if (!name && !price) continue;
      if (!name) { msg.textContent = "Every line needs an item name."; msg.className = "msg error"; return; }
      items.push({ item_name: name, qty: qty || 1, unit_price: price });
    }
    if (!items.length) { msg.textContent = "Add at least one item line."; msg.className = "msg error"; return; }

    // collect biaya / charges
    const chargesList = [];
    for (const row of $$("#sp-charges .ch-row")) {
      const name = row.querySelector(".ch-name").value.trim();
      const amt = Number(row.querySelector(".ch-amt").value) || 0;
      if (!name && !amt) continue;
      if (!name) { msg.textContent = "Every biaya line needs a name (e.g. PPN, Biaya kirim)."; msg.className = "msg error"; return; }
      chargesList.push({ name, amount: amt });
    }

    const total =
      items.reduce((s, it) => s + it.qty * it.unit_price, 0) +
      chargesList.reduce((s, c) => s + c.amount, 0);
    if (total <= 0) { msg.textContent = "The total must be positive — check the discount lines."; msg.className = "msg error"; return; }
    const cur = form.currency.value;

    btn.disabled = true; msg.className = "msg"; msg.textContent = "Submitting…";
    try {
      let invoicePath = null;
      if (file) {
        const safe = file.name.replace(/[^\w.\-]+/g, "_").slice(-60);
        invoicePath = `${state.user.id}/${Date.now()}-${safe}`;
        const up = await sb.storage.from("invoices").upload(invoicePath, file, { cacheControl: "3600", upsert: false });
        if (up.error) throw up.error;
      }

      const payload = {
        requester_id: state.user.id,
        request_type: "supplier",
        title: form.title.value.trim(),
        payee_name: form.payee_name.value.trim(),
        ref_number: form.ref_number.value.trim() || null,
        amount: total,
        currency: cur,
        fx_rate: cur === "IDR" ? null : form._fxRate || null,
        idr_estimate: cur === "IDR" ? null : form._idrEstimate || null,
        items,
        charges: chargesList.length ? chargesList : null,
        invoice_date: form.invoice_date.value || null,
        buyer: form.buyer.value.trim() || null,
        payment_terms: form.payment_terms.value.trim() || null,
        gross_subtotal: form._gross || null,
        discount_total: form._discount || null,
        transaction_date: form.transaction_date.value || null,
        bank_name: form.bank_name.value.trim() || null,
        bank_account_name: form.bank_account_name.value.trim() || null,
        bank_account_number: form.bank_account_number.value.trim() || null,
        description: form.description.value.trim() || null,
        invoice_path: invoicePath,
      };

      const { error } = await sb.from("payment_requests").insert(payload);
      if (error) throw error;

      // file the invoice in Drive and refresh the sheet (best effort)
      if (file) {
        const ext = file.name.includes(".") ? file.name.slice(file.name.lastIndexOf(".")) : "";
        syncFileToDrive(file, `${safeName(payload.ref_number || payload.title)} - invoice - ${safeName(payload.payee_name)}${ext}`);
      }
      state.purchAll = null; // purchasing book must reload
      syncToGoogleSheet({ silent: true });

      toast("Supplier payment request submitted ✔");
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
        '<button class="btn btn-primary" data-nav="#newtrip">➕ New Trip Claim</button></div>';
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
          <button type="button" class="btn btn-ghost" data-nav="#trips">Cancel</button>
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
        '<button class="btn btn-primary" data-nav="#newpetty">➕ New Petty Cash</button></div>';
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
          <button type="button" class="btn btn-ghost" data-nav="#petty">Cancel</button>
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
  //  Shared: user directory (for assignment dropdowns + names)
  // ==========================================================================
  async function loadUsers() {
    if (state.users) return state.users;
    const { data, error } = await sb.from("user_directory").select("*").order("full_name");
    if (error) { toast(error.message, "error"); return []; }
    state.users = data || [];
    return state.users;
  }
  const userName = (id) => {
    const u = (state.users || []).find((x) => x.id === id);
    return u ? u.full_name || u.email : "—";
  };
  const assigneeSelect = (nameAttr, required = true) =>
    `<select name="${nameAttr}" ${required ? "required" : ""}>
       <option value="" disabled selected>Assign to…</option>
       ${(state.users || [])
         .map((u) => `<option value="${u.id}">${esc(u.full_name || u.email)}</option>`)
         .join("")}
     </select>`;

  // generic item/qty/unit line editor
  function addItemLine(container) {
    const row = el(`
      <div class="ln3-row">
        <input type="text" class="ln-item" placeholder="Item name" />
        <input type="number" class="ln-qty" step="0.01" min="0" placeholder="Qty" />
        <input type="text" class="ln-unit" placeholder="Unit" />
        <button type="button" class="ln-del" title="Remove line">✕</button>
      </div>`);
    row.querySelector(".ln-del").addEventListener("click", () => row.remove());
    container.append(row);
  }
  function collectItemLines(container, msgEl) {
    const lines = [];
    for (const row of $$(".ln3-row", container)) {
      const item = row.querySelector(".ln-item").value.trim();
      const qtyRaw = row.querySelector(".ln-qty").value;
      const unit = row.querySelector(".ln-unit").value.trim();
      if (!item && !qtyRaw) continue;
      if (!item) { msgEl.textContent = "Every line needs an item name."; msgEl.className = "msg error"; return null; }
      const qty = Number(qtyRaw);
      if (!qty || qty <= 0) { msgEl.textContent = `"${item}" needs a quantity.`; msgEl.className = "msg error"; return null; }
      lines.push({ item_name: item, qty, unit: unit || null });
    }
    if (!lines.length) { msgEl.textContent = "Add at least one item."; msgEl.className = "msg error"; return null; }
    return lines;
  }

  const filterPills = (current, options) =>
    `<div class="toolbar">` +
    options
      .map(
        ([key, label]) =>
          `<button class="filter-pill ${key === current ? "active" : ""}" data-filter="${key}">${label}</button>`
      )
      .join("") +
    `</div>`;

  // ==========================================================================
  //  VIEW: RECEIVING (list)
  // ==========================================================================
  async function renderReceiving() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading receiving orders…</div>';
    await loadUsers();

    const { data, error } = await sb
      .from("receiving_orders")
      .select("*")
      .order("created_at", { ascending: false });
    if (error) { root.innerHTML = errorBox(error.message); return; }

    // approved supplier purchases that have no receiving started yet
    const { data: purchases } = await sb
      .from("payment_requests")
      .select("*")
      .eq("request_type", "supplier")
      .eq("status", "approved")
      .order("reviewed_at", { ascending: false });
    const linked = new Set((data || []).map((o) => o.payment_request_id).filter(Boolean));
    const toReceive = (purchases || []).filter((p) => !linked.has(p.id));

    const f = state.recvFilter;
    const rows = (data || []).filter((r) =>
      f === "assigned" ? r.assigned_to === state.user.id :
      f === "mine" ? r.created_by === state.user.id : true
    );

    const pillOpts = [["assigned", "Assigned to me"], ["mine", "Created by me"], ["all", "All"]];
    let html = "";

    if (toReceive.length) {
      html += `<div class="card panel" style="margin-bottom:16px">
        <h3 style="margin:0 0 4px">📦 Approved purchases ready to receive</h3>
        <p class="sub">These supplier payments were approved — start the receiving process when the goods arrive.</p>
        <div class="table-wrap"><table>
          <thead><tr><th>Ref / PO</th><th>Supplier</th><th>Purchase</th><th>Approved</th><th></th></tr></thead>
          <tbody>${toReceive
            .map(
              (p) => `<tr data-pid="${p.id}">
                <td>${esc(p.ref_number || "—")}</td>
                <td>${esc(p.payee_name)}</td>
                <td>${esc(p.title)}</td>
                <td>${fmtDate(p.reviewed_at)}</td>
                <td><button class="btn btn-primary btn-sm start-recv" data-id="${p.id}">📥 Start receiving</button></td>
              </tr>`
            )
            .join("")}</tbody></table></div>
      </div>`;
    }

    html += filterPills(f, pillOpts);

    if (!rows.length) {
      html +=
        '<div class="card panel empty"><div class="big">📥</div><h3>Nothing here</h3>' +
        '<p class="sub">No receiving orders in this filter.</p>' +
        '<button class="btn btn-primary" data-nav="#newreceiving">➕ New Receiving</button></div>';
    } else {
      html += `<div class="card table-wrap"><table>
        <thead><tr><th>Ref / PO</th><th>Supplier</th><th>Site</th><th>Created by</th><th>Assigned to</th><th>Status</th></tr></thead>
        <tbody>${rows
          .map(
            (r) => `<tr data-id="${r.id}">
              <td>${esc(r.ref_number || "—")}</td>
              <td>${esc(r.supplier || "—")}</td>
              <td>${esc(r.location)}</td>
              <td>${esc(userName(r.created_by))}</td>
              <td>${esc(userName(r.assigned_to))}</td>
              <td><span class="badge ${r.status}">${r.status === "pending" ? "to check" : r.status}</span></td>
            </tr>`
          )
          .join("")}</tbody></table></div>`;
    }
    root.innerHTML = html;

    $$(".filter-pill", root).forEach((p) =>
      p.addEventListener("click", () => { state.recvFilter = p.dataset.filter; renderReceiving(); })
    );
    $$("tbody tr", root).forEach((tr) =>
      tr.addEventListener("click", () => {
        const r = rows.find((x) => x.id === tr.dataset.id);
        if (r) openReceivingDetail(r);
      })
    );
    $$(".start-recv", root).forEach((b) =>
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        const p = toReceive.find((x) => x.id === b.dataset.id);
        if (!p) return;
        state.prefillReceiving = p;
        location.hash = "#newreceiving";
      })
    );
    // purchase rows open the payment request's detail popup
    const dirNameMap = {};
    (state.users || []).forEach((u) => (dirNameMap[u.id] = u.full_name || u.email));
    $$("tr[data-pid]", root).forEach((tr) =>
      tr.addEventListener("click", (e) => {
        if (e.target.closest(".start-recv")) return;
        const p = toReceive.find((x) => x.id === tr.dataset.pid);
        if (p) openDetail(p, state.profile.role === "admin", dirNameMap, "payment", { hidePrices: true });
      })
    );
  }

  // ==========================================================================
  //  VIEW: NEW RECEIVING
  // ==========================================================================
  async function renderNewReceiving() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading…</div>';
    await loadUsers();

    root.innerHTML = `
      <form id="recv-form" class="card panel" style="max-width:860px">
        <h3>New Receiving</h3>
        <p class="sub">Register incoming goods, attach the PO / supplier invoice, and assign someone to check them on site.</p>
        <div class="form-grid">
          <label>PO / Invoice number
            <input name="ref_number" placeholder="e.g. PO-2026-0712" />
          </label>
          <label>Supplier
            <input name="supplier" placeholder="Supplier name" />
          </label>
          <label>Receiving site
            <select name="location">${LOCATIONS.map((l) => `<option ${l === "Manhattan" ? "selected" : ""}>${l}</option>`).join("")}</select>
          </label>
          <label>Assign checker
            ${assigneeSelect("assigned_to")}
          </label>
          <label class="full">Notes
            <textarea name="notes" placeholder="Anything the checker should know"></textarea>
          </label>
          <div class="full">
            <label>PO / Invoice attachment</label>
            <label class="file-drop">
              <input type="file" name="attachment" accept="image/*,.pdf" />
              <span id="recv-file-label">📎 Click to attach the PO or supplier invoice</span>
            </label>
            <button type="button" class="btn btn-ghost btn-sm hidden" id="recv-parse" style="margin-top:8px">✨ Read items from PO</button>
          </div>
        </div>
        <div class="ln3-head"><span>Item</span><span>Qty</span><span>Unit</span><span></span></div>
        <div id="recv-lines"></div>
        <button type="button" class="btn btn-ghost btn-sm" id="recv-add-line">➕ Add item</button>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Create receiving</button>
          <button type="button" class="btn btn-ghost" data-nav="#receiving">Cancel</button>
        </div>
        <p id="recv-msg" class="msg"></p>
      </form>`;

    const linesBox = $("#recv-lines");
    const pre = state.prefillReceiving;
    state.prefillReceiving = null;
    if (pre) {
      const form = $("#recv-form");
      form._prefill = pre;
      form.ref_number.value = pre.ref_number || "";
      form.supplier.value = pre.payee_name || "";
      form.notes.value = `From approved purchase: ${pre.title || ""}`.trim();
      const preItems = Array.isArray(pre.items) ? pre.items : [];
      preItems.forEach((it) => {
        addItemLine(linesBox);
        const row = linesBox.lastElementChild;
        row.querySelector(".ln-item").value = it.item_name || "";
        row.querySelector(".ln-qty").value = it.qty != null && it.qty > 0 ? it.qty : 1;
        if (it.unit) row.querySelector(".ln-unit").value = it.unit;
      });
      if (!preItems.length) { addItemLine(linesBox); addItemLine(linesBox); addItemLine(linesBox); }
      if (pre.invoice_path) {
        $("#recv-file-label").innerHTML = "📎 The purchase's invoice/PO will be attached automatically — or click to attach a different file";
      }
      $("#recv-form .sub").textContent = "Started from an approved supplier purchase — check the lines, assign a checker, and create.";
    } else {
      addItemLine(linesBox); addItemLine(linesBox); addItemLine(linesBox);
    }
    $("#recv-add-line").addEventListener("click", () => addItemLine(linesBox));

    const fi = $('#recv-form input[name=attachment]');
    fi.addEventListener("change", () => {
      const f = fi.files[0];
      $("#recv-file-label").innerHTML = f ? '<span class="file-name">📎 ' + esc(f.name) + "</span>" : "📎 Click to attach the PO or supplier invoice";
      $("#recv-parse").classList.toggle("hidden", !f);
    });

    $("#recv-parse").addEventListener("click", () => parsePO(fi.files[0], linesBox));

    $("#recv-form").addEventListener("submit", submitReceiving);
  }

  // Read the attached PO/invoice with AI (edge function "parse-po") and
  // pre-fill supplier, ref number and item lines for the user to verify.
  async function parsePO(file, linesBox) {
    const msg = $("#recv-msg");
    const btn = $("#recv-parse");
    if (!file) return;
    if (file.size > 8 * 1024 * 1024) {
      msg.textContent = "File is too large to read automatically (max 8 MB) — type the items manually.";
      msg.className = "msg error";
      return;
    }

    btn.disabled = true;
    const oldLabel = btn.textContent;
    btn.textContent = "✨ Reading PO…";
    msg.className = "msg";
    msg.textContent = "";

    try {
      const parsed = await readDocument(file);

      const form = $("#recv-form");
      if (parsed.supplier && !form.supplier.value.trim()) form.supplier.value = parsed.supplier;
      if (parsed.ref_number && !form.ref_number.value.trim()) form.ref_number.value = parsed.ref_number;

      const items = Array.isArray(parsed.items) ? parsed.items : [];
      if (!items.length) {
        msg.textContent = "No item lines found in this document — type them manually.";
        msg.className = "msg error";
        return;
      }

      // drop empty editor rows, then append the parsed lines
      $$(".ln3-row", linesBox).forEach((row) => {
        const filled = row.querySelector(".ln-item").value.trim() || row.querySelector(".ln-qty").value;
        if (!filled) row.remove();
      });
      items.forEach((it) => {
        addItemLine(linesBox);
        const row = linesBox.lastElementChild;
        row.querySelector(".ln-item").value = it.item_name || "";
        row.querySelector(".ln-qty").value = it.qty != null && it.qty > 0 ? it.qty : 1;
        row.querySelector(".ln-unit").value = it.unit || "";
      });

      msg.textContent = `Read ${items.length} item${items.length === 1 ? "" : "s"} from the PO — please verify before submitting.`;
      msg.className = "msg ok";
      toast(`✨ ${items.length} items read from PO`);
    } catch (err) {
      msg.textContent = err.message || "Could not read the PO.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
      btn.textContent = oldLabel;
    }
  }

  async function submitReceiving(e) {
    e.preventDefault();
    const form = e.target;
    const btn = form.querySelector("button[type=submit]");
    const msg = $("#recv-msg");
    const lines = collectItemLines($("#recv-lines"), msg);
    if (!lines) return;
    const file = form.attachment.files[0];
    if (file && file.size > 10 * 1024 * 1024) { msg.textContent = "Attachment is over 10 MB."; msg.className = "msg error"; return; }

    btn.disabled = true; msg.className = "msg"; msg.textContent = "Creating…";
    let orderId = null;
    try {
      let attachmentPath = null;
      if (file) {
        const safe = file.name.replace(/[^\w.\-]+/g, "_").slice(-50);
        attachmentPath = `${state.user.id}/${Date.now()}-${safe}`;
        const up = await sb.storage.from("receiving-files").upload(attachmentPath, file, { upsert: false });
        if (up.error) throw up.error;
      }
      // started from an approved purchase and no new file chosen:
      // carry the purchase's invoice/PO over so the checker can open it
      if (!attachmentPath && form._prefill?.invoice_path) {
        try {
          const dl = await sb.storage.from("invoices").download(form._prefill.invoice_path);
          if (dl.data) {
            const orig = form._prefill.invoice_path.split("/").pop();
            attachmentPath = `${state.user.id}/${Date.now()}-${orig}`;
            const cp = await sb.storage.from("receiving-files").upload(attachmentPath, dl.data, { upsert: false });
            if (cp.error) attachmentPath = null;
          }
        } catch { /* attachment copy is best-effort */ }
      }
      const { data: order, error: oErr } = await sb
        .from("receiving_orders")
        .insert({
          created_by: state.user.id,
          ref_number: form.ref_number.value.trim() || null,
          supplier: form.supplier.value.trim() || null,
          location: form.location.value,
          assigned_to: form.assigned_to.value,
          notes: form.notes.value.trim() || null,
          attachment_path: attachmentPath,
          payment_request_id: form._prefill?.id || null,
        })
        .select().single();
      if (oErr) throw oErr;
      orderId = order.id;

      const { error: lErr } = await sb.from("receiving_lines").insert(
        lines.map((l, i) => ({ order_id: orderId, ...l, position: i }))
      );
      if (lErr) throw lErr;

      toast("Receiving created ✔ — assigned to " + userName(form.assigned_to.value));
      location.hash = "#receiving";
    } catch (err) {
      if (orderId) await sb.from("receiving_orders").delete().eq("id", orderId);
      msg.textContent = err.message || "Something went wrong.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
    }
  }

  // ==========================================================================
  //  RECEIVING DETAIL — checklist + confirm + report
  // ==========================================================================
  async function openReceivingDetail(r) {
    const isAssignee = r.assigned_to === state.user.id;
    const isAdmin = state.profile.role === "admin";
    const canCheck = (isAssignee || isAdmin) && r.status === "pending";

    const card = el(`
      <div>
        <div style="display:flex;justify-content:space-between;align-items:start;gap:12px">
          <div>
            <h3 style="margin:0 0 4px">📥 ${esc(r.ref_number || "Receiving")}</h3>
            <span class="badge ${r.status}">${r.status === "pending" ? "to check" : r.status}</span>
          </div>
          <button class="btn btn-ghost btn-sm" data-close>✕</button>
        </div>
        <div style="margin-top:14px">
          <div class="detail-row"><span class="k">Supplier</span><span class="v">${esc(r.supplier || "—")}</span></div>
          <div class="detail-row"><span class="k">Site</span><span class="v">${esc(r.location)}</span></div>
          <div class="detail-row"><span class="k">Created by</span><span class="v">${esc(userName(r.created_by))}</span></div>
          <div class="detail-row"><span class="k">Assigned checker</span><span class="v">${esc(userName(r.assigned_to))}</span></div>
          ${r.payment_request_id ? '<div class="detail-row"><span class="k">Source</span><span class="v">📦 From approved supplier purchase</span></div>' : ""}
          ${r.notes ? `<div class="detail-row"><span class="k">Notes</span><span class="v">${esc(r.notes)}</span></div>` : ""}
          ${r.status === "confirmed" ? `<div class="detail-row"><span class="k">Confirmed</span><span class="v">${esc(userName(r.confirmed_by))} · ${fmtDate(r.confirmed_at)}</span></div>` : ""}
        </div>
        <div id="recv-attach" class="chips" style="margin-top:12px"></div>
        <div class="check-progress" id="recv-progress"></div>
        <div id="recv-checklist"></div>
        <div id="detail-actions" class="modal-actions"></div>
        <p id="detail-msg" class="msg"></p>
      </div>`);
    openModal(card);

    // attachment
    if (r.attachment_path) {
      const slot = card.querySelector("#recv-attach");
      const { data } = await sb.storage.from("receiving-files").createSignedUrl(r.attachment_path, 300);
      if (data) slot.innerHTML = `<a class="btn btn-ghost btn-sm" href="${data.signedUrl}" target="_blank" rel="noopener">📎 View PO / invoice</a>`;
    }

    // lines
    const { data: lines, error } = await sb
      .from("receiving_lines").select("*").eq("order_id", r.id).order("position");
    if (error) { card.querySelector("#recv-checklist").innerHTML = errorBox(error.message); return; }

    const listBox = card.querySelector("#recv-checklist");
    const progress = card.querySelector("#recv-progress");
    const actions = card.querySelector("#detail-actions");
    const msg = card.querySelector("#detail-msg");

    let confirmBtn = null;
    const updateProgress = () => {
      const done = lines.filter((l) => l.checked).length;
      progress.textContent = `Checked ${done} of ${lines.length} items`;
      if (confirmBtn) confirmBtn.disabled = done !== lines.length;
    };

    lines.forEach((l) => {
      const row = el(`
        <label class="check-line ${l.checked ? "done" : ""}">
          <input type="checkbox" ${l.checked ? "checked" : ""} ${canCheck ? "" : "disabled"} />
          <span class="cl-name">${esc(l.item_name)}</span>
          <span class="cl-qty">${esc(l.qty)} ${esc(l.unit || "")}</span>
        </label>`);
      if (canCheck) {
        row.querySelector("input").addEventListener("change", async (ev) => {
          const val = ev.target.checked;
          const { error: uErr } = await sb.from("receiving_lines").update({ checked: val }).eq("id", l.id);
          if (uErr) { ev.target.checked = !val; toast(uErr.message, "error"); return; }
          l.checked = val;
          row.classList.toggle("done", val);
          updateProgress();
        });
      }
      listBox.append(row);
    });

    if (canCheck) {
      confirmBtn = el('<button class="btn btn-success">✔ Confirm receiving</button>');
      confirmBtn.addEventListener("click", async () => {
        confirmBtn.disabled = true;
        msg.className = "msg"; msg.textContent = "Confirming…";
        const { error: cErr } = await sb.from("receiving_orders").update({
          status: "confirmed",
          confirmed_by: state.user.id,
          confirmed_at: new Date().toISOString(),
        }).eq("id", r.id);
        if (cErr) { msg.textContent = cErr.message; msg.className = "msg error"; confirmBtn.disabled = false; return; }
        closeModal();
        toast("Receiving confirmed ✔");
        renderReceiving();
      });
      actions.append(confirmBtn);
    }

    if (r.status === "confirmed") {
      const printBtn = el('<button class="btn btn-primary">🖨️ Print report</button>');
      printBtn.addEventListener("click", () => printReceivingReport(r, lines));
      actions.append(printBtn);
    }

    if (r.created_by === state.user.id && r.status === "pending") {
      const del = el('<button class="btn btn-danger">Delete</button>');
      del.addEventListener("click", async () => {
        if (!confirm("Delete this receiving order?")) return;
        const { error: dErr } = await sb.from("receiving_orders").delete().eq("id", r.id);
        if (dErr) { toast(dErr.message, "error"); return; }
        closeModal(); toast("Deleted"); renderReceiving();
      });
      actions.append(del);
    }

    updateProgress();
  }

  // Printable Goods Received Report (for Odoo entry)
  function printReceivingReport(r, lines) {
    const company = cfg.COMPANY_NAME || "Company";
    const today = new Date().toLocaleDateString("en-GB", { day: "2-digit", month: "long", year: "numeric" });
    const rowsHtml = lines
      .map(
        (l, i) => `<tr><td>${i + 1}</td><td>${esc(l.item_name)}</td>
          <td class="r">${esc(l.qty)}</td><td>${esc(l.unit || "—")}</td>
          <td>${l.checked ? "✔ received" : "✕ missing"}</td></tr>`
      )
      .join("");

    const doc = `<!doctype html><html><head><meta charset="utf-8"><title>Goods Received — ${esc(r.ref_number || "")}</title>
      <style>
        :root { color-scheme: light; }
        * { box-sizing: border-box; }
        html, body { background: #fff; }
        body { font-family: -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; color: #14211b; margin: 32px; }
        .head { display:flex; justify-content:space-between; border-bottom:3px solid #157347; padding-bottom:14px; margin-bottom:20px; }
        .company { font-size:22px; font-weight:800; color:#0f5132; }
        .doc-title { font-size:13px; letter-spacing:.08em; text-transform:uppercase; color:#5f6f68; margin-top:2px; }
        .meta { text-align:right; font-size:12px; color:#5f6f68; }
        .info { display:grid; grid-template-columns:1fr 1fr; gap:6px 24px; font-size:13.5px; background:#e8f5ee; border-radius:10px; padding:14px 16px; margin-bottom:18px; }
        .info b { font-weight:700; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        th, td { text-align:left; padding:9px 10px; border-bottom:1px solid #e2e8e4; }
        th { background:#f4f7f5; font-size:11px; text-transform:uppercase; letter-spacing:.04em; color:#5f6f68; }
        td.r, th.r { text-align:right; }
        .note { margin-top:20px; font-size:12.5px; color:#35443c; }
        .sign { display:flex; gap:60px; margin-top:48px; font-size:12px; color:#5f6f68; }
        .sign .box { flex:1; }
        .sign .line { border-top:1px solid #9aa8a1; margin-top:44px; padding-top:6px; }
        .toolbar { margin-bottom:18px; }
        .btn { font:inherit; font-weight:600; background:#157347; color:#fff; border:0; border-radius:8px; padding:9px 16px; cursor:pointer; }
        @media print { .toolbar { display:none; } body { margin:0; } }
      </style></head><body>
      <div class="toolbar"><button class="btn" onclick="window.print()">🖨️ Print / Save as PDF</button></div>
      <div class="head">
        <div><div class="company">${esc(company)}</div><div class="doc-title">Goods Received Report</div></div>
        <div class="meta">Printed: ${esc(today)}<br>Ref: ${esc(r.ref_number || "—")}</div>
      </div>
      <div class="info">
        <div>Supplier: <b>${esc(r.supplier || "—")}</b></div>
        <div>Receiving site: <b>${esc(r.location)}</b></div>
        <div>Created by: <b>${esc(userName(r.created_by))}</b></div>
        <div>Checked by: <b>${esc(userName(r.confirmed_by || r.assigned_to))}</b></div>
        <div>Confirmed: <b>${esc(fmtDate(r.confirmed_at))}</b></div>
        ${r.notes ? `<div>Notes: <b>${esc(r.notes)}</b></div>` : ""}
      </div>
      <table>
        <thead><tr><th>#</th><th>Item</th><th class="r">Qty</th><th>Unit</th><th>Check result</th></tr></thead>
        <tbody>${rowsHtml}</tbody>
      </table>
      <div class="note">All listed items were physically checked at the receiving site. Use this report for Odoo entry.</div>
      <div class="sign">
        <div class="box"><div class="line">Checked by — ${esc(userName(r.confirmed_by || r.assigned_to))}</div></div>
        <div class="box"><div class="line">Approved by</div></div>
      </div>
      <script>window.addEventListener('load',function(){setTimeout(function(){window.print();},250);});<\/script>
      </body></html>`;

    const w = window.open("", "_blank");
    if (!w) { toast("Allow pop-ups for this site to print", "error"); return; }
    w.document.open(); w.document.write(doc); w.document.close();
  }

  // ==========================================================================
  //  VIEW: STORE MOVEMENTS (list)
  // ==========================================================================
  async function renderMovements() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading movements…</div>';
    await loadUsers();

    const { data, error } = await sb
      .from("store_movements")
      .select("*")
      .order("created_at", { ascending: false });
    if (error) { root.innerHTML = errorBox(error.message); return; }

    const f = state.movFilter;
    const rows = (data || []).filter((m) =>
      f === "assigned" ? m.assigned_to === state.user.id :
      f === "mine" ? m.created_by === state.user.id : true
    );

    let html = filterPills(f, [["assigned", "Assigned to me"], ["mine", "Created by me"], ["all", "All"]]);

    if (!rows.length) {
      html +=
        '<div class="card panel empty"><div class="big">🔄</div><h3>Nothing here</h3>' +
        '<p class="sub">No store movements in this filter.</p>' +
        '<button class="btn btn-primary" data-nav="#newmovement">➕ New Movement</button></div>';
    } else {
      html += `<div class="card table-wrap"><table>
        <thead><tr><th>Route</th><th>Created by</th><th>Assigned to</th><th>Date</th><th>Status</th></tr></thead>
        <tbody>${rows
          .map(
            (m) => `<tr data-id="${m.id}">
              <td><b>${esc(m.from_location)}</b> → <b>${esc(m.to_location)}</b></td>
              <td>${esc(userName(m.created_by))}</td>
              <td>${esc(userName(m.assigned_to))}</td>
              <td>${fmtDate(m.created_at)}</td>
              <td><span class="badge ${m.status}">${m.status}</span></td>
            </tr>`
          )
          .join("")}</tbody></table></div>`;
    }
    root.innerHTML = html;

    $$(".filter-pill", root).forEach((p) =>
      p.addEventListener("click", () => { state.movFilter = p.dataset.filter; renderMovements(); })
    );
    $$("tbody tr", root).forEach((tr) =>
      tr.addEventListener("click", () => {
        const m = rows.find((x) => x.id === tr.dataset.id);
        if (m) openMovementDetail(m);
      })
    );
  }

  // ==========================================================================
  //  VIEW: NEW MOVEMENT
  // ==========================================================================
  async function renderNewMovement() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading…</div>';
    await loadUsers();

    root.innerHTML = `
      <form id="mov-form" class="card panel" style="max-width:860px">
        <h3>New Store Movement</h3>
        <p class="sub">List the items to move, choose the route, and assign who moves them.</p>
        <div class="form-grid">
          <label>From
            <select name="from_location">${LOCATIONS.map((l) => `<option>${l}</option>`).join("")}</select>
          </label>
          <label>To
            <select name="to_location">${LOCATIONS.map((l, i) => `<option ${i === 1 ? "selected" : ""}>${l}</option>`).join("")}</select>
          </label>
          <label>Assign to
            ${assigneeSelect("assigned_to")}
          </label>
          <label>Notes
            <input name="notes" placeholder="Optional" />
          </label>
        </div>
        <div class="ln3-head"><span>Item</span><span>Qty</span><span>Unit</span><span></span></div>
        <div id="mov-lines"></div>
        <button type="button" class="btn btn-ghost btn-sm" id="mov-add-line">➕ Add item</button>
        <div class="modal-actions">
          <button type="submit" class="btn btn-primary">Create movement</button>
          <button type="button" class="btn btn-ghost" data-nav="#movements">Cancel</button>
        </div>
        <p id="mov-msg" class="msg"></p>
      </form>`;

    const linesBox = $("#mov-lines");
    addItemLine(linesBox); addItemLine(linesBox); addItemLine(linesBox);
    $("#mov-add-line").addEventListener("click", () => addItemLine(linesBox));
    $("#mov-form").addEventListener("submit", submitMovement);
  }

  async function submitMovement(e) {
    e.preventDefault();
    const form = e.target;
    const btn = form.querySelector("button[type=submit]");
    const msg = $("#mov-msg");
    if (form.from_location.value === form.to_location.value) {
      msg.textContent = "From and To must be different locations.";
      msg.className = "msg error";
      return;
    }
    const lines = collectItemLines($("#mov-lines"), msg);
    if (!lines) return;

    btn.disabled = true; msg.className = "msg"; msg.textContent = "Creating…";
    let movId = null;
    try {
      const { data: mov, error: mErr } = await sb
        .from("store_movements")
        .insert({
          created_by: state.user.id,
          from_location: form.from_location.value,
          to_location: form.to_location.value,
          assigned_to: form.assigned_to.value,
          notes: form.notes.value.trim() || null,
        })
        .select().single();
      if (mErr) throw mErr;
      movId = mov.id;

      const { error: lErr } = await sb.from("movement_lines").insert(
        lines.map((l, i) => ({ movement_id: movId, ...l, position: i }))
      );
      if (lErr) throw lErr;

      toast("Movement created ✔ — assigned to " + userName(form.assigned_to.value));
      location.hash = "#movements";
    } catch (err) {
      if (movId) await sb.from("store_movements").delete().eq("id", movId);
      msg.textContent = err.message || "Something went wrong.";
      msg.className = "msg error";
    } finally {
      btn.disabled = false;
    }
  }

  // ==========================================================================
  //  MOVEMENT DETAIL — prepare / complete
  // ==========================================================================
  async function openMovementDetail(m) {
    const isAssignee = m.assigned_to === state.user.id;
    const isAdmin = state.profile.role === "admin";

    const card = el(`
      <div>
        <div style="display:flex;justify-content:space-between;align-items:start;gap:12px">
          <div>
            <h3 style="margin:0 0 4px">🔄 ${esc(m.from_location)} → ${esc(m.to_location)}</h3>
            <span class="badge ${m.status}">${m.status}</span>
          </div>
          <button class="btn btn-ghost btn-sm" data-close>✕</button>
        </div>
        <div style="margin-top:14px">
          <div class="detail-row"><span class="k">Created by</span><span class="v">${esc(userName(m.created_by))}</span></div>
          <div class="detail-row"><span class="k">Assigned to</span><span class="v">${esc(userName(m.assigned_to))}</span></div>
          <div class="detail-row"><span class="k">Created</span><span class="v">${fmtDate(m.created_at)}</span></div>
          ${m.notes ? `<div class="detail-row"><span class="k">Notes</span><span class="v">${esc(m.notes)}</span></div>` : ""}
          ${m.status === "completed" ? `<div class="detail-row"><span class="k">Completed</span><span class="v">${esc(userName(m.completed_by))} · ${fmtDate(m.completed_at)}</span></div>` : ""}
        </div>
        <div id="mov-items" style="margin-top:12px"></div>
        <div id="detail-actions" class="modal-actions"></div>
        <p id="detail-msg" class="msg"></p>
      </div>`);
    openModal(card);

    const { data: lines, error } = await sb
      .from("movement_lines").select("*").eq("movement_id", m.id).order("position");
    const itemsBox = card.querySelector("#mov-items");
    if (error) { itemsBox.innerHTML = errorBox(error.message); return; }
    itemsBox.innerHTML = `<div class="table-wrap"><table>
      <thead><tr><th>#</th><th>Item</th><th>Qty</th><th>Unit</th></tr></thead>
      <tbody>${(lines || [])
        .map((l, i) => `<tr><td>${i + 1}</td><td>${esc(l.item_name)}</td><td class="amount">${esc(l.qty)}</td><td>${esc(l.unit || "—")}</td></tr>`)
        .join("")}</tbody></table></div>`;

    const actions = card.querySelector("#detail-actions");
    const msg = card.querySelector("#detail-msg");

    const setStatus = async (patch, okMsg) => {
      msg.className = "msg"; msg.textContent = "Saving…";
      const { error: uErr } = await sb.from("store_movements").update(patch).eq("id", m.id);
      if (uErr) { msg.textContent = uErr.message; msg.className = "msg error"; return; }
      closeModal(); toast(okMsg); renderMovements();
    };

    if ((isAssignee || isAdmin) && m.status === "pending") {
      const prep = el('<button class="btn btn-ghost">🚚 Start preparing</button>');
      prep.addEventListener("click", () => setStatus({ status: "preparing" }, "Movement in preparation"));
      actions.append(prep);
    }
    if ((isAssignee || isAdmin) && m.status !== "completed") {
      const done = el('<button class="btn btn-success">✔ Complete movement</button>');
      done.addEventListener("click", () =>
        setStatus(
          { status: "completed", completed_by: state.user.id, completed_at: new Date().toISOString() },
          "Movement completed ✔"
        )
      );
      actions.append(done);
    }
    if (m.status === "completed") {
      const printBtn = el('<button class="btn btn-primary">🖨️ Transfer report</button>');
      printBtn.addEventListener("click", () => printMovementReport(m, lines || []));
      actions.append(printBtn);
    }
    if (m.created_by === state.user.id && m.status === "pending") {
      const del = el('<button class="btn btn-danger">Delete</button>');
      del.addEventListener("click", async () => {
        if (!confirm("Delete this movement?")) return;
        const { error: dErr } = await sb.from("store_movements").delete().eq("id", m.id);
        if (dErr) { toast(dErr.message, "error"); return; }
        closeModal(); toast("Deleted"); renderMovements();
      });
      actions.append(del);
    }
  }

  // Printable Store Transfer Report (for Odoo entry)
  function printMovementReport(m, lines) {
    const company = cfg.COMPANY_NAME || "Company";
    const today = new Date().toLocaleDateString("en-GB", { day: "2-digit", month: "long", year: "numeric" });
    const rowsHtml = lines
      .map((l, i) => `<tr><td>${i + 1}</td><td>${esc(l.item_name)}</td><td class="r">${esc(l.qty)}</td><td>${esc(l.unit || "—")}</td></tr>`)
      .join("");

    const doc = `<!doctype html><html><head><meta charset="utf-8"><title>Transfer — ${esc(m.from_location)} to ${esc(m.to_location)}</title>
      <style>
        :root { color-scheme: light; }
        * { box-sizing: border-box; }
        html, body { background: #fff; }
        body { font-family: -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; color: #14211b; margin: 32px; }
        .head { display:flex; justify-content:space-between; border-bottom:3px solid #157347; padding-bottom:14px; margin-bottom:20px; }
        .company { font-size:22px; font-weight:800; color:#0f5132; }
        .doc-title { font-size:13px; letter-spacing:.08em; text-transform:uppercase; color:#5f6f68; margin-top:2px; }
        .meta { text-align:right; font-size:12px; color:#5f6f68; }
        .route { font-size:20px; font-weight:800; background:#e8f5ee; border-radius:10px; padding:14px 16px; margin-bottom:14px; color:#0f5132; }
        .info { display:grid; grid-template-columns:1fr 1fr; gap:6px 24px; font-size:13.5px; margin-bottom:18px; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        th, td { text-align:left; padding:9px 10px; border-bottom:1px solid #e2e8e4; }
        th { background:#f4f7f5; font-size:11px; text-transform:uppercase; letter-spacing:.04em; color:#5f6f68; }
        td.r, th.r { text-align:right; }
        .note { margin-top:20px; font-size:12.5px; color:#35443c; }
        .sign { display:flex; gap:60px; margin-top:48px; font-size:12px; color:#5f6f68; }
        .sign .box { flex:1; }
        .sign .line { border-top:1px solid #9aa8a1; margin-top:44px; padding-top:6px; }
        .toolbar { margin-bottom:18px; }
        .btn { font:inherit; font-weight:600; background:#157347; color:#fff; border:0; border-radius:8px; padding:9px 16px; cursor:pointer; }
        @media print { .toolbar { display:none; } body { margin:0; } }
      </style></head><body>
      <div class="toolbar"><button class="btn" onclick="window.print()">🖨️ Print / Save as PDF</button></div>
      <div class="head">
        <div><div class="company">${esc(company)}</div><div class="doc-title">Store Transfer Report</div></div>
        <div class="meta">Printed: ${esc(today)}</div>
      </div>
      <div class="route">${esc(m.from_location)} &nbsp;→&nbsp; ${esc(m.to_location)}</div>
      <div class="info">
        <div>Requested by: <b>${esc(userName(m.created_by))}</b></div>
        <div>Moved by: <b>${esc(userName(m.completed_by || m.assigned_to))}</b></div>
        <div>Created: <b>${esc(fmtDate(m.created_at))}</b></div>
        <div>Completed: <b>${esc(fmtDate(m.completed_at))}</b></div>
        ${m.notes ? `<div>Notes: <b>${esc(m.notes)}</b></div>` : ""}
      </div>
      <table>
        <thead><tr><th>#</th><th>Item</th><th class="r">Qty</th><th>Unit</th></tr></thead>
        <tbody>${rowsHtml}</tbody>
      </table>
      <div class="note">Transfer completed between the sites above. Use this report for Odoo entry.</div>
      <div class="sign">
        <div class="box"><div class="line">Moved by — ${esc(userName(m.completed_by || m.assigned_to))}</div></div>
        <div class="box"><div class="line">Received at ${esc(m.to_location)}</div></div>
      </div>
      <script>window.addEventListener('load',function(){setTimeout(function(){window.print();},250);});<\/script>
      </body></html>`;

    const w = window.open("", "_blank");
    if (!w) { toast("Allow pop-ups for this site to print", "error"); return; }
    w.document.open(); w.document.write(doc); w.document.close();
  }

  // ==========================================================================
  //  EXPORT: GS Purchasing compilation (CSV, same columns as the spreadsheet)
  // ==========================================================================
  const PURCHASING_COLUMNS = [
    "Invoice No", "Invoice Date", "Supplier", "Buyer", "Payment Terms",
    "Gross Subtotal (Rp)", "Discount (Rp)", "Tax / PPN (Rp)", "Other Fee (Rp)", "Invoice Total (Rp)",
    "Bank Name", "Account Name", "Account Number",
    "Payment Status", "Amount Paid (Rp)", "Payment Date", "Payment Ref / Notes",
  ];

  // Build the two compilation tables once; used by both the CSV export and the
  // Google Sheets sync. Returns { invoiceRows, itemRows } including headers.
  async function buildPurchasingRows() {
    const { data: rows, error } = await sb
      .from("payment_requests")
      .select("*")
      .order("invoice_date", { ascending: true, nullsFirst: false });
    if (error) throw new Error(error.message);
    if (!rows || !rows.length) throw new Error("Nothing to export yet.");

    // payment batches carry the transfer date / reference / fees
    const batchIds = [...new Set(rows.map((r) => r.batch_id).filter(Boolean))];
    const batchMap = {};
    if (batchIds.length) {
      const { data: bts } = await sb.from("disbursement_batches").select("*").in("id", batchIds);
      (bts || []).forEach((b) => (batchMap[b.id] = b));
    }

    const num = (v) => (v == null || v === "" ? "" : Math.round(Number(v) * 100) / 100);
    const lines = [PURCHASING_COLUMNS];

    rows.forEach((r) => {
      const bt = r.batch_id ? batchMap[r.batch_id] : null;
      const cur = (r.currency || "IDR").toUpperCase();
      // the compilation is in Rupiah — convert foreign invoices with the realised
      // rate when we have it, otherwise the estimate; leave blank if neither.
      const rate = cur === "IDR" ? 1 : r.fx_rate_actual || r.fx_rate || null;
      const toIdr = (v) => (v == null || v === "" ? "" : rate ? num(Number(v) * rate) : "");

      const charges = Array.isArray(r.charges) ? r.charges : [];
      const isTax = (n) => /ppn|tax|vat|pajak/i.test(n || "");
      const taxTotal = charges.filter((c) => isTax(c.name)).reduce((s, c) => s + (Number(c.amount) || 0), 0);
      const feeTotal = charges.filter((c) => !isTax(c.name)).reduce((s, c) => s + (Number(c.amount) || 0), 0);

      const itemsSubtotal = (Array.isArray(r.items) ? r.items : []).reduce(
        (s, it) => s + (Number(it.qty) || 1) * (Number(it.unit_price) || 0), 0
      );
      const gross = r.gross_subtotal != null ? r.gross_subtotal : itemsSubtotal || null;
      const discount = r.discount_total != null ? r.discount_total : (r.gross_subtotal != null ? null : 0);

      const status = r.paid_at
        ? "Paid"
        : r.status === "approved" ? "Approved – not yet paid"
        : r.status === "rejected" ? "Rejected" : "Pending approval";

      const amountPaid = r.paid_at
        ? (r.idr_actual != null ? num(r.idr_actual) : toIdr(r.amount))
        : "";

      const notes = [];
      if (bt?.bank_ref) notes.push("Ref No. " + bt.bank_ref);
      if (bt?.note) notes.push(bt.note);
      if (bt?.fees) notes.push(`Bank fee ${money(bt.fees, bt.currency || "IDR")} (excluded from amount paid)`);
      if (cur !== "IDR") {
        notes.push(
          `Invoice in ${cur} ${money(r.amount, cur)}` +
          (r.fx_rate_actual ? ` — paid at 1 ${cur} = ${Math.round(r.fx_rate_actual).toLocaleString()} IDR`
            : rate ? ` — converted at an estimated 1 ${cur} = ${Math.round(rate).toLocaleString()} IDR` : "")
        );
      }
      if (r.request_type !== "supplier") notes.push("Expense payment (non-supplier)");
      if (r.description) notes.push(r.description.replace(/\s+/g, " ").slice(0, 300));

      lines.push([
        r.ref_number || "",
        r.invoice_date || "",
        r.payee_name || "",
        r.buyer || "",
        r.payment_terms || "",
        toIdr(gross),
        toIdr(discount),
        toIdr(taxTotal || null),
        toIdr(feeTotal || null),
        toIdr(r.amount),
        r.bank_name || "",
        r.bank_account_name || "",
        r.bank_account_number || "",
        status,
        amountPaid,
        bt?.paid_date || (r.paid_at ? String(r.paid_at).slice(0, 10) : ""),
        notes.join(" | "),
      ]);
    });

    // ---- per-item detail (one row per invoice line, incl. charges) ----
    const itemLines = [[
      "Invoice No", "Invoice Date", "Supplier", "Line Type", "Item Code", "Item / Charge",
      "Qty", "Unit", "Unit Price", "Line Total", "Currency",
      "Unit Price (Rp)", "Line Total (Rp)", "Landed Unit Price", "Payment Status", "Payment Date",
    ]];

    rows.forEach((r) => {
      const bt = r.batch_id ? batchMap[r.batch_id] : null;
      const cur = (r.currency || "IDR").toUpperCase();
      const rate = cur === "IDR" ? 1 : r.fx_rate_actual || r.fx_rate || null;
      const status = r.paid_at ? "Paid" : r.status === "approved" ? "Approved – not yet paid"
        : r.status === "rejected" ? "Rejected" : "Pending approval";
      const payDate = bt?.paid_date || (r.paid_at ? String(r.paid_at).slice(0, 10) : "");
      const base = [r.ref_number || "", r.invoice_date || "", r.payee_name || ""];

      (Array.isArray(r.items) ? r.items : []).forEach((it) => {
        const qty = Number(it.qty) || 1;
        const price = Number(it.unit_price) || 0;
        // prefer the actual IDR unit price written at payment time
        const idrUnit = it.idr_unit_price != null ? Number(it.idr_unit_price) : rate ? price * rate : null;
        itemLines.push([
          ...base, "Item", it.item_code && it.item_code !== "N/A" ? it.item_code : "", it.item_name || "",
          qty, it.unit || "", num(price), num(qty * price), cur,
          idrUnit == null ? "" : num(idrUnit),
          idrUnit == null ? "" : num(qty * idrUnit),
          it.landed_unit_price != null ? num(it.landed_unit_price) : "",
          status, payDate,
        ]);
      });

      (Array.isArray(r.charges) ? r.charges : []).forEach((c) => {
        const amt = Number(c.amount) || 0;
        const idrAmt = c.idr_amount != null ? Number(c.idr_amount) : rate ? amt * rate : null;
        itemLines.push([
          ...base, "Charge", "", c.name || "",
          1, "", num(amt), num(amt), cur,
          idrAmt == null ? "" : num(idrAmt),
          idrAmt == null ? "" : num(idrAmt),
          "",
          status, payDate,
        ]);
      });
    });

    return { invoiceRows: lines, itemRows: itemLines, count: rows.length };
  }

  async function exportPurchasingCsv() {
    toast("Preparing export…");
    try {
      const { invoiceRows, itemRows, count } = await buildPurchasingRows();
      const stamp = new Date().toISOString().slice(0, 10);
      downloadCsv(`GS_Purchasing_invoices_${stamp}.csv`, invoiceRows);
      setTimeout(() => downloadCsv(`GS_Purchasing_items_${stamp}.csv`, itemRows), 600);
      toast(`Exported ${count} invoice(s) and ${itemRows.length - 1} item line(s) ✔`);
    } catch (e) {
      toast(e.message || "Export failed", "error");
    }
  }

  // ==========================================================================
  //  GOOGLE SYNC — writes the compilation into the Sheet, files into Drive
  // ==========================================================================
  const googleSyncOn = () => !!(cfg.GOOGLE_SYNC_ENABLED && cfg.GOOGLE_SHEET_ID);

  async function callGoogleSync(payload) {
    const { data, error } = await sb.functions.invoke(cfg.GOOGLE_SYNC_FUNCTION || "gs-sync", { body: payload });
    if (error) {
      let detail = "";
      try { detail = (await error.context?.json())?.error || ""; } catch { /* ignore */ }
      throw new Error(detail || "Google sync is unavailable — is the gs-sync function deployed?");
    }
    if (data?.error) throw new Error(data.error);
    return data;
  }

  async function syncToGoogleSheet({ silent = false } = {}) {
    if (!googleSyncOn()) {
      if (!silent) toast("Google sync is turned off in config.js", "error");
      return;
    }
    try {
      if (!silent) toast("Syncing to Google Sheets…");
      const { invoiceRows, itemRows, count } = await buildPurchasingRows();
      await callGoogleSync({
        action: "sheet",
        spreadsheetId: cfg.GOOGLE_SHEET_ID,
        tabs: [
          { name: cfg.GOOGLE_SHEET_TAB_INVOICES || "App Invoice Summary", rows: invoiceRows },
          { name: cfg.GOOGLE_SHEET_TAB_ITEMS || "App Item Detail", rows: itemRows },
        ],
      });
      if (!silent) toast(`Synced ${count} invoice(s) to Google Sheets ✔`);
    } catch (e) {
      // never block the app on a sync problem
      toast("Google sync: " + (e.message || "failed"), "error");
    }
  }

  // Upload one attachment into the Drive folder (best effort, non-blocking).
  async function syncFileToDrive(file, filename) {
    if (!googleSyncOn() || !cfg.GOOGLE_DRIVE_FOLDER_ID || !file) return;
    try {
      const b64 = await new Promise((res, rej) => {
        const rd = new FileReader();
        rd.onload = () => res(String(rd.result).split(",")[1]);
        rd.onerror = rej;
        rd.readAsDataURL(file);
      });
      await callGoogleSync({
        action: "file",
        folderId: cfg.GOOGLE_DRIVE_FOLDER_ID,
        filename,
        mimeType: file.type || "application/octet-stream",
        data: b64,
      });
    } catch (e) {
      toast("Drive upload: " + (e.message || "failed"), "error");
    }
  }

  const safeName = (s) => String(s || "").replace(/[\\/:*?"<>|]+/g, "-").replace(/\s+/g, " ").trim().slice(0, 80);

  function downloadCsv(filename, lines) {
    const csv = lines
      .map((row) => row.map((c) => `"${String(c ?? "").replace(/"/g, '""')}"`).join(","))
      .join("\r\n");
    const blob = new Blob(["﻿" + csv], { type: "text/csv;charset=utf-8;" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { URL.revokeObjectURL(a.href); a.remove(); }, 1000);
  }

  // ==========================================================================
  //  VIEW: PURCHASING BOOK (admin) — the searchable replacement for the sheet
  // ==========================================================================
  async function renderPurchasing() {
    const root = $("#view-root");
    if (!state.purchAll) {
      root.innerHTML = '<div class="loading">Loading the purchasing book…</div>';
      const { data, error } = await sb
        .from("payment_requests")
        .select("*")
        .order("invoice_date", { ascending: false, nullsFirst: false })
        .order("created_at", { ascending: false });
      if (error) { root.innerHTML = errorBox(error.message); return; }
      state.purchAll = data || [];
    }

    const q = (state.purchSearch || "").trim().toLowerCase();
    const f = state.purchFilter || "all";

    // value in IDR: what was actually paid, else the invoice/estimate
    const idrOf = (r) => {
      if (r.idr_actual != null) return Number(r.idr_actual);
      if ((r.currency || "IDR") === "IDR") return Number(r.amount || 0);
      if (r.idr_estimate != null) return Number(r.idr_estimate);
      return null;
    };

    const matches = (r) => {
      if (f === "paid" && !r.paid_at) return false;
      if (f === "unpaid" && (r.paid_at || r.status !== "approved")) return false;
      if (f === "pending" && r.status !== "pending") return false;
      if (!q) return true;
      const hay = [
        r.ref_number, r.payee_name, r.title, r.buyer, r.description,
        r.bank_name, r.bank_account_number, r.payment_terms,
        ...(Array.isArray(r.items) ? r.items.map((i) => `${i.item_name} ${i.item_code || ""}`) : []),
      ].join(" ").toLowerCase();
      return hay.includes(q);
    };

    const rows = state.purchAll.filter(matches);
    const totalIdr = rows.reduce((s, r) => s + (idrOf(r) || 0), 0);
    const unknown = rows.filter((r) => idrOf(r) == null).length;
    const paidCount = rows.filter((r) => r.paid_at).length;
    // foreign rows not yet repriced contribute an estimated IDR to the total
    const estimatedCount = rows.filter(
      (r) => (r.currency || "IDR") !== "IDR" && r.idr_actual == null && idrOf(r) != null
    ).length;

    const pill = (key, label) =>
      `<button class="filter-pill ${f === key ? "active" : ""}" data-filter="${key}">${label}</button>`;

    root.innerHTML = `
      <div class="toolbar">
        <input id="purch-search" placeholder="Search invoice no, supplier, item, note…"
               value="${esc(state.purchSearch || "")}" style="max-width:340px" />
        ${pill("all", "All")}${pill("paid", "Paid")}${pill("unpaid", "Approved – unpaid")}${pill("pending", "Pending")}
        <span class="spacer"></span>
        <button class="btn btn-ghost btn-sm" id="purch-refresh">↻ Refresh</button>
        <button class="btn btn-ghost btn-sm" id="purch-export">⬇️ Export CSV</button>
      </div>
      <div class="grand" style="margin-top:0">
        <span>${rows.length} invoice${rows.length === 1 ? "" : "s"} · ${paidCount} paid${
          estimatedCount ? ` · <span class="fx-hint">incl. ${estimatedCount} estimated</span>` : ""
        }${unknown ? ` · <span class="fx-hint">${unknown} without an IDR value</span>` : ""}</span>
        <span class="amount">${money(totalIdr, "IDR")}${
          estimatedCount ? '<div class="fx-hint" style="text-align:right">estimated where unpaid</div>' : ""
        }</span>
      </div>
      ${
        rows.length
          ? `<div class="card table-wrap" style="margin-top:14px"><table>
              <thead><tr><th>Invoice no</th><th>Date</th><th>Supplier</th><th>Amount</th><th>Status</th><th>Paid</th></tr></thead>
              <tbody>${rows
                .map((r) => {
                  const idr = idrOf(r);
                  const foreign = (r.currency || "IDR") !== "IDR";
                  // an estimate, not a settled figure: foreign and not yet repriced
                  const estimated = foreign && r.idr_actual == null;
                  const docs =
                    (Array.isArray(r.drive_invoice_files) && r.drive_invoice_files.length ? "📄" : "") +
                    (Array.isArray(r.drive_payment_files) && r.drive_payment_files.length ? "🧾" : "") +
                    (r.invoice_path ? "📎" : "");
                  return `<tr data-id="${r.id}">
                    <td>${esc(r.ref_number || "—")}${docs ? ` <span title="documents attached">${docs}</span>` : ""}</td>
                    <td>${fmtDate(r.invoice_date || r.created_at)}</td>
                    <td>${esc(r.payee_name || "—")}${
                      r.request_type !== "supplier" ? ' <span class="type-tag">expense</span>' : ""
                    }</td>
                    <td class="amount">${
                      estimated
                        // not settled yet: the foreign amount is the real figure,
                        // the IDR underneath is only an estimate for totalling
                        ? `${money(r.amount, r.currency)}<div class="paytiny">${
                            idr != null ? "≈ " + money(idr, "IDR") + " est." : "no IDR estimate"
                          }</div>`
                        : `${idr != null ? money(idr, "IDR") : "—"}${
                            foreign ? `<div class="paytiny">${money(r.amount, r.currency)} paid</div>` : ""
                          }`
                    }</td>
                    <td><span class="badge ${r.status}">${r.status}</span></td>
                    <td>${r.paid_at ? fmtDate(r.paid_at) : '<span class="paytiny">—</span>'}</td>
                  </tr>`;
                })
                .join("")}</tbody></table></div>`
          : '<div class="card panel empty"><div class="big">🔍</div><h3>Nothing matches</h3><p class="sub">Try a different search or filter.</p></div>'
      }`;

    const search = $("#purch-search");
    let t;
    search.addEventListener("input", () => {
      clearTimeout(t);
      t = setTimeout(() => {
        state.purchSearch = search.value;
        renderPurchasing();
        const s = $("#purch-search");
        if (s) { s.focus(); s.setSelectionRange(s.value.length, s.value.length); }
      }, 250);
    });
    $$(".filter-pill", root).forEach((p) =>
      p.addEventListener("click", () => { state.purchFilter = p.dataset.filter; renderPurchasing(); })
    );
    $("#purch-refresh").addEventListener("click", () => { state.purchAll = null; renderPurchasing(); });
    $("#purch-export").addEventListener("click", exportPurchasingCsv);
    $$("tbody tr", root).forEach((tr) =>
      tr.addEventListener("click", () => {
        const r = rows.find((x) => x.id === tr.dataset.id);
        if (r) openDetail(r, true, {}, "payment");
      })
    );
  }

  // ==========================================================================
  //  VIEW: SITE OPS TRACKING (admin) — all receiving + movements, with reports
  // ==========================================================================
  async function renderTracking() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading…</div>';
    await loadUsers();

    const mod = state.trackModule;
    const seg = `
      <div class="seg">
        <button data-mod="receiving" class="${mod === "receiving" ? "active" : ""}">📥 Receiving</button>
        <button data-mod="movement" class="${mod === "movement" ? "active" : ""}">🔄 Transfers</button>
      </div>`;

    const filterSets = {
      receiving: [["pending", "To check"], ["confirmed", "Confirmed"], ["all", "All"]],
      movement: [["pending", "Pending"], ["preparing", "Preparing"], ["completed", "Completed"], ["all", "All"]],
    };
    const validKeys = filterSets[mod].map((x) => x[0]);
    if (!validKeys.includes(state.trackFilter)) state.trackFilter = "all";
    const f = state.trackFilter;

    const table = mod === "receiving" ? "receiving_orders" : "store_movements";
    let query = sb.from(table).select("*").order("created_at", { ascending: false });
    if (f !== "all") query = query.eq("status", f);
    const { data, error } = await query;
    if (error) { root.innerHTML = errorBox(error.message); return; }
    const rows = data || [];

    let body;
    if (!rows.length) {
      body = '<div class="card panel empty"><div class="big">📦</div><h3>Nothing here</h3><p class="sub">No items in this filter.</p></div>';
    } else if (mod === "receiving") {
      body = `<div class="card table-wrap"><table>
        <thead><tr><th>Ref / PO</th><th>Supplier</th><th>Site</th><th>Checker</th><th>Status</th><th>Date</th><th></th></tr></thead>
        <tbody>${rows
          .map(
            (r) => `<tr data-id="${r.id}">
              <td>${esc(r.ref_number || "—")}</td>
              <td>${esc(r.supplier || "—")}</td>
              <td>${esc(r.location)}</td>
              <td>${esc(userName(r.assigned_to))}</td>
              <td><span class="badge ${r.status}">${r.status === "pending" ? "to check" : r.status}</span></td>
              <td>${fmtDate(r.confirmed_at || r.created_at)}</td>
              <td>${r.status === "confirmed" ? `<button class="btn btn-ghost btn-sm row-print" data-id="${r.id}">🖨️</button>` : ""}</td>
            </tr>`
          )
          .join("")}</tbody></table></div>`;
    } else {
      body = `<div class="card table-wrap"><table>
        <thead><tr><th>Route</th><th>Requested by</th><th>Moved by</th><th>Status</th><th>Date</th><th></th></tr></thead>
        <tbody>${rows
          .map(
            (m) => `<tr data-id="${m.id}">
              <td><b>${esc(m.from_location)}</b> → <b>${esc(m.to_location)}</b></td>
              <td>${esc(userName(m.created_by))}</td>
              <td>${esc(userName(m.completed_by || m.assigned_to))}</td>
              <td><span class="badge ${m.status}">${m.status}</span></td>
              <td>${fmtDate(m.completed_at || m.created_at)}</td>
              <td>${m.status === "completed" ? `<button class="btn btn-ghost btn-sm row-print" data-id="${m.id}">🖨️</button>` : ""}</td>
            </tr>`
          )
          .join("")}</tbody></table></div>`;
    }

    const pills = filterSets[mod]
      .map(([key, label]) => `<button class="filter-pill ${key === f ? "active" : ""}" data-filter="${key}">${label}</button>`)
      .join("");
    root.innerHTML = seg + `<div class="toolbar">${pills}</div>` + body;

    $$(".seg button", root).forEach((b) =>
      b.addEventListener("click", () => { state.trackModule = b.dataset.mod; renderTracking(); })
    );
    $$(".filter-pill", root).forEach((p) =>
      p.addEventListener("click", () => { state.trackFilter = p.dataset.filter; renderTracking(); })
    );
    // row click -> reuse the standard detail modals
    $$("tbody tr", root).forEach((tr) =>
      tr.addEventListener("click", (e) => {
        if (e.target.closest(".row-print")) return;
        const rec = rows.find((x) => x.id === tr.dataset.id);
        if (!rec) return;
        if (mod === "receiving") openReceivingDetail(rec);
        else openMovementDetail(rec);
      })
    );
    // one-click report from the list
    $$(".row-print", root).forEach((b) =>
      b.addEventListener("click", async (e) => {
        e.stopPropagation();
        const rec = rows.find((x) => x.id === b.dataset.id);
        if (!rec) return;
        if (mod === "receiving") {
          const { data: lines } = await sb.from("receiving_lines").select("*").eq("order_id", rec.id).order("position");
          printReceivingReport(rec, lines || []);
        } else {
          const { data: lines } = await sb.from("movement_lines").select("*").eq("movement_id", rec.id).order("position");
          printMovementReport(rec, lines || []);
        }
      })
    );
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

    // approved/all tabs: split into "not yet paid" + payment batches
    const showBatches = state.adminFilter === "approved" || state.adminFilter === "all";
    const paidRows = showBatches ? data.filter((r) => r.paid_at) : [];
    const unpaidRows = showBatches ? data.filter((r) => !r.paid_at) : data;

    const batchIds = [...new Set(paidRows.map((r) => r.batch_id).filter(Boolean))];
    const batchMap = {};
    if (batchIds.length) {
      const { data: batches } = await sb.from("disbursement_batches").select("*").in("id", batchIds);
      (batches || []).forEach((bt) => (batchMap[bt.id] = bt));
    }

    // fetch names: requesters + who paid + batch creators
    const ids = [
      ...new Set([
        ...data.map((r) => r.requester_id),
        ...paidRows.map((r) => r.paid_by).filter(Boolean),
        ...Object.values(batchMap).map((bt) => bt.created_by),
      ]),
    ];
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
    const pills =
      filters
        .map(
          (f) =>
            `<button class="filter-pill ${f === state.adminFilter ? "active" : ""}" data-filter="${f}">${
              f[0].toUpperCase() + f.slice(1)
            }</button>`
        )
        .join("") +
      (mod === "payment"
        ? '<span class="spacer"></span>' +
          (googleSyncOn()
            ? '<button class="btn btn-ghost btn-sm" id="sync-google">☁️ Sync to Google Sheets</button> '
            : "") +
          '<button class="btn btn-ghost btn-sm" id="export-purchasing">⬇️ Export for GS Purchasing</button>'
        : "");

    const tableFn = mod === "trip" ? tripsTable : mod === "petty" ? pettyTable : requestsTable;

    let body;
    if (!data.length) {
      body =
        '<div class="card panel empty"><div class="big">✅</div><h3>Nothing here</h3>' +
        `<p class="sub">No ${state.adminFilter === "all" ? "" : state.adminFilter} items.</p></div>`;
    } else if (!showBatches) {
      body = tableFn(data, true, nameMap, state.adminFilter === "pending");
    } else {
      body = "";
      if (unpaidRows.length) {
        body +=
          `<details class="batch-sec" open><summary class="section-h">⏳ Not yet paid (${unpaidRows.length})</summary>` +
          tableFn(unpaidRows, true, nameMap) +
          `</details>`;
      }
      // group paid items into payment batches (fallback: identical paid_at = one payment)
      const batchGroups = {};
      paidRows.forEach((r) => {
        const k = r.batch_id || "t:" + r.paid_at;
        (batchGroups[k] = batchGroups[k] || []).push(r);
      });
      const timeOf = (k) => batchMap[k]?.created_at || batchGroups[k][0].paid_at;
      const keys = Object.keys(batchGroups).sort((a, b) => new Date(timeOf(b)) - new Date(timeOf(a)));
      for (const k of keys) {
        const rows = batchGroups[k];
        const payer = batchMap[k]?.created_by || rows[0].paid_by;
        const totals = {};
        rows.forEach((r) => {
          const cur = TYPES[mod].currency(r) || "IDR";
          totals[cur] = (totals[cur] || 0) + Number(TYPES[mod].amount(r) || 0);
        });
        const totalStr = Object.entries(totals).map(([c, v]) => money(v, c)).join(" + ");
        body +=
          `<details class="batch-sec"><summary class="section-h paid">💸 Payment — ${fmtDateTime(timeOf(k))} · by ${esc(nameMap[payer] || "—")}${batchMap[k]?.bank_ref ? " · ref " + esc(batchMap[k].bank_ref) : ""} · ${rows.length} item${rows.length === 1 ? "" : "s"} · <b>${totalStr}</b>${batchMap[k]?.fees ? ` + ${money(batchMap[k].fees, batchMap[k].currency || "IDR")} fees` : ""}</summary>` +
          tableFn(rows, true, nameMap) +
          `</details>`;
      }
    }

    const bulkBar = `
      <div id="bulk-bar" class="toolbar hidden" style="gap:10px">
        <span id="bulk-count" style="font-weight:700;font-size:13px"></span>
        <button class="btn btn-success btn-sm" id="bulk-approve">✔ Approve selected</button>
        <button class="btn btn-danger btn-sm" id="bulk-reject">✕ Reject selected</button>
      </div>`;

    root.innerHTML = seg + `<div class="toolbar">${pills}</div>` + bulkBar + body;

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

    // ---- multi-select approval ----
    const updateBulk = () => {
      const n = $$(".sel-row:checked", root).length;
      $("#bulk-bar").classList.toggle("hidden", n === 0);
      $("#bulk-count").textContent = `${n} selected`;
    };
    $$(".sel-row", root).forEach((c) => c.addEventListener("change", updateBulk));
    const selAll = $(".sel-all", root);
    if (selAll)
      selAll.addEventListener("change", () => {
        $$(".sel-row:not(:disabled)", root).forEach((c) => (c.checked = selAll.checked));
        updateBulk();
      });

    const bulkReview = async (status) => {
      const ids = $$(".sel-row:checked", root).map((c) => c.dataset.id);
      if (!ids.length) return;
      let note = null;
      if (status === "rejected") {
        note = prompt(`Rejecting ${ids.length} item(s) — note to the requesters (optional):`, "");
        if (note === null) return; // cancelled
      } else if (!confirm(`Approve ${ids.length} item(s)?`)) {
        return;
      }
      const { error } = await sb
        .from(table)
        .update({
          status,
          review_note: note || null,
          reviewed_by: state.user.id,
          reviewed_at: new Date().toISOString(),
        })
        .in("id", ids);
      if (error) { toast(error.message, "error"); return; }
      toast(`${ids.length} item(s) ${status} ${status === "approved" ? "✔" : ""}`, status === "approved" ? "ok" : "error");
      state.purchAll = null;
      if (mod === "payment") syncToGoogleSheet({ silent: true });
      renderAdmin();
    };
    $("#bulk-approve")?.addEventListener("click", () => bulkReview("approved"));
    $("#bulk-reject")?.addEventListener("click", () => bulkReview("rejected"));
    $("#export-purchasing")?.addEventListener("click", exportPurchasingCsv);
    $("#sync-google")?.addEventListener("click", () => syncToGoogleSheet());
  }

  // ==========================================================================
  //  Shared: request table + detail modal
  // ==========================================================================
  const selTh = '<th style="width:34px"><input type="checkbox" class="sel-all" title="Select all" /></th>';
  const selTd = (r) => `<td><input type="checkbox" class="sel-row" data-id="${r.id}" ${r.status === "pending" ? "" : "disabled"} /></td>`;

  function requestsTable(rows, isAdmin, nameMap = {}, selectable = false) {
    const head = `
      <tr>
        ${selectable ? selTh : ""}
        ${isAdmin ? "<th>Requester</th>" : ""}
        <th>Title</th><th>Payee</th><th>Amount</th><th>Date</th><th>Status</th>
      </tr>`;
    const trs = rows
      .map(
        (r) => `
        <tr data-id="${r.id}">
          ${selectable ? selTd(r) : ""}
          ${isAdmin ? `<td>${esc(nameMap[r.requester_id] || "—")}</td>` : ""}
          <td>${r.request_type === "supplier" ? '<span class="type-tag payment">Supplier</span> ' : ""}${esc(r.title)}</td>
          <td>${esc(r.payee_name)}</td>
          <td class="amount">${
            r.idr_actual
              // settled: the IDR that actually left the bank leads
              ? `${money(r.idr_actual, "IDR")}<div class="paytiny">${money(r.amount, r.currency)} paid</div>`
              // not settled: the original amount is the real figure
              : `${money(r.amount, r.currency)}${
                  r.idr_estimate ? `<div class="paytiny">≈ ${money(r.idr_estimate, "IDR")} est.</div>` : ""
                }`
          }</td>
          <td>${fmtDate(r.transaction_date || r.created_at)}</td>
          <td><span class="badge ${r.status}">${r.status}</span></td>
        </tr>`
      )
      .join("");
    return `<div class="card table-wrap"><table><thead>${head}</thead><tbody>${trs}</tbody></table></div>`;
  }

  function tripsTable(rows, isAdmin, nameMap = {}, selectable = false) {
    const head = `
      <tr>
        ${selectable ? selTh : ""}
        ${isAdmin ? "<th>Requester</th>" : ""}
        <th>Purpose</th><th>Vehicle</th><th>Km</th><th>Amount</th><th>Trip date</th><th>Status</th>
      </tr>`;
    const trs = rows
      .map(
        (r) => `
        <tr data-id="${r.id}">
          ${selectable ? selTd(r) : ""}
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

  function pettyTable(rows, isAdmin, nameMap = {}, selectable = false) {
    const head = `
      <tr>
        ${selectable ? selTh : ""}
        ${isAdmin ? "<th>Requester</th>" : ""}
        <th>Title</th><th>Claim date</th><th>Grand total</th><th>Status</th>
      </tr>`;
    const trs = rows
      .map(
        (r) => `
        <tr data-id="${r.id}">
          ${selectable ? selTd(r) : ""}
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
      tr.addEventListener("click", (e) => {
        if (e.target.closest(".sel-row, .sel-all")) return; // checkbox clicks don't open the detail
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

  // Value in IDR: what was actually paid if known, otherwise the estimate.
  // Returns null when a foreign amount has no IDR figure at all.
  function idrValue(type, r) {
    const cur = TYPES[type].currency(r) || "IDR";
    const amt = Number(TYPES[type].amount(r) || 0);
    if (cur === "IDR") return amt;
    if (r.idr_actual != null) return Number(r.idr_actual);
    if (r.idr_estimate != null) return Number(r.idr_estimate);
    return null;
  }
  const isEstimated = (type, r) =>
    (TYPES[type].currency(r) || "IDR") !== "IDR" && r.idr_actual == null;

  async function openDetail(r, isAdmin, nameMap = {}, type = "payment", opts = {}) {
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
      const isSupplier = r.request_type === "supplier";
      rows = [
        ["Requester", requester],
        ["Type", isSupplier ? "Supplier payment" : "Expenses payment"],
        [isSupplier ? "Supplier" : "Payee / Vendor", r.payee_name],
      ];
      if (isSupplier && r.ref_number) rows.push(["PO / Invoice no", r.ref_number]);
      if (!opts.hidePrices) {
        if (r.idr_actual) {
          rows.push(["Amount paid (IDR)", money(r.idr_actual, "IDR") + (r.fx_rate_actual ? ` (1 ${r.currency} = ${Math.round(r.fx_rate_actual).toLocaleString()} IDR, excl. fees)` : "")]);
          rows.push(["Original amount", money(r.amount, r.currency)]);
        } else {
          rows.push(["Amount", money(r.amount, r.currency)]);
          if (r.idr_estimate) rows.push(["≈ IDR estimate", money(r.idr_estimate, "IDR") + (r.fx_rate ? ` (1 ${r.currency} ≈ ${Math.round(r.fx_rate).toLocaleString()} IDR)` : "")]);
        }
      }
      rows.push(
        ["Transfer date", fmtDate(r.transaction_date)],
        ["Bank name", r.bank_name || "—"],
        ["Account name", r.bank_account_name || "—"],
        ["Account number", r.bank_account_number || "—"],
        ["Submitted", fmtDate(r.created_at)],
      );
      if (r.description) rows.push(["Notes", r.description]);
      // hidePrices context (receiving): no invoice link — the invoice shows prices
      files = opts.hidePrices ? [] : [{ label: "📎 View invoice / bill", bucket: "invoices", path: r.invoice_path }];
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

    // supplier payment: show the item lines from the request
    if (type === "payment" && Array.isArray(r.items) && r.items.length) {
      const ls = card.querySelector("#lines-slot");
      if (opts.hidePrices) {
        // receiving context: items and quantities only, no money
        const lineRows = r.items
          .map((it, i) => `<tr><td>${i + 1}</td><td>${esc(it.item_name)}</td><td class="amount">${esc(it.qty)}</td></tr>`)
          .join("");
        ls.innerHTML =
          '<div class="table-wrap"><table><thead><tr><th>#</th><th>Item</th><th>Qty</th></tr></thead><tbody>' +
          lineRows +
          "</tbody></table></div>";
      } else {
        const repriced = r.idr_actual && r.items.some((it) => it.idr_unit_price != null);
        const hasCode = r.items.some((it) => it.item_code && it.item_code !== "N/A");
        const hasLanded = r.items.some((it) => it.landed_unit_price != null);
        const lineRows = r.items
          .map((it, i) => {
            const qty = Number(it.qty) || 1;
            const codeCell = hasCode ? `<td class="paytiny">${esc(it.item_code && it.item_code !== "N/A" ? it.item_code : "—")}</td>` : "";
            // landed cost = unit price incl. its share of tax / shipping
            const landedCell = hasLanded
              ? `<td class="amount">${it.landed_unit_price != null ? money(it.landed_unit_price, r.currency) : "—"}</td>`
              : "";
            if (repriced && it.idr_unit_price != null) {
              return (
                `<tr><td>${i + 1}</td>${codeCell}<td>${esc(it.item_name)}</td><td class="amount">${esc(it.qty)}</td>` +
                `<td class="amount">${money(it.idr_unit_price, "IDR")}<div class="paytiny">${money(it.unit_price, r.currency)}</div></td>` +
                landedCell +
                `<td class="amount">${money(qty * it.idr_unit_price, "IDR")}<div class="paytiny">${money(qty * (Number(it.unit_price) || 0), r.currency)}</div></td></tr>`
              );
            }
            return (
              `<tr><td>${i + 1}</td>${codeCell}<td>${esc(it.item_name)}</td><td class="amount">${esc(it.qty)}</td>` +
              `<td class="amount">${money(it.unit_price, r.currency)}</td>` +
              landedCell +
              `<td class="amount">${money(qty * (Number(it.unit_price) || 0), r.currency)}</td></tr>`
            );
          })
          .join("");
        // label column spans everything between the "#" and the final total column
        const labelSpan = 3 + (hasCode ? 1 : 0) + (hasLanded ? 1 : 0);
        const chargeRows = (Array.isArray(r.charges) ? r.charges : [])
          .map((c) =>
            `<tr><td></td><td colspan="${labelSpan}" style="text-align:right;color:var(--muted)">${esc(c.name)}</td>` +
            (repriced && c.idr_amount != null
              ? `<td class="amount">${money(c.idr_amount, "IDR")}<div class="paytiny">${money(c.amount, r.currency)}</div></td>`
              : `<td class="amount">${money(c.amount, r.currency)}</td>`) +
            `</tr>`
          )
          .join("");
        const foot = (label, value, sub) =>
          `<tr><td></td><td colspan="${labelSpan}" style="text-align:right;font-weight:700">${label}</td>` +
          `<td class="amount" style="font-weight:700">${value}${sub ? `<div class="paytiny">${sub}</div>` : ""}</td></tr>`;
        ls.innerHTML =
          '<div class="table-wrap"><table><thead><tr><th>#</th>' +
          (hasCode ? "<th>Code</th>" : "") +
          "<th>Item</th><th>Qty</th><th>Unit price</th>" +
          (hasLanded ? '<th>Landed unit<div class="paytiny">incl. tax/shipping</div></th>' : "") +
          "<th>Total</th></tr></thead><tbody>" +
          lineRows +
          chargeRows +
          (repriced
            ? foot("Total paid (IDR, excl. fees)", money(r.idr_actual, "IDR"), money(r.amount, r.currency))
            : foot("Total", money(r.amount, r.currency)) +
              (r.idr_estimate ? foot("≈ IDR estimate", money(r.idr_estimate, "IDR")) : "")) +
          "</tbody></table></div>";
      }
    }

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

    // documents that live in Google Drive (historical imports)
    if (type === "payment" && !opts.hidePrices) {
      const driveSlot = card.querySelector("#file-slot");
      const driveDocs = [
        ...(Array.isArray(r.drive_invoice_files) ? r.drive_invoice_files.map((d) => ({ ...d, icon: "📄" })) : []),
        ...(Array.isArray(r.drive_payment_files) ? r.drive_payment_files.map((d) => ({ ...d, icon: "🧾" })) : []),
      ];
      driveDocs.forEach((d) => {
        const label = d.name && d.name.length > 46 ? d.name.slice(0, 44) + "…" : d.name || "Document";
        driveSlot.append(
          el(`<a class="btn btn-ghost btn-sm" href="${esc(d.url)}" target="_blank" rel="noopener" title="${esc(d.name || "")}">${d.icon} ${esc(label)}</a>`)
        );
      });
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

    // Admin: show the payment entry (ref, date, proof) for paid items
    if (isAdmin && r.batch_id) {
      const { data: bt } = await sb.from("disbursement_batches").select("*").eq("id", r.batch_id).maybeSingle();
      if (bt) {
        const slot2 = card.querySelector("#file-slot");
        const bits = [];
        if (bt.paid_date) bits.push("paid " + fmtDate(bt.paid_date));
        if (bt.amount) bits.push(money(bt.amount, bt.currency || "IDR"));
        if (bt.fees) bits.push("+ " + money(bt.fees, bt.currency || "IDR") + " fees");
        if (bt.bank_ref) bits.push("ref " + bt.bank_ref);
        if (bits.length) slot2.append(el(`<span class="hint">💸 ${esc(bits.join(" · "))}</span>`));
        if (bt.proof_path) {
          const { data: pu } = await sb.storage.from("payment-proofs").createSignedUrl(bt.proof_path, 120);
          if (pu) slot2.append(el(`<a class="btn btn-ghost btn-sm" href="${pu.signedUrl}" target="_blank" rel="noopener">🧾 View transfer proof</a>`));
        }
      }
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

    // Admin: input the payment for an approved & unpaid item
    if (isAdmin && r.status === "approved" && !r.paid_at && !opts.hidePrices) {
      const pay = el('<button class="btn btn-primary">💸 Input payment</button>');
      pay.addEventListener("click", () => openPaymentModal([{ type, r }]));
      actions.append(pay);
    }

    // Admin: reprice a PAID foreign-currency payment into actual IDR
    if (isAdmin && type === "payment" && r.paid_at && (r.currency || "IDR") !== "IDR" && !opts.hidePrices) {
      const rp = el(`<button class="btn btn-ghost">💱 ${r.idr_actual ? "Fix IDR repricing" : "Reprice to IDR"}</button>`);
      rp.addEventListener("click", async () => {
        const val = prompt(
          `Actual IDR paid for ${money(r.amount, r.currency)} (excluding bank fees):`,
          r.idr_actual || ""
        );
        if (val == null) return;
        const idr = Number(String(val).replace(/[^\d.]/g, ""));
        if (!idr || idr <= 0) { toast("Enter a valid IDR amount", "error"); return; }
        rp.disabled = true;
        if (await repriceToIdr(r, idr)) {
          toast(`Repriced at 1 ${r.currency} = ${Math.round(idr / Number(r.amount)).toLocaleString()} IDR`);
          closeModal();
          route();
        } else rp.disabled = false;
      });
      actions.append(rp);
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
    state.purchAll = null;
    if (type === "payment") syncToGoogleSheet({ silent: true });
    renderAdmin();
  }

  // ==========================================================================
  //  PAYMENT ENTRY — replaces instant "mark paid": input the payment details,
  //  attach the transfer proof, optionally AI-verify it, then save the batch.
  //  items: [{ type, r }]
  // ==========================================================================
  function openPaymentModal(items) {
    const totals = {};
    items.forEach((it) => {
      const cur = TYPES[it.type].currency(it.r) || "IDR";
      totals[cur] = (totals[cur] || 0) + Number(TYPES[it.type].amount(it.r) || 0);
    });
    const curs = Object.keys(totals);
    const totalStr = Object.entries(totals).map(([c, v]) => money(v, c)).join(" + ");
    const singleCur = curs.length === 1 ? curs[0] : null;
    const today = new Date().toISOString().slice(0, 10);
    const curOptions = [...new Set(["IDR", ...curs, "USD", "SGD", "EUR"])];

    const card = el(`
      <div>
        <div style="display:flex;justify-content:space-between;align-items:start;gap:12px">
          <div>
            <h3 style="margin:0 0 4px">💸 Input payment</h3>
            <span class="hint">${items.length} item${items.length === 1 ? "" : "s"} · expected total <b>${totalStr}</b></span>
          </div>
          <button class="btn btn-ghost btn-sm" data-close>✕</button>
        </div>
        <div class="form-grid" style="margin-top:16px">
          <label>Payment date
            <input name="paid_date" type="date" value="${today}" required />
          </label>
          <label>Amount transferred
            <input name="amount" type="number" step="0.01" min="0" value="${singleCur ? totals[singleCur] : ""}" required />
          </label>
          <label>Currency
            <select name="currency">${curOptions.map((c) => `<option ${c === (singleCur || "IDR") ? "selected" : ""}>${c}</option>`).join("")}</select>
          </label>
          <label>Bank reference no. <span class="hint">(optional)</span>
            <input name="bank_ref" placeholder="Transfer reference" />
          </label>
          <label>Transaction fee <span class="hint">(optional)</span>
            <input name="fees" type="number" step="0.01" min="0" placeholder="Remittance / admin fee" />
          </label>
          <label>Note <span class="hint">(optional)</span>
            <input name="note" placeholder="e.g. transferred via BCA mobile" />
          </label>
          ${curs.some((c) => c !== "IDR")
            ? `<label class="full">Actual IDR paid — excluding bank fee <span class="hint">(reprices the foreign items into IDR)</span>
                 <input name="idr_paid" type="number" step="0.01" min="0" placeholder="Total IDR debited for this payment, without fees" />
               </label>`
            : ""}
          <div class="full">
            <label>Transfer proof (bukti transfer)</label>
            <label class="file-drop">
              <input type="file" name="proof" accept="image/*,.pdf" />
              <span id="proof-label">📎 Click to attach the transfer receipt</span>
            </label>
            <button type="button" class="btn btn-ghost btn-sm hidden" id="proof-verify" style="margin-top:8px">✨ Verify receipt against the fields</button>
            <div id="verify-box" class="verify-box hidden"></div>
          </div>
        </div>
        <div class="modal-actions">
          <button class="btn btn-primary" id="pay-save">💾 Save payment &amp; mark paid</button>
          <button class="btn btn-ghost" data-close>Cancel</button>
        </div>
        <p id="pay-msg" class="msg"></p>
      </div>`);

    openModal(card);

    const fileInput = card.querySelector("input[name=proof]");
    const verifyBtn = card.querySelector("#proof-verify");
    fileInput.addEventListener("change", () => {
      const f = fileInput.files[0];
      card.querySelector("#proof-label").innerHTML = f
        ? '<span class="file-name">📎 ' + esc(f.name) + "</span> — click to change"
        : "📎 Click to attach the transfer receipt";
      verifyBtn.classList.toggle("hidden", !f);
    });
    verifyBtn.addEventListener("click", () => verifyPaymentProof(card, fileInput.files[0], items));
    card.querySelector("#pay-save").addEventListener("click", () => savePayment(card, items, fileInput.files[0]));
  }

  async function verifyPaymentProof(card, file, items) {
    if (!file) return;
    const box = card.querySelector("#verify-box");
    const btn = card.querySelector("#proof-verify");
    btn.disabled = true;
    box.classList.remove("hidden");
    box.innerHTML = "✨ Reading the receipt…";

    try {
      const p = await readDocument(file, "payment_proof");

      // compare with the entered fields
      const enteredAmt = Number(card.querySelector("input[name=amount]").value) || 0;
      const enteredCur = card.querySelector("select[name=currency]").value;
      const enteredDate = card.querySelector("input[name=paid_date]").value;
      const checks = [];

      // fee-aware amount check: remittance receipts show principal + fees + total
      const rcur = p.currency || enteredCur;
      const near = (a, b) => b > 0 && (Math.abs(a - b) <= 1 || Math.abs(a - b) / b < 0.005);
      const principal = p.amount != null ? Number(p.amount) : null;
      const fees = p.fees != null ? Number(p.fees) : 0;
      const totalDebited =
        p.total_debited != null ? Number(p.total_debited) : principal != null && fees ? principal + fees : null;

      if (principal != null || totalDebited != null) {
        let ok = false;
        let line;
        if (principal != null && near(principal, enteredAmt)) {
          ok = true;
          line = `Amount on receipt: ${money(principal, rcur)}${fees ? ` (+ ${money(fees, rcur)} fees)` : ""} — matches`;
        } else if (totalDebited != null && near(totalDebited, enteredAmt)) {
          ok = true;
          line = `Total debited: ${money(totalDebited, rcur)}${principal != null ? ` (${money(principal, rcur)} + ${money(fees, rcur)} fees)` : ""} — matches your entered amount`;
        } else {
          line =
            `Amount on receipt: ${money(principal != null ? principal : totalDebited, rcur)}` +
            (fees ? ` + ${money(fees, rcur)} fees = ${money(totalDebited != null ? totalDebited : principal + fees, rcur)}` : "") +
            ` — you entered ${money(enteredAmt, enteredCur)}`;
        }
        checks.push([ok, line]);
        if (fees) {
          checks.push([true, `Fees on receipt: ${money(fees, rcur)}`]);
          const feeInput = card.querySelector("input[name=fees]");
          if (feeInput && !feeInput.value) feeInput.value = fees;
        }
      } else checks.push([null, "Amount: not readable on the receipt"]);

      if (p.currency) {
        const ok = String(p.currency).toUpperCase() === enteredCur;
        checks.push([ok, `Currency on receipt: ${p.currency}` + (ok ? "" : ` — you selected ${enteredCur}`)]);
      }

      if (p.date) {
        const ok = p.date === enteredDate;
        checks.push([ok, `Date on receipt: ${fmtDate(p.date)}` + (ok ? " — matches" : ` — you entered ${fmtDate(enteredDate)}`)]);
      } else checks.push([null, "Date: not readable on the receipt"]);

      // destination account vs the items' expected accounts
      const expectedAccounts = [...new Set(items.map((it) => it.r.bank_account_number).filter(Boolean))];
      if (p.to_account) {
        const norm = (s) => String(s).replace(/\D+/g, "");
        const ok = expectedAccounts.length ? expectedAccounts.some((a) => norm(a) === norm(p.to_account)) : null;
        checks.push([ok, `Destination: ${p.bank ? p.bank + " " : ""}${p.to_account}${p.to_name ? " (" + p.to_name + ")" : ""}` + (ok === false ? " — does not match the request's account" : ok ? " — matches" : "")]);
      }
      if (p.reference) {
        const refInput = card.querySelector("input[name=bank_ref]");
        if (!refInput.value.trim()) refInput.value = p.reference;
        checks.push([true, `Reference: ${p.reference}`]);
      }

      card._verification = { extracted: p, checks: checks.map(([ok, text]) => ({ ok, text })) };
      box.innerHTML = checks
        .map(([ok, text]) => `<div class="${ok === true ? "ok" : ok === false ? "bad" : "warn"}">${ok === true ? "✓" : ok === false ? "✗" : "•"} ${esc(text)}</div>`)
        .join("");
      const bad = checks.filter(([ok]) => ok === false).length;
      box.append(el(`<div style="margin-top:6px;font-weight:700" class="${bad ? "bad" : "ok"}">${bad ? bad + " mismatch(es) — please double-check before saving" : "Receipt matches the entered details ✓"}</div>`));
    } catch (err) {
      box.innerHTML = `<div class="bad">✗ ${esc(err.message || "Could not verify the receipt.")}</div>`;
    } finally {
      btn.disabled = false;
    }
  }

  // apply the realized IDR value (excl. fees) to one foreign-currency request
  async function repriceToIdr(r, idrPaid) {
    const rate = idrPaid / Number(r.amount);
    const patch = {
      idr_actual: Math.round(idrPaid * 100) / 100,
      fx_rate_actual: Math.round(rate * 1e6) / 1e6,
    };
    if (Array.isArray(r.items) && r.items.length) {
      patch.items = r.items.map((li) => ({ ...li, idr_unit_price: Math.round(Number(li.unit_price) * rate) }));
    }
    if (Array.isArray(r.charges) && r.charges.length) {
      patch.charges = r.charges.map((c) => ({ ...c, idr_amount: Math.round(Number(c.amount) * rate) }));
    }
    const { error } = await sb.from("payment_requests").update(patch).eq("id", r.id);
    if (error) { toast("Repricing failed: " + error.message, "error"); return false; }
    state.purchAll = null;
    return true;
  }

  async function savePayment(card, items, file) {
    const msg = card.querySelector("#pay-msg");
    const saveBtn = card.querySelector("#pay-save");
    const paidDate = card.querySelector("input[name=paid_date]").value;
    const amount = Number(card.querySelector("input[name=amount]").value);
    const currency = card.querySelector("select[name=currency]").value;
    const bankRef = card.querySelector("input[name=bank_ref]").value.trim();
    const feesVal = Number(card.querySelector("input[name=fees]").value) || 0;
    const note = card.querySelector("input[name=note]").value.trim();

    if (!paidDate) { msg.textContent = "Enter the payment date."; msg.className = "msg error"; return; }
    if (!amount || amount <= 0) { msg.textContent = "Enter the transferred amount."; msg.className = "msg error"; return; }
    if (file && file.size > 10 * 1024 * 1024) { msg.textContent = "Proof file is over 10 MB."; msg.className = "msg error"; return; }

    saveBtn.disabled = true;
    msg.className = "msg"; msg.textContent = "Saving payment…";

    try {
      let proofPath = null;
      if (file) {
        const safe = file.name.replace(/[^\w.\-]+/g, "_").slice(-50);
        proofPath = `${state.user.id}/${Date.now()}-${safe}`;
        const up = await sb.storage.from("payment-proofs").upload(proofPath, file, { upsert: false });
        if (up.error) throw up.error;
      }

      const { data: batch, error: bErr } = await sb
        .from("disbursement_batches")
        .insert({
          created_by: state.user.id,
          paid_date: paidDate,
          amount,
          currency,
          bank_ref: bankRef || null,
          fees: feesVal || null,
          note: note || null,
          proof_path: proofPath,
          verification: card._verification || null,
        })
        .select()
        .single();
      if (bErr) throw bErr;

      const stamp = { paid_at: new Date(paidDate + "T12:00:00").toISOString(), paid_by: state.user.id, batch_id: batch.id };
      const byType = {};
      items.forEach((it) => (byType[it.type] = byType[it.type] || []).push(it.r.id));
      for (const [type, ids] of Object.entries(byType)) {
        const { error: uErr } = await sb.from(TYPES[type].table).update(stamp).in("id", ids);
        if (uErr) throw uErr;
      }

      // reprice foreign-currency requests into IDR using the actual paid value
      try {
        const idrPaidInput = card.querySelector("input[name=idr_paid]");
        const idrPaid = (idrPaidInput ? Number(idrPaidInput.value) : 0) || (currency === "IDR" ? amount : 0);
        const foreign = items.filter((it) => it.type === "payment" && (it.r.currency || "IDR") !== "IDR");
        const foreignCurs = [...new Set(foreign.map((it) => it.r.currency))];
        if (idrPaid > 0 && foreign.length && foreignCurs.length === 1) {
          const fTotal = foreign.reduce((s, it) => s + Number(it.r.amount || 0), 0);
          if (fTotal > 0) {
            const rate = idrPaid / fTotal;
            for (const it of foreign) {
              await repriceToIdr(it.r, Number(it.r.amount) * rate);
            }
            toast(`Items repriced at 1 ${foreignCurs[0]} = ${Math.round(rate).toLocaleString()} IDR`);
          }
        }
      } catch (rpErr) {
        toast("Paid, but repricing failed: " + (rpErr.message || rpErr), "error");
      }

      // file the transfer proof in Drive and refresh the sheet (best effort)
      if (file) {
        const ext = file.name.includes(".") ? file.name.slice(file.name.lastIndexOf(".")) : "";
        const refs = items.map((it) => it.r.ref_number).filter(Boolean).join(", ");
        syncFileToDrive(file, `${paidDate} - payment proof${refs ? " - " + safeName(refs) : ""}${bankRef ? " - " + safeName(bankRef) : ""}${ext}`);
      }
      state.purchAll = null; // purchasing book must reload
      syncToGoogleSheet({ silent: true });

      closeModal();
      toast("Payment saved — marked paid 💸");
      route();
    } catch (err) {
      msg.textContent = err.message || "Something went wrong.";
      msg.className = "msg error";
      saveBtn.disabled = false;
    }
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

    const destList = []; // flat list of destination sub-groups, indexed by the Pay buttons
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

      // per-currency subtotal (what you actually transfer), plus an IDR equivalent
      const totals = {};
      let gIdr = 0, gForeign = false, gUnknown = false;
      groupItems.forEach((it) => {
        const cur = TYPES[it.type].currency(it.r) || "IDR";
        const amt = Number(TYPES[it.type].amount(it.r) || 0);
        totals[cur] = (totals[cur] || 0) + amt;
        if (cur !== "IDR") gForeign = true;
        const v = idrValue(it.type, it.r);
        if (v == null) gUnknown = true; else gIdr += v;
      });
      const totalStr =
        Object.entries(totals).map(([c, v]) => money(v, c)).join(" + ") +
        (gForeign
          ? `<div class="fx-hint" style="font-weight:600">≈ ${money(gIdr, "IDR")} est.${gUnknown ? " + unknown" : ""}</div>`
          : "");

      // sub-group by destination account: supplier/payee for payment requests,
      // the employee's own rekening for reimbursements. One transfer per group.
      const dests = {};
      groupItems.forEach((it) => {
        const { type, r } = it;
        let key, label, bank, acct, holder;
        if (type === "payment") {
          if (r.bank_account_number) {
            key = "a:" + String(r.bank_account_number).replace(/\D+/g, "");
            bank = r.bank_name; acct = r.bank_account_number; holder = r.bank_account_name;
          } else {
            key = "p:" + String(r.payee_name || "").trim().toLowerCase();
          }
          label = "🏭 " + (r.payee_name || "Supplier");
        } else {
          key = "self";
          label = "🧾 Reimbursement to " + name;
          bank = p.bank_name; acct = p.bank_account_number; holder = p.bank_account_name;
        }
        if (!dests[key]) dests[key] = { label, bank, acct, holder, items: [] };
        dests[key].items.push(it);
      });

      const destHtml = Object.keys(dests)
        .map((dk) => {
          const d = dests[dk];
          destList.push({ uid, items: d.items });
          const di = destList.length - 1;

          const dTotals = {};
          let dIdr = 0, dForeign = false, dUnknown = false;
          d.items.forEach((it) => {
            const c = TYPES[it.type].currency(it.r) || "IDR";
            dTotals[c] = (dTotals[c] || 0) + Number(TYPES[it.type].amount(it.r) || 0);
            if (c !== "IDR") dForeign = true;
            const v = idrValue(it.type, it.r);
            if (v == null) dUnknown = true; else dIdr += v;
          });
          const dTotalStr =
            Object.entries(dTotals).map(([c, v]) => money(v, c)).join(" + ") +
            (dForeign
              ? `<div class="fx-hint">≈ ${money(dIdr, "IDR")}${dUnknown ? " + unknown" : ""}</div>`
              : "");
          const acctLine = d.acct
            ? `${esc(d.bank || "Bank")} · <span class="rek">${esc(d.acct)}</span>${d.holder ? " · " + esc(d.holder) : ""}`
            : '<span class="missing">⚠️ no account on file</span>';

          const rowsHtml = d.items
            .map((it) => {
              const { type, r } = it;
              const amt = TYPES[type].amount(r);
              const cur = TYPES[type].currency(r) || "IDR";
              const idrEq = idrValue(type, r);
              return `
                <tr data-type="${type}" data-id="${r.id}">
                  <td><span class="type-tag ${type}">${TYPES[type].label}</span></td>
                  <td>${esc(TYPES[type].title(r))}</td>
                  <td>${fmtDate(r.reviewed_at)}</td>
                  <td class="amount">${amt != null ? money(amt, cur) : "—"}${
                    cur !== "IDR"
                      ? `<div class="paytiny">${idrEq != null ? "≈ " + money(idrEq, "IDR") + " est." : "no IDR estimate"}</div>`
                      : ""
                  }</td>
                  <td><button class="btn btn-ghost btn-sm mark-paid" data-type="${type}" data-id="${r.id}">Pay this only</button></td>
                </tr>`;
            })
            .join("");

          return `
            <div class="dest-sec">
              <div class="dest-head">
                <div>
                  <div class="dest-name">${esc(d.label)}</div>
                  <div class="dest-bank">${acctLine}</div>
                </div>
                <div class="dest-actions">
                  <span class="dest-total">${dTotalStr}</span>
                  <button class="btn btn-success btn-sm pay-dest" data-di="${di}">💸 Pay (${d.items.length})</button>
                </div>
              </div>
              <div class="table-wrap">
                <table>
                  <thead><tr><th>Type</th><th>Description</th><th>Approved</th><th>Amount</th><th></th></tr></thead>
                  <tbody>${rowsHtml}</tbody>
                </table>
              </div>
            </div>`;
        })
        .join("");

      html += `
        <div class="card panel disburse-group">
          <div class="dg-head">
            <div>
              <div class="dg-user">${esc(name)}</div>
              ${bankLine}
            </div>
            <div style="display:flex;flex-direction:column;align-items:flex-end;gap:8px">
              <div class="dg-total"><div class="lbl">To pay</div><div class="val">${totalStr}</div></div>
              <div style="display:flex;gap:8px">
                <button class="btn btn-ghost btn-sm print-group" data-uid="${uid}">🖨️ Print</button>
                ${
                  // one payment record = one transfer, so only offer "pay all"
                  // when everything for this person goes to the same account
                  Object.keys(dests).length === 1
                    ? `<button class="btn btn-success btn-sm mark-all-paid" data-uid="${uid}">💸 Pay all (${groupItems.length})</button>`
                    : `<span class="hint">${Object.keys(dests).length} accounts — pay per group below</span>`
                }
              </div>
            </div>
          </div>
          ${destHtml}
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
    // per-item payment entry
    $$(".mark-paid", root).forEach((b) =>
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        const it = items.find((x) => x.type === b.dataset.type && x.r.id === b.dataset.id);
        if (it) openPaymentModal([it]);
      })
    );
    // print buttons (one printable payout sheet per employee)
    $$(".print-group", root).forEach((b) =>
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        printDisbursement(profMap[b.dataset.uid] || {}, groups[b.dataset.uid] || []);
      })
    );
    // pay ALL of one employee's items in one payment entry
    $$(".mark-all-paid", root).forEach((b) =>
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        const groupItems = groups[b.dataset.uid] || [];
        if (groupItems.length) openPaymentModal(groupItems);
      })
    );
    // pay one destination (supplier / rekening) in a single payment entry
    $$(".pay-dest", root).forEach((b) =>
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        const d = destList[Number(b.dataset.di)];
        if (d && d.items.length) openPaymentModal(d.items);
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
  //  VIEW: NO ACCESS — a newly registered account, nothing granted yet
  // ==========================================================================
  function renderNoAccess() {
    $("#view-root").innerHTML = `
      <div class="card panel empty" style="max-width:560px;margin:0 auto">
        <div class="big">👋</div>
        <h3>Welcome, ${esc((state.profile.full_name || state.profile.email || "").split(" ")[0])}</h3>
        <p class="sub">Your account is created, but an administrator hasn't given you access to any
        features yet. Please ask them to enable what you need — then reload this page.</p>
        <p class="sub">In the meantime you can fill in your bank details so reimbursements are ready to be paid.</p>
        <button class="btn btn-primary" data-nav="#settings">⚙️ Open My Settings</button>
      </div>`;
  }

  // ==========================================================================
  //  VIEW: USERS & ACCESS (admin) — who can use which feature
  // ==========================================================================
  async function renderUsers() {
    const root = $("#view-root");
    root.innerHTML = '<div class="loading">Loading users…</div>';

    const { data, error } = await sb
      .from("profiles")
      .select("id,full_name,email,role,permissions")
      .order("full_name");
    if (error) { root.innerHTML = errorBox(error.message); return; }

    const rows = (data || [])
      .map((u) => {
        const perms = permsOf(u);
        const custom = Array.isArray(u.permissions);
        const cells = FEATURES.map(
          ([key]) =>
            `<td style="text-align:center"><input type="checkbox" class="perm" data-uid="${u.id}" data-feat="${key}" ${
              perms.includes(key) ? "checked" : ""
            } style="width:18px;height:18px;accent-color:var(--green-600)" /></td>`
        ).join("");
        return `<tr data-uid="${u.id}">
          <td>
            <div style="font-weight:600">${esc(u.full_name || "—")}${
              u.id === state.user.id ? ' <span class="type-tag">you</span>' : ""
            }</div>
            <div class="paytiny">${esc(u.email || "")}</div>
          </td>
          <td>
            <select class="role-sel" data-uid="${u.id}" ${u.id === state.user.id ? "disabled title='You cannot change your own role'" : ""}>
              <option value="employee" ${u.role !== "admin" ? "selected" : ""}>employee</option>
              <option value="admin" ${u.role === "admin" ? "selected" : ""}>admin</option>
            </select>
          </td>
          ${cells}
          <td class="paytiny" style="white-space:nowrap">
            <span data-state="${u.id}">${
              custom && perms.length === 0 ? '<b style="color:var(--red)">no access</b>' : custom ? "custom" : "role default"
            }</span>
            <button class="btn btn-ghost btn-sm grant-default" data-uid="${u.id}" style="margin-left:6px">Employee set</button>
          </td>
        </tr>`;
      })
      .join("");

    root.innerHTML = `
      <div class="card panel" style="margin-bottom:14px">
        <h3 style="margin:0 0 4px">Feature access</h3>
        <p class="sub" style="margin:0">Tick what each person can open. Changes save immediately and are enforced by the
        database, not just the menus. A user left on <b>role default</b> gets the standard set for their role —
        employees get the four request features, admins get everything.</p>
      </div>
      <div class="card table-wrap"><table>
        <thead><tr>
          <th>User</th><th>Role</th>
          ${FEATURES.map(([, label]) => `<th style="text-align:center;font-size:10px">${label.replace(" ", "<br>")}</th>`).join("")}
          <th>Access</th>
        </tr></thead>
        <tbody>${rows}</tbody>
      </table></div>
      <p id="users-msg" class="msg"></p>`;

    const msg = $("#users-msg");

    const savePerms = async (uid) => {
      const list = $$(`.perm[data-uid="${uid}"]`).filter((c) => c.checked).map((c) => c.dataset.feat);
      const { error: e } = await sb.from("profiles").update({ permissions: list }).eq("id", uid);
      if (e) { msg.textContent = e.message; msg.className = "msg error"; return; }
      const tag = $(`[data-state="${uid}"]`);
      if (tag) tag.textContent = "custom";
      msg.textContent = "Saved ✔";
      msg.className = "msg ok";
      if (uid === state.user.id) { await loadProfile(); showApp(); location.hash = "#users"; }
    };

    $$(".perm", root).forEach((c) => c.addEventListener("change", () => savePerms(c.dataset.uid)));

    // one click to give a new person the standard employee features
    $$(".grant-default", root).forEach((b) =>
      b.addEventListener("click", async () => {
        $$(`.perm[data-uid="${b.dataset.uid}"]`).forEach((c) => {
          c.checked = EMPLOYEE_DEFAULT.includes(c.dataset.feat);
        });
        await savePerms(b.dataset.uid);
      })
    );

    $$(".role-sel", root).forEach((s) =>
      s.addEventListener("change", async () => {
        const { error: e } = await sb.from("profiles").update({ role: s.value }).eq("id", s.dataset.uid);
        if (e) { msg.textContent = e.message; msg.className = "msg error"; return; }
        msg.textContent = `Role set to ${s.value} ✔`;
        msg.className = "msg ok";
      })
    );
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

# GS Operational System

A company operations portal. Employees log in, submit **payment requests** (with invoice/bill attachments and bank details), track their approval status, and admins approve or reject them.

Built with a **Supabase** backend (Postgres database + email/password Auth + file Storage) and a static HTML/JS front end — no server to run.

---

## What's in this folder

| File          | What it is                                                        |
|---------------|-------------------------------------------------------------------|
| `index.html`  | The web app                                                       |
| `styles.css`  | Styling                                                           |
| `app.js`      | All app logic (auth, requests, admin approvals)                   |
| `config.js`   | **You paste your Supabase keys here**                             |
| `setup.sql`   | **You run this once** in Supabase to create the database          |
| `README.md`   | This file                                                         |

---

## One-time setup (about 10 minutes)

### 1. Create a Supabase project
1. Go to **https://supabase.com** → sign up (free) → **New project**.
2. Give it a name (e.g. `gs-operational`), set a database password, pick a region close to you, and create it.

### 2. Create the database
1. In your project, open **SQL Editor** (left sidebar) → **New query**.
2. Open `setup.sql` from this folder, copy everything, paste it, and click **Run**.
   - This creates the tables, security rules, and the `invoices` storage bucket.

### 3. Connect the app to your project
1. In Supabase, open **Project Settings → API**.
2. Copy the **Project URL** and the **anon public** key.
3. Open `config.js` and paste them in:
   ```js
   SUPABASE_URL: "https://xxxxxxxx.supabase.co",
   SUPABASE_ANON_KEY: "eyJhbGciOi....",
   ```
   *(The anon key is designed to be public in front-end code — that's normal and safe. Row-Level Security protects the data.)*

### 4. Run the app locally
Just **double-click `index.html`** to open it in your browser, or serve the folder. Then:
1. Click **Sign up**, create your account with `nikco@golfsolutionsid.com`.
2. Make yourself an **admin**: back in Supabase **SQL Editor**, run:
   ```sql
   update public.profiles set role = 'admin' where email = 'nikco@golfsolutionsid.com';
   ```
3. Reload the app — you'll now see the **Admin Approvals** menu.

> If sign-up asks you to confirm your email and you'd rather skip that during testing:
> Supabase → **Authentication → Providers → Email** → turn **"Confirm email"** off.

---

## Deploying so employees can use it (cloud-hosted)

The front end is just static files, so any static host works. Easiest options:

- **Netlify:** go to https://app.netlify.com/drop and drag this folder in. Done — you get a URL.
- **Vercel / Cloudflare Pages / GitHub Pages:** upload the folder the same way.

Then in Supabase → **Authentication → URL Configuration**, add your deployed URL to the allowed redirect/site URLs.

Employees visit the URL, sign up, and start submitting requests. You (admin) approve them.

---

## How it works / security

- **Row-Level Security (RLS)** is enforced in the database:
  - Employees can only see and create *their own* requests.
  - Only admins can see *all* requests and approve/reject them.
  - Invoice files live in a private bucket; only the owner and admins can open them (via short-lived signed links).
- Passwords are handled by Supabase Auth (hashed, never stored by the app).

---

## Feature 2: Trip Reimbursement Claims

Reproduces the Golf Solutions "Trip Reimbursement Claim" form: Name, Date of Trip,
Vehicle (Motorcycle/Car), Trip Purpose, Total Kilometer (round trip), Google Map
screenshot (required), reimbursement items (Parking fees / Toll charges / Other),
and Trip Receipt — plus an optional claimed amount. Same login + admin approval flow.

**To enable it:** in Supabase → SQL Editor, run [`setup-trip-reimbursement.sql`](setup-trip-reimbursement.sql)
once (after `setup.sql`). Then reload the app:
- Employees get **🚗 My Trip Claims** and **➕ New Trip Claim** in the sidebar.
- Admins get a **Payment Requests / Trip Reimbursements** toggle under **Admin Approvals**.

> Note: the original form had no money field, so a **claimed amount** was added (optional)
> so claims carry a value to approve and post to Odoo.

---

## Feature 3: Petty Cash Reimbursement

A multi-line claim: each line has a **keterangan** (description), a **total**, and a
**receipt photo**, with a **grand total** computed at the bottom. The whole claim goes
through the same admin approval flow.

**To enable it:** in Supabase → SQL Editor, run [`setup-petty-cash.sql`](setup-petty-cash.sql)
once (after `setup.sql`). Then reload the app:
- Employees get **🧾 My Petty Cash** and **➕ New Petty Cash** in the sidebar.
- Admins get a third **Petty Cash** tab under **Admin Approvals** (the claim detail
  shows every line, its receipt photo, and the grand total).

Data model: `petty_cash_claims` (header) + `petty_cash_lines` (rows), plus a private
`petty-cash` storage bucket for the photos.

## Feature 4: Disbursement + user bank settings

After an admin **approves** an item, it moves to a payout queue:
- **⚙️ My Settings** (everyone): each user saves their **rekening** (account number) + bank name.
- **💸 Disburse** (admins only): every **approved & not-yet-paid** item across payment
  requests, trip reimbursements, and petty cash — **grouped by employee**, showing the
  rekening to pay to and a per-person total. Click **Mark paid** to disburse it (records
  `paid_at`), which removes it from the queue.

Payment requests show the *payee's* bank (from the request); trip & petty-cash show the
*employee's* rekening (from their settings).

Each employee group has a **🖨️ Print** button that opens a one-page **Payment Disbursement
Instruction** (company header, rekening, itemized list, total, signature lines) and triggers
the browser print dialog — choose **Save as PDF** to email it to the team for transfer.
*(Requires pop-ups allowed for the site.)*

**To enable it:** run [`setup-disbursement.sql`](setup-disbursement.sql) once in Supabase.
It also fixes a security gap — it stops a user from changing their own role via profile edit.

> Tip: the easiest way to run any migration is to paste the whole **[`setup-all.sql`](setup-all.sql)**
> (all features, safe to re-run) into the Supabase SQL Editor.

## Feature 5: Item Receiving + Store Movement

**Receiving:** anyone registers incoming goods (PO/invoice number, supplier, site,
attachment) with free-text item lines, and **assigns a checker**. The checker ticks
each item off on site (default site: Manhattan), then **confirms**. Confirmed
receivings produce a printable **Goods Received Report** for Odoo entry.

**Store movement:** anyone lists items + quantities, picks the route
(Manhattan / Sedayu / Premiere), and assigns someone. The assignee can mark
**preparing**, then **complete**. Completed movements produce a printable
**Store Transfer Report** for Odoo entry.

**Admin → 📦 Site Ops Tracking:** admins see every receiving and transfer with
status filters and one-click 🖨️ report buttons.

**To enable it:** run [`setup-receiving-movement.sql`](setup-receiving-movement.sql)
once in Supabase (or re-run [`setup-all.sql`](setup-all.sql)).

---

## Roadmap (next features)

Features 1 (Payment Requests), 2 (Trip Reimbursements), 3 (Petty Cash), and
4 (Disbursement) are done.
The structure is ready to add more modules (leave requests, asset tracking, reporting
dashboards) as new views in `app.js` and new tables in Supabase. Just let me know what's next.

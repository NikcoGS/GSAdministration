-- ============================================================================
-- GS Operational System — COMPLETE SETUP (all features)
-- Paste this ENTIRE file into Supabase → SQL Editor → New query → Run.
-- Safe to run more than once.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Database setup
-- Run this ONCE in the Supabase SQL Editor (Dashboard -> SQL Editor -> New query)
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. PROFILES table (one row per user, holds role: employee / admin)
-- ---------------------------------------------------------------------------
create table if not exists public.profiles (
  id         uuid primary key references auth.users (id) on delete cascade,
  email      text,
  full_name  text,
  role       text not null default 'employee' check (role in ('employee', 'admin')),
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 2. Helper: is_admin() — SECURITY DEFINER so it can read profiles without
--    triggering row-level-security recursion.
-- ---------------------------------------------------------------------------
create or replace function public.is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- ---------------------------------------------------------------------------
-- 3. Auto-create a profile whenever a new auth user signs up
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    'employee'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- 4. PAYMENT REQUESTS table
-- ---------------------------------------------------------------------------
create table if not exists public.payment_requests (
  id                  uuid primary key default gen_random_uuid(),
  requester_id        uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title               text not null,
  payee_name          text not null,
  amount              numeric(14,2) not null check (amount >= 0),
  currency            text not null default 'IDR',
  bank_name           text,
  bank_account_name   text,
  bank_account_number text,
  transaction_date    date,
  description         text,
  invoice_path        text,               -- path in the 'invoices' storage bucket
  status              text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reviewed_by         uuid references auth.users (id),
  reviewed_at         timestamptz,
  review_note         text,
  created_at          timestamptz not null default now()
);

create index if not exists payment_requests_requester_idx on public.payment_requests (requester_id);
create index if not exists payment_requests_status_idx    on public.payment_requests (status);

-- ---------------------------------------------------------------------------
-- 5. Row Level Security
-- ---------------------------------------------------------------------------
alter table public.profiles         enable row level security;
alter table public.payment_requests enable row level security;

-- ---- profiles policies ----
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select to authenticated
  using (id = auth.uid() or public.is_admin());

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (id = auth.uid());

-- safety net so a user can create their own profile row if the trigger didn't
drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
  for insert to authenticated
  with check (id = auth.uid());

-- ---- payment_requests policies ----
-- employees create their own; admins can create too (requester_id defaults to auth.uid())
drop policy if exists "pr_insert_own" on public.payment_requests;
create policy "pr_insert_own" on public.payment_requests
  for insert to authenticated
  with check (requester_id = auth.uid());

-- see your own; admins see everything
drop policy if exists "pr_select_own_or_admin" on public.payment_requests;
create policy "pr_select_own_or_admin" on public.payment_requests
  for select to authenticated
  using (requester_id = auth.uid() or public.is_admin());

-- only admins can approve / reject (update)
drop policy if exists "pr_update_admin" on public.payment_requests;
create policy "pr_update_admin" on public.payment_requests
  for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- requester may delete their own request while still pending
drop policy if exists "pr_delete_own_pending" on public.payment_requests;
create policy "pr_delete_own_pending" on public.payment_requests
  for delete to authenticated
  using (requester_id = auth.uid() and status = 'pending');

-- ---------------------------------------------------------------------------
-- 6. STORAGE bucket for invoices/bills (private)
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('invoices', 'invoices', false)
on conflict (id) do nothing;

-- upload only into your own folder:  invoices/<your-user-id>/<file>
drop policy if exists "invoice_upload_own" on storage.objects;
create policy "invoice_upload_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'invoices'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- read your own files, or any if you are an admin
drop policy if exists "invoice_read_own_or_admin" on storage.objects;
create policy "invoice_read_own_or_admin" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'invoices'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin())
  );

-- ============================================================================
-- DONE. After running this:
--   1) Register your account in the web app (Sign up).
--   2) Then promote yourself to admin by running the line below with your email:
--
--        update public.profiles set role = 'admin' where email = 'nikco@golfsolutionsid.com';
--
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 2: Trip Reimbursement Claims
-- Run this ONCE in the Supabase SQL Editor, AFTER setup.sql.
-- (Reproduces the "Golf Solutions — Trip Reimbursement Claim" form.)
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. TRIP REIMBURSEMENTS table
-- ---------------------------------------------------------------------------
create table if not exists public.trip_reimbursements (
  id                   uuid primary key default gen_random_uuid(),
  requester_id         uuid not null default auth.uid() references auth.users (id) on delete cascade,
  claimant_name        text not null,
  trip_date            date,
  vehicle_option       text check (vehicle_option in ('Motorcycle', 'Car')),
  trip_purpose         text,
  total_km             numeric(10,2) check (total_km is null or total_km >= 0),
  amount               numeric(14,2) check (amount is null or amount >= 0),  -- optional claimed amount
  currency             text not null default 'IDR',
  claim_items          text[] not null default '{}',   -- e.g. {'Parking fees','Toll charges','Other'}
  claim_items_other    text,                            -- free text when 'Other' is selected
  map_screenshot_path  text,                            -- Google Map screenshot (storage: trip-files)
  receipt_path         text,                            -- trip receipt (storage: trip-files)
  status               text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reviewed_by          uuid references auth.users (id),
  reviewed_at          timestamptz,
  review_note          text,
  created_at           timestamptz not null default now()
);

create index if not exists trip_reimb_requester_idx on public.trip_reimbursements (requester_id);
create index if not exists trip_reimb_status_idx    on public.trip_reimbursements (status);

-- ---------------------------------------------------------------------------
-- 2. Row Level Security (same model as payment_requests)
-- ---------------------------------------------------------------------------
alter table public.trip_reimbursements enable row level security;

drop policy if exists "tr_insert_own" on public.trip_reimbursements;
create policy "tr_insert_own" on public.trip_reimbursements
  for insert to authenticated
  with check (requester_id = auth.uid());

drop policy if exists "tr_select_own_or_admin" on public.trip_reimbursements;
create policy "tr_select_own_or_admin" on public.trip_reimbursements
  for select to authenticated
  using (requester_id = auth.uid() or public.is_admin());

drop policy if exists "tr_update_admin" on public.trip_reimbursements;
create policy "tr_update_admin" on public.trip_reimbursements
  for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "tr_delete_own_pending" on public.trip_reimbursements;
create policy "tr_delete_own_pending" on public.trip_reimbursements
  for delete to authenticated
  using (requester_id = auth.uid() and status = 'pending');

-- ---------------------------------------------------------------------------
-- 3. STORAGE bucket for trip files (map screenshots + receipts), private
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('trip-files', 'trip-files', false)
on conflict (id) do nothing;

drop policy if exists "trip_upload_own" on storage.objects;
create policy "trip_upload_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'trip-files'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "trip_read_own_or_admin" on storage.objects;
create policy "trip_read_own_or_admin" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'trip-files'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin())
  );

-- ============================================================================
-- DONE. Reload the web app — employees will see "Trip Reimbursement",
-- and admins will see a "Trip Reimbursements" tab under Admin Approvals.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 3: Petty Cash Reimbursement
-- Run this ONCE in the Supabase SQL Editor, AFTER setup.sql.
-- Header + line items (keterangan, total, receipt picture) with a grand total.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. HEADER: one petty cash claim
-- ---------------------------------------------------------------------------
create table if not exists public.petty_cash_claims (
  id            uuid primary key default gen_random_uuid(),
  requester_id  uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title         text,
  claim_date    date,
  currency      text not null default 'IDR',
  total_amount  numeric(14,2) not null default 0 check (total_amount >= 0),
  status        text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reviewed_by   uuid references auth.users (id),
  reviewed_at   timestamptz,
  review_note   text,
  created_at    timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 2. LINES: the individual expense rows
-- ---------------------------------------------------------------------------
create table if not exists public.petty_cash_lines (
  id            uuid primary key default gen_random_uuid(),
  claim_id      uuid not null references public.petty_cash_claims (id) on delete cascade,
  requester_id  uuid not null default auth.uid() references auth.users (id) on delete cascade,
  keterangan    text not null,
  amount        numeric(14,2) not null default 0 check (amount >= 0),
  picture_path  text,                       -- storage: petty-cash bucket
  position      int not null default 0,
  created_at    timestamptz not null default now()
);

create index if not exists petty_claims_requester_idx on public.petty_cash_claims (requester_id);
create index if not exists petty_claims_status_idx    on public.petty_cash_claims (status);
create index if not exists petty_lines_claim_idx      on public.petty_cash_lines (claim_id);

-- ---------------------------------------------------------------------------
-- 3. Row Level Security
-- ---------------------------------------------------------------------------
alter table public.petty_cash_claims enable row level security;
alter table public.petty_cash_lines  enable row level security;

-- ---- claims ----
drop policy if exists "pc_insert_own" on public.petty_cash_claims;
create policy "pc_insert_own" on public.petty_cash_claims
  for insert to authenticated
  with check (requester_id = auth.uid());

drop policy if exists "pc_select_own_or_admin" on public.petty_cash_claims;
create policy "pc_select_own_or_admin" on public.petty_cash_claims
  for select to authenticated
  using (requester_id = auth.uid() or public.is_admin());

drop policy if exists "pc_update_admin" on public.petty_cash_claims;
create policy "pc_update_admin" on public.petty_cash_claims
  for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "pc_delete_own_pending" on public.petty_cash_claims;
create policy "pc_delete_own_pending" on public.petty_cash_claims
  for delete to authenticated
  using (requester_id = auth.uid() and status = 'pending');

-- ---- lines (owned via requester_id; deleted automatically with the header) ----
drop policy if exists "pcl_insert_own" on public.petty_cash_lines;
create policy "pcl_insert_own" on public.petty_cash_lines
  for insert to authenticated
  with check (requester_id = auth.uid());

drop policy if exists "pcl_select_own_or_admin" on public.petty_cash_lines;
create policy "pcl_select_own_or_admin" on public.petty_cash_lines
  for select to authenticated
  using (requester_id = auth.uid() or public.is_admin());

drop policy if exists "pcl_delete_own" on public.petty_cash_lines;
create policy "pcl_delete_own" on public.petty_cash_lines
  for delete to authenticated
  using (requester_id = auth.uid());

-- ---------------------------------------------------------------------------
-- 4. STORAGE bucket for petty cash receipt pictures (private)
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('petty-cash', 'petty-cash', false)
on conflict (id) do nothing;

drop policy if exists "petty_upload_own" on storage.objects;
create policy "petty_upload_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'petty-cash'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "petty_read_own_or_admin" on storage.objects;
create policy "petty_read_own_or_admin" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'petty-cash'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin())
  );

-- ============================================================================
-- DONE. Reload the web app — employees get "Petty Cash", admins get a
-- "Petty Cash" tab under Admin Approvals.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 4: Disbursement + user bank details
-- Run this ONCE in the Supabase SQL Editor, AFTER setup.sql (and the others).
-- Safe to run more than once.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. User bank account (rekening) on the profile
-- ---------------------------------------------------------------------------
alter table public.profiles add column if not exists bank_name           text;
alter table public.profiles add column if not exists bank_account_number text;   -- rekening
alter table public.profiles add column if not exists bank_account_name    text;   -- account holder

-- ---------------------------------------------------------------------------
-- 2. "Paid" tracking on every reimbursable type
--    An item is "to disburse" when status = 'approved' AND paid_at IS NULL.
-- ---------------------------------------------------------------------------
alter table public.payment_requests    add column if not exists paid_at timestamptz;
alter table public.payment_requests    add column if not exists paid_by uuid references auth.users (id);
alter table public.trip_reimbursements add column if not exists paid_at timestamptz;
alter table public.trip_reimbursements add column if not exists paid_by uuid references auth.users (id);
alter table public.petty_cash_claims   add column if not exists paid_at timestamptz;
alter table public.petty_cash_claims   add column if not exists paid_by uuid references auth.users (id);

-- ---------------------------------------------------------------------------
-- 3. Security fix: stop a user from changing their own role via profile edit.
--    (Self-service settings now let users update their profile; role must
--     only ever be changed by an admin.)
-- ---------------------------------------------------------------------------
create or replace function public.protect_profile_role()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Only police requests coming from app users (auth.uid() present).
  -- Direct database access (SQL editor / service role) is trusted, so the
  -- initial admin can be promoted there.
  if new.role is distinct from old.role
     and auth.uid() is not null
     and not public.is_admin() then
    new.role := old.role;   -- silently ignore role changes by non-admins
  end if;
  return new;
end;
$$;

drop trigger if exists trg_protect_profile_role on public.profiles;
create trigger trg_protect_profile_role
  before update on public.profiles
  for each row execute function public.protect_profile_role();

-- ============================================================================
-- DONE. Reload the web app:
--   * Everyone gets "My Settings" to save their bank account (rekening).
--   * Admins get a "Disburse" menu listing approved & unpaid items by user.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 5: Item Receiving + Store Movement
-- Run this ONCE in the Supabase SQL Editor, AFTER setup.sql.
-- Safe to run more than once.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. User directory view — lets any signed-in user see names/emails so they
--    can assign tasks (bank details & roles stay private in profiles).
-- ---------------------------------------------------------------------------
create or replace view public.user_directory as
  select id, full_name, email from public.profiles;

revoke all on public.user_directory from anon;
grant select on public.user_directory to authenticated;

-- ---------------------------------------------------------------------------
-- 2. ITEM RECEIVING
-- ---------------------------------------------------------------------------
create table if not exists public.receiving_orders (
  id              uuid primary key default gen_random_uuid(),
  created_by      uuid not null default auth.uid() references auth.users (id) on delete cascade,
  supplier        text,
  ref_number      text,                       -- PO / supplier invoice number
  location        text not null default 'Manhattan' check (location in ('Manhattan','Sedayu','Premiere')),
  notes           text,
  attachment_path text,                       -- PO / invoice file (bucket: receiving-files)
  assigned_to     uuid references auth.users (id),
  status          text not null default 'pending' check (status in ('pending','confirmed')),
  confirmed_by    uuid references auth.users (id),
  confirmed_at    timestamptz,
  created_at      timestamptz not null default now()
);

create table if not exists public.receiving_lines (
  id         uuid primary key default gen_random_uuid(),
  order_id   uuid not null references public.receiving_orders (id) on delete cascade,
  item_name  text not null,
  qty        numeric(12,2) not null default 1 check (qty > 0),
  unit       text,
  checked    boolean not null default false,
  position   int not null default 0
);

create index if not exists recv_orders_created_idx  on public.receiving_orders (created_by);
create index if not exists recv_orders_assigned_idx on public.receiving_orders (assigned_to);
create index if not exists recv_lines_order_idx     on public.receiving_lines (order_id);

alter table public.receiving_orders enable row level security;
alter table public.receiving_lines  enable row level security;

drop policy if exists "ro_insert_own" on public.receiving_orders;
create policy "ro_insert_own" on public.receiving_orders
  for insert to authenticated
  with check (created_by = auth.uid());

drop policy if exists "ro_select_participant" on public.receiving_orders;
create policy "ro_select_participant" on public.receiving_orders
  for select to authenticated
  using (created_by = auth.uid() or assigned_to = auth.uid() or public.is_admin());

drop policy if exists "ro_update_participant" on public.receiving_orders;
create policy "ro_update_participant" on public.receiving_orders
  for update to authenticated
  using (
    assigned_to = auth.uid()
    or public.is_admin()
    or (created_by = auth.uid() and status = 'pending')
  );

drop policy if exists "ro_delete_own_pending" on public.receiving_orders;
create policy "ro_delete_own_pending" on public.receiving_orders
  for delete to authenticated
  using ((created_by = auth.uid() and status = 'pending') or public.is_admin());

drop policy if exists "rl_insert" on public.receiving_lines;
create policy "rl_insert" on public.receiving_lines
  for insert to authenticated
  with check (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id and o.created_by = auth.uid() and o.status = 'pending'
  ));

drop policy if exists "rl_select" on public.receiving_lines;
create policy "rl_select" on public.receiving_lines
  for select to authenticated
  using (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id
      and (o.created_by = auth.uid() or o.assigned_to = auth.uid() or public.is_admin())
  ));

drop policy if exists "rl_update" on public.receiving_lines;
create policy "rl_update" on public.receiving_lines
  for update to authenticated
  using (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id
      and (o.assigned_to = auth.uid() or public.is_admin()
           or (o.created_by = auth.uid() and o.status = 'pending'))
  ));

drop policy if exists "rl_delete" on public.receiving_lines;
create policy "rl_delete" on public.receiving_lines
  for delete to authenticated
  using (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id
      and ((o.created_by = auth.uid() and o.status = 'pending') or public.is_admin())
  ));

-- ---------------------------------------------------------------------------
-- 3. STORE MOVEMENT
-- ---------------------------------------------------------------------------
create table if not exists public.store_movements (
  id            uuid primary key default gen_random_uuid(),
  created_by    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  from_location text not null check (from_location in ('Manhattan','Sedayu','Premiere')),
  to_location   text not null check (to_location in ('Manhattan','Sedayu','Premiere')),
  notes         text,
  assigned_to   uuid references auth.users (id),
  status        text not null default 'pending' check (status in ('pending','preparing','completed')),
  completed_by  uuid references auth.users (id),
  completed_at  timestamptz,
  created_at    timestamptz not null default now()
);

create table if not exists public.movement_lines (
  id          uuid primary key default gen_random_uuid(),
  movement_id uuid not null references public.store_movements (id) on delete cascade,
  item_name   text not null,
  qty         numeric(12,2) not null default 1 check (qty > 0),
  unit        text,
  position    int not null default 0
);

create index if not exists mov_created_idx  on public.store_movements (created_by);
create index if not exists mov_assigned_idx on public.store_movements (assigned_to);
create index if not exists mov_lines_idx    on public.movement_lines (movement_id);

alter table public.store_movements enable row level security;
alter table public.movement_lines  enable row level security;

drop policy if exists "sm_insert_own" on public.store_movements;
create policy "sm_insert_own" on public.store_movements
  for insert to authenticated
  with check (created_by = auth.uid());

drop policy if exists "sm_select_participant" on public.store_movements;
create policy "sm_select_participant" on public.store_movements
  for select to authenticated
  using (created_by = auth.uid() or assigned_to = auth.uid() or public.is_admin());

drop policy if exists "sm_update_participant" on public.store_movements;
create policy "sm_update_participant" on public.store_movements
  for update to authenticated
  using (
    assigned_to = auth.uid()
    or public.is_admin()
    or (created_by = auth.uid() and status = 'pending')
  );

drop policy if exists "sm_delete_own_pending" on public.store_movements;
create policy "sm_delete_own_pending" on public.store_movements
  for delete to authenticated
  using ((created_by = auth.uid() and status = 'pending') or public.is_admin());

drop policy if exists "ml_insert" on public.movement_lines;
create policy "ml_insert" on public.movement_lines
  for insert to authenticated
  with check (exists (
    select 1 from public.store_movements m
    where m.id = movement_id and m.created_by = auth.uid() and m.status = 'pending'
  ));

drop policy if exists "ml_select" on public.movement_lines;
create policy "ml_select" on public.movement_lines
  for select to authenticated
  using (exists (
    select 1 from public.store_movements m
    where m.id = movement_id
      and (m.created_by = auth.uid() or m.assigned_to = auth.uid() or public.is_admin())
  ));

drop policy if exists "ml_delete" on public.movement_lines;
create policy "ml_delete" on public.movement_lines
  for delete to authenticated
  using (exists (
    select 1 from public.store_movements m
    where m.id = movement_id
      and ((m.created_by = auth.uid() and m.status = 'pending') or public.is_admin())
  ));

-- ---------------------------------------------------------------------------
-- 4. STORAGE bucket for PO / invoice attachments.
--    Any signed-in employee can view (assignees need to open the PO);
--    uploads go to the uploader's own folder.
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('receiving-files', 'receiving-files', false)
on conflict (id) do nothing;

drop policy if exists "recv_upload_own" on storage.objects;
create policy "recv_upload_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'receiving-files'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "recv_read_auth" on storage.objects;
create policy "recv_read_auth" on storage.objects
  for select to authenticated
  using (bucket_id = 'receiving-files');

-- ============================================================================
-- DONE. Reload the web app — everyone gets "Receiving" and "Store Movement".
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 6: Payment batches
-- Every "Mark paid" / "Mark all paid" action creates one payment batch, so
-- paid items can be grouped by the payment they were settled in.
-- Run ONCE in the Supabase SQL Editor. Safe to run more than once.
-- ============================================================================

create table if not exists public.disbursement_batches (
  id         uuid primary key default gen_random_uuid(),
  created_by uuid not null default auth.uid() references auth.users (id),
  created_at timestamptz not null default now(),
  note       text
);

alter table public.disbursement_batches enable row level security;

drop policy if exists "batch_insert_admin" on public.disbursement_batches;
create policy "batch_insert_admin" on public.disbursement_batches
  for insert to authenticated
  with check (public.is_admin());

drop policy if exists "batch_select_admin" on public.disbursement_batches;
create policy "batch_select_admin" on public.disbursement_batches
  for select to authenticated
  using (public.is_admin());

-- link every payable item to the batch that settled it
alter table public.payment_requests    add column if not exists batch_id uuid references public.disbursement_batches (id);
alter table public.trip_reimbursements add column if not exists batch_id uuid references public.disbursement_batches (id);
alter table public.petty_cash_claims   add column if not exists batch_id uuid references public.disbursement_batches (id);

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 7: Supplier vs Expense payment requests
-- Run ONCE in the Supabase SQL Editor. Safe to run more than once.
-- ============================================================================

alter table public.payment_requests add column if not exists request_type text not null default 'expense';
alter table public.payment_requests drop constraint if exists payment_requests_request_type_check;
alter table public.payment_requests add constraint payment_requests_request_type_check
  check (request_type in ('expense', 'supplier'));

alter table public.payment_requests add column if not exists ref_number    text;            -- PO / invoice number
alter table public.payment_requests add column if not exists items         jsonb;           -- [{item_name, qty, unit, unit_price, idr_estimate}]
alter table public.payment_requests add column if not exists fx_rate       numeric(16,6);   -- foreign currency -> IDR rate used
alter table public.payment_requests add column if not exists idr_estimate  numeric(16,2);   -- estimated total in IDR

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 8: link receiving to approved purchases
-- Run ONCE in the Supabase SQL Editor. Safe to run more than once.
-- ============================================================================

alter table public.receiving_orders
  add column if not exists payment_request_id uuid references public.payment_requests (id);

create index if not exists recv_orders_pr_idx on public.receiving_orders (payment_request_id);

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 9: Payment input with proof attachment
-- "Mark paid" becomes a payment entry: date, amount, bank ref, note, and the
-- transfer receipt, stored on the payment batch. Run ONCE. Safe to re-run.
-- ============================================================================

alter table public.disbursement_batches add column if not exists paid_date    date;
alter table public.disbursement_batches add column if not exists amount       numeric(16,2);
alter table public.disbursement_batches add column if not exists currency     text;
alter table public.disbursement_batches add column if not exists bank_ref     text;            -- transfer reference number
alter table public.disbursement_batches add column if not exists fees         numeric(16,2);   -- transaction / remittance fees
alter table public.disbursement_batches add column if not exists note         text;
alter table public.disbursement_batches add column if not exists proof_path   text;            -- storage: payment-proofs
alter table public.disbursement_batches add column if not exists verification jsonb;           -- AI check result

-- private bucket for transfer receipts (admins only)
insert into storage.buckets (id, name, public)
values ('payment-proofs', 'payment-proofs', false)
on conflict (id) do nothing;

drop policy if exists "proof_upload_admin" on storage.objects;
create policy "proof_upload_admin" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'payment-proofs'
    and public.is_admin()
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "proof_read_admin" on storage.objects;
create policy "proof_read_admin" on storage.objects
  for select to authenticated
  using (bucket_id = 'payment-proofs' and public.is_admin());

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 10: actual IDR repricing after payment
-- When a foreign-currency invoice is paid, the items are repriced in IDR
-- using the actual paid value (excl. bank fees); foreign stays as info.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests add column if not exists idr_actual     numeric(16,2);  -- actual IDR paid, excl. fees
alter table public.payment_requests add column if not exists fx_rate_actual numeric(16,6);  -- realized rate used for repricing

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 11: invoice charges (biaya) on supplier payments
-- PPN, biaya kirim, handling etc. as named charges separate from item lines.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests add column if not exists charges jsonb;  -- [{name, amount, idr_amount?}]

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 15: fields for the GS Purchasing compilation
-- Adds the few invoice facts the compilation spreadsheet needs that the app
-- did not store yet. Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests add column if not exists invoice_date    date;
alter table public.payment_requests add column if not exists buyer           text;            -- which entity bought (PT SGI, CV TKO, ...)
alter table public.payment_requests add column if not exists payment_terms   text;            -- e.g. C.O.D, Bank Transfer, 30 days
alter table public.payment_requests add column if not exists gross_subtotal  numeric(16,2);   -- items before discount, as printed
alter table public.payment_requests add column if not exists discount_total  numeric(16,2);   -- total discount, as printed

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — Feature 20: per-user feature access
-- Admins choose which features each person can use. Enforced in the database,
-- not only in the menus. Run ONCE in the Supabase SQL Editor. Safe to re-run.
--
-- Feature keys: payment, trip, petty, siteops, approval, disburse, tracking, purchasing
-- permissions = NULL  ->  fall back to the role defaults (nothing changes for
-- existing users): admins get everything, employees get the request features.
-- ============================================================================

alter table public.profiles add column if not exists permissions text[];

-- ---------------------------------------------------------------------------
-- 1. Does the current user have a given feature?
-- ---------------------------------------------------------------------------
create or replace function public.has_perm(feature text)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select coalesce((
    select case
      when p.permissions is not null then feature = any(p.permissions)
      when p.role = 'admin'          then true
      else feature in ('payment', 'trip', 'petty', 'siteops')
    end
    from public.profiles p
    where p.id = auth.uid()
  ), false);
$$;

-- can review money: approve/reject, or record payments
create or replace function public.can_review()
returns boolean language sql security definer stable set search_path = public as $$
  select public.has_perm('approval') or public.has_perm('disburse');
$$;

-- can see everyone's records (any oversight feature)
create or replace function public.can_view_all()
returns boolean language sql security definer stable set search_path = public as $$
  select public.can_review() or public.has_perm('tracking') or public.has_perm('purchasing');
$$;

-- ---------------------------------------------------------------------------
-- 2. Money tables: see your own unless you have an oversight feature;
--    only reviewers may approve / reject / mark paid.
-- ---------------------------------------------------------------------------
drop policy if exists "pr_select_own_or_admin" on public.payment_requests;
create policy "pr_select_own_or_admin" on public.payment_requests
  for select to authenticated
  using (requester_id = auth.uid() or public.can_view_all());

drop policy if exists "pr_update_admin" on public.payment_requests;
create policy "pr_update_admin" on public.payment_requests
  for update to authenticated
  using (public.can_review()) with check (public.can_review());

drop policy if exists "tr_select_own_or_admin" on public.trip_reimbursements;
create policy "tr_select_own_or_admin" on public.trip_reimbursements
  for select to authenticated
  using (requester_id = auth.uid() or public.can_view_all());

drop policy if exists "tr_update_admin" on public.trip_reimbursements;
create policy "tr_update_admin" on public.trip_reimbursements
  for update to authenticated
  using (public.can_review()) with check (public.can_review());

drop policy if exists "pc_select_own_or_admin" on public.petty_cash_claims;
create policy "pc_select_own_or_admin" on public.petty_cash_claims
  for select to authenticated
  using (requester_id = auth.uid() or public.can_view_all());

drop policy if exists "pc_update_admin" on public.petty_cash_claims;
create policy "pc_update_admin" on public.petty_cash_claims
  for update to authenticated
  using (public.can_review()) with check (public.can_review());

drop policy if exists "pcl_select_own_or_admin" on public.petty_cash_lines;
create policy "pcl_select_own_or_admin" on public.petty_cash_lines
  for select to authenticated
  using (requester_id = auth.uid() or public.can_view_all());

-- ---------------------------------------------------------------------------
-- 3. Creating records requires the matching feature
-- ---------------------------------------------------------------------------
drop policy if exists "pr_insert_own" on public.payment_requests;
create policy "pr_insert_own" on public.payment_requests
  for insert to authenticated
  with check (requester_id = auth.uid() and public.has_perm('payment'));

drop policy if exists "tr_insert_own" on public.trip_reimbursements;
create policy "tr_insert_own" on public.trip_reimbursements
  for insert to authenticated
  with check (requester_id = auth.uid() and public.has_perm('trip'));

drop policy if exists "pc_insert_own" on public.petty_cash_claims;
create policy "pc_insert_own" on public.petty_cash_claims
  for insert to authenticated
  with check (requester_id = auth.uid() and public.has_perm('petty'));

drop policy if exists "ro_insert_own" on public.receiving_orders;
create policy "ro_insert_own" on public.receiving_orders
  for insert to authenticated
  with check (created_by = auth.uid() and public.has_perm('siteops'));

drop policy if exists "sm_insert_own" on public.store_movements;
create policy "sm_insert_own" on public.store_movements
  for insert to authenticated
  with check (created_by = auth.uid() and public.has_perm('siteops'));

-- ---------------------------------------------------------------------------
-- 4. Site ops: people with "tracking" can see every receiving / movement
-- ---------------------------------------------------------------------------
drop policy if exists "ro_select_participant" on public.receiving_orders;
create policy "ro_select_participant" on public.receiving_orders
  for select to authenticated
  using (created_by = auth.uid() or assigned_to = auth.uid()
         or public.is_admin() or public.has_perm('tracking'));

drop policy if exists "sm_select_participant" on public.store_movements;
create policy "sm_select_participant" on public.store_movements
  for select to authenticated
  using (created_by = auth.uid() or assigned_to = auth.uid()
         or public.is_admin() or public.has_perm('tracking'));

-- ---------------------------------------------------------------------------
-- 5. Admins manage other people's profiles (role + permissions)
-- ---------------------------------------------------------------------------
drop policy if exists "profiles_update_admin" on public.profiles;
create policy "profiles_update_admin" on public.profiles
  for update to authenticated
  using (public.is_admin()) with check (public.is_admin());

drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select to authenticated
  using (id = auth.uid() or public.is_admin() or public.can_view_all());

-- ---------------------------------------------------------------------------
-- 6. Payment batches follow the same reviewer rule
-- ---------------------------------------------------------------------------
drop policy if exists "batch_insert_admin" on public.disbursement_batches;
create policy "batch_insert_admin" on public.disbursement_batches
  for insert to authenticated with check (public.can_review());

drop policy if exists "batch_select_admin" on public.disbursement_batches;
create policy "batch_select_admin" on public.disbursement_batches
  for select to authenticated using (public.can_view_all());

-- ============================================================================
-- DONE. Everyone keeps working exactly as before until you set permissions
-- for someone in Admin -> Users & Access.
-- ============================================================================

-- ============================================================================
-- GS Operational System — new sign-ups start with NO access
-- An admin must grant features in Admin -> Users & Access before the person
-- can do anything. Existing users are untouched.
-- Run ONCE in the Supabase SQL Editor, AFTER setup-permissions.sql.
-- ============================================================================

-- New profiles get an EMPTY permission list (not NULL, which means "role default").
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, role, permissions)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    'employee',
    '{}'::text[]          -- no access at all until an admin grants it
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Anyone who signed up but has never been given access (empty list) stays
-- locked out. To grant access, use Admin -> Users & Access in the app, or:
--
--   -- give someone the standard employee features:
--   update public.profiles
--   set permissions = array['payment','trip','petty','siteops']
--   where email = 'someone@golfsolutionsid.com';
--
--   -- make someone a full admin (NULL = "everything for their role"):
--   update public.profiles
--   set role = 'admin', permissions = null
--   where email = 'someone@golfsolutionsid.com';
-- ---------------------------------------------------------------------------

-- Safety net: make sure the current admins can still get in.
-- (Only touches admins who were left on the old "role default" behaviour.)
update public.profiles
set permissions = null
where role = 'admin' and permissions = '{}'::text[];

select email, role,
       case when permissions is null then 'role default (all for admin)'
            when array_length(permissions, 1) is null then 'NO ACCESS - awaiting approval'
            else array_to_string(permissions, ', ') end as access
from public.profiles
order by role desc, email;

-- ============================================================================
-- GS Operational System — dismiss purchases that need no goods receiving
-- Service invoices (consultancy, courier, commission) never get received, so
-- they can be removed from the "ready to receive" list without touching the
-- payment record itself.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

create table if not exists public.receiving_dismissals (
  payment_request_id uuid primary key references public.payment_requests (id) on delete cascade,
  dismissed_by       uuid not null default auth.uid() references auth.users (id),
  dismissed_at       timestamptz not null default now(),
  reason             text
);

alter table public.receiving_dismissals enable row level security;

-- anyone who works in site operations can see / manage the list
drop policy if exists "rd_select" on public.receiving_dismissals;
create policy "rd_select" on public.receiving_dismissals
  for select to authenticated
  using (public.has_perm('siteops') or public.is_admin() or public.has_perm('tracking'));

drop policy if exists "rd_insert" on public.receiving_dismissals;
create policy "rd_insert" on public.receiving_dismissals
  for insert to authenticated
  with check (dismissed_by = auth.uid() and (public.has_perm('siteops') or public.is_admin()));

drop policy if exists "rd_delete" on public.receiving_dismissals;
create policy "rd_delete" on public.receiving_dismissals
  for delete to authenticated
  using (public.has_perm('siteops') or public.is_admin());

-- ============================================================================
-- DONE. Dismissing is reversible — the app can restore a hidden purchase.
-- ============================================================================

-- ============================================================================
-- GS Operational System — trip claims split into mileage + additional fees
-- trip_value      = total_km x the rate for the vehicle (1,500 motorcycle /
--                   3,000 car per km, set in config.js)
-- additional_fees = parking, toll and similar out-of-pocket costs
-- amount          = trip_value + additional_fees (the total claimed)
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.trip_reimbursements add column if not exists trip_value      numeric(14,2);
alter table public.trip_reimbursements add column if not exists additional_fees numeric(14,2);

-- ============================================================================
-- DONE. Existing claims keep their single "amount"; new ones store the split.
-- ============================================================================


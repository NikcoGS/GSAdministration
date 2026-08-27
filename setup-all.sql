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

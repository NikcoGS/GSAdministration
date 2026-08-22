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

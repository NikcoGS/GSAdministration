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

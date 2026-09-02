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

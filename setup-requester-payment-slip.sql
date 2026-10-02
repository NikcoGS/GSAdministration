-- ============================================================================
-- GS Operational System — the requester can see that they were paid
--
-- Payment records and transfer slips were readable by reviewers only, so the
-- person waiting on the money had no way to see the proof it was sent. This
-- lets someone read a payment — and open its slip — when it settled one of
-- THEIR OWN requests. Nobody gains sight of anyone else's payments.
--
-- Also lets non-admin reviewers (approval / disburse access) upload a slip;
-- that was still limited to the admin role from before per-feature access.
--
-- Run ONCE in the Supabase SQL Editor, AFTER setup-partial-payments.sql.
-- Safe to re-run.
-- ============================================================================

-- may the signed-in user see this payment batch?
create or replace function public.can_see_batch(b uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select public.can_view_all()
      or exists (select 1 from public.payment_requests p
                 where p.batch_id = b and p.requester_id = auth.uid())
      or exists (select 1 from public.payment_allocations a
                 join public.payment_requests p on p.id = a.payment_request_id
                 where a.batch_id = b and p.requester_id = auth.uid())
      or exists (select 1 from public.trip_reimbursements t
                 where t.batch_id = b and t.requester_id = auth.uid())
      or exists (select 1 from public.petty_cash_claims c
                 where c.batch_id = b and c.requester_id = auth.uid());
$$;

drop policy if exists "batch_select_admin" on public.disbursement_batches;
create policy "batch_select_admin" on public.disbursement_batches
  for select to authenticated
  using (public.can_see_batch(id));

-- may the signed-in user open this slip file?
create or replace function public.can_see_proof(path text)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (select 1 from public.disbursement_batches b
                 where b.proof_path = path and public.can_see_batch(b.id));
$$;

drop policy if exists "proof_read_admin" on storage.objects;
create policy "proof_read_admin" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'payment-proofs'
    and (public.is_admin() or public.can_view_all() or public.can_see_proof(name))
  );

drop policy if exists "proof_upload_admin" on storage.objects;
create policy "proof_upload_admin" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'payment-proofs'
    and (public.is_admin() or public.can_review())
    and (storage.foldername(name))[1] = auth.uid()::text
  );

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. A requester opening one of their paid requests now sees the payment
-- date, reference and a "View payment slip" button.
-- ============================================================================

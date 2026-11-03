-- ============================================================================
-- GS Operational System — Feature 40: several files per attachment
-- Every picker (expense invoice, supplier invoice/PO, trip map screenshots and
-- receipts, petty cash line photos, receiving PO, payment slip) now takes many
-- files. The first file stays in the original single-path column, so rows
-- saved earlier and older code keep working; the whole list lives in a
-- *_paths array beside it.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests     add column if not exists invoice_paths        text[];
alter table public.trip_reimbursements  add column if not exists map_screenshot_paths text[];
alter table public.trip_reimbursements  add column if not exists receipt_paths        text[];
alter table public.petty_cash_lines     add column if not exists picture_paths        text[];
alter table public.receiving_orders     add column if not exists attachment_paths     text[];
alter table public.disbursement_batches add column if not exists proof_paths          text[];

-- A requester may open every slip of the transfer that paid them, not only
-- the first one (the storage policy on payment-proofs calls this per file).
create or replace function public.can_see_proof(path text)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.disbursement_batches b
    where (b.proof_path = path or path = any(coalesce(b.proof_paths, '{}'::text[])))
      and public.can_see_batch(b.id)
  );
$$;

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Reload the web app — every attachment box now accepts several files,
-- and the detail views list each one.
-- ============================================================================

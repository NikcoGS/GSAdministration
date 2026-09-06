-- ============================================================================
-- GS Operational System — allow zero-value settlements
-- Some approved invoices come to nothing (fully discounted, cancelled charge,
-- goods sent free of charge). They still need to be closed off, otherwise they
-- sit in Disburse forever. Allow an allocation of 0 so the settlement is still
-- recorded — with its date, who did it and any note.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_allocations drop constraint if exists payment_allocations_amount_check;
alter table public.payment_allocations add  constraint payment_allocations_amount_check check (amount >= 0);

-- Payment batches may also total zero.
alter table public.disbursement_batches drop constraint if exists disbursement_batches_amount_check;

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. A zero payment marks a zero-value invoice as settled; it does not
-- close an invoice that still has a real balance outstanding.
-- ============================================================================

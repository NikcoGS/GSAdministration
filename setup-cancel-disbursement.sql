-- ============================================================================
-- GS Operational System — cancelling a disbursement
--
-- An approved item sometimes must not be paid after all: the invoice was
-- voided, the supplier credited it, it was a duplicate, or it was settled
-- another way. Rejecting it would misrecord a decision that was taken after
-- approval, so it gets its own status, with who cancelled it, when and why.
--
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests    drop constraint if exists payment_requests_status_check;
alter table public.payment_requests    add  constraint payment_requests_status_check
  check (status in ('pending', 'approved', 'rejected', 'cancelled'));

alter table public.trip_reimbursements drop constraint if exists trip_reimbursements_status_check;
alter table public.trip_reimbursements add  constraint trip_reimbursements_status_check
  check (status in ('pending', 'approved', 'rejected', 'cancelled'));

alter table public.petty_cash_claims   drop constraint if exists petty_cash_claims_status_check;
alter table public.petty_cash_claims   add  constraint petty_cash_claims_status_check
  check (status in ('pending', 'approved', 'rejected', 'cancelled'));

alter table public.payment_requests    add column if not exists cancelled_by  uuid references auth.users (id);
alter table public.payment_requests    add column if not exists cancelled_at  timestamptz;
alter table public.payment_requests    add column if not exists cancel_reason text;
alter table public.trip_reimbursements add column if not exists cancelled_by  uuid references auth.users (id);
alter table public.trip_reimbursements add column if not exists cancelled_at  timestamptz;
alter table public.trip_reimbursements add column if not exists cancel_reason text;
alter table public.petty_cash_claims   add column if not exists cancelled_by  uuid references auth.users (id);
alter table public.petty_cash_claims   add column if not exists cancelled_at  timestamptz;
alter table public.petty_cash_claims   add column if not exists cancel_reason text;

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Reviewers get a "✕ Cancel" button on every item in Disburse, and a
-- cancelled item can be restored from its detail popup.
-- ============================================================================

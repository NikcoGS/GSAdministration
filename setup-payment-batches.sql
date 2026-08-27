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

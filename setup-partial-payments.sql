-- ============================================================================
-- GS Operational System — multiple payments per invoice (deposits, instalments)
-- and one transfer covering several invoices.
--
-- A payment batch = one real bank transfer.
-- An allocation   = how much of that transfer was applied to a given invoice.
-- An invoice is fully paid when its allocations cover its amount.
--
-- Run ONCE in the Supabase SQL Editor, AFTER setup-payment-input.sql.
-- Safe to re-run. Existing fully-paid records are backfilled automatically.
-- ============================================================================

create table if not exists public.payment_allocations (
  id                 uuid primary key default gen_random_uuid(),
  batch_id           uuid not null references public.disbursement_batches (id) on delete cascade,
  payment_request_id uuid not null references public.payment_requests (id) on delete cascade,
  amount             numeric(16,2) not null check (amount > 0),
  created_at         timestamptz not null default now()
);

create index if not exists alloc_request_idx on public.payment_allocations (payment_request_id);
create index if not exists alloc_batch_idx   on public.payment_allocations (batch_id);

-- running total of what has been paid against each invoice
alter table public.payment_requests add column if not exists paid_amount numeric(16,2) not null default 0;

alter table public.payment_allocations enable row level security;

drop policy if exists "alloc_select" on public.payment_allocations;
create policy "alloc_select" on public.payment_allocations
  for select to authenticated
  using (public.can_view_all() or exists (
    select 1 from public.payment_requests p
    where p.id = payment_request_id and p.requester_id = auth.uid()));

drop policy if exists "alloc_insert" on public.payment_allocations;
create policy "alloc_insert" on public.payment_allocations
  for insert to authenticated with check (public.can_review());

drop policy if exists "alloc_delete" on public.payment_allocations;
create policy "alloc_delete" on public.payment_allocations
  for delete to authenticated using (public.can_review());

-- ---------------------------------------------------------------------------
-- Keep paid_amount / paid_at in step with the allocations.
-- paid_at is set only when the invoice is FULLY covered, so partially paid
-- invoices stay visible in Disburse with their remaining balance.
-- ---------------------------------------------------------------------------
create or replace function public.sync_payment_progress()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request uuid;
  v_total   numeric(16,2);
  v_amount  numeric(16,2);
begin
  v_request := coalesce(new.payment_request_id, old.payment_request_id);

  select coalesce(sum(amount), 0) into v_total
  from public.payment_allocations where payment_request_id = v_request;

  select amount into v_amount from public.payment_requests where id = v_request;

  update public.payment_requests
  set paid_amount = v_total,
      -- fully paid (within one currency unit of rounding) -> stamp paid_at
      paid_at = case
        when v_amount is not null and v_total >= v_amount - 0.01 then coalesce(paid_at, now())
        else null
      end
  where id = v_request;

  return null;
end;
$$;

drop trigger if exists trg_sync_payment_progress on public.payment_allocations;
create trigger trg_sync_payment_progress
  after insert or update or delete on public.payment_allocations
  for each row execute function public.sync_payment_progress();

-- ---------------------------------------------------------------------------
-- Backfill: every invoice already marked paid gets one allocation for its full
-- amount, against the batch that settled it, so history stays consistent.
-- ---------------------------------------------------------------------------
insert into public.payment_allocations (batch_id, payment_request_id, amount)
select p.batch_id, p.id, p.amount
from public.payment_requests p
where p.paid_at is not null
  and p.batch_id is not null
  and p.amount is not null
  and p.amount > 0
  and not exists (
    select 1 from public.payment_allocations a where a.payment_request_id = p.id
  );

-- anything paid without a batch (older data) still shows as settled
update public.payment_requests
set paid_amount = amount
where paid_at is not null and paid_amount = 0 and amount is not null;

notify pgrst, 'reload schema';

select count(*) filter (where paid_at is not null)                     as fully_paid,
       count(*) filter (where paid_amount > 0 and paid_at is null)     as partially_paid,
       count(*) filter (where status = 'approved' and paid_amount = 0) as not_started
from public.payment_requests;

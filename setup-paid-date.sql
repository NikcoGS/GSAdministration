-- ============================================================================
-- GS Operational System — an invoice is paid on the day the money moved
--
-- paid_at was being stamped with now() by the allocation trigger, i.e. the
-- moment somebody keyed the payment in. For a transfer entered a week later —
-- or for the whole imported history — that is the wrong date, and it is the
-- date the purchasing book, the exports and Odoo all read.
--
-- From now on paid_at is derived from the transfer itself: the paid_date on
-- the payment batch that settled the invoice. Existing rows are corrected.
--
-- Run ONCE in the Supabase SQL Editor, AFTER setup-partial-payments.sql.
-- Safe to re-run.
-- ============================================================================

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
  v_paid_on timestamptz;
begin
  v_request := coalesce(new.payment_request_id, old.payment_request_id);

  select coalesce(sum(amount), 0) into v_total
  from public.payment_allocations where payment_request_id = v_request;

  select amount into v_amount from public.payment_requests where id = v_request;

  -- the day the money actually moved. An invoice settled in instalments is
  -- paid on the date of the LAST transfer that cleared it. Midday, so the
  -- stored timestamp cannot slip to the day before in another timezone.
  select max(coalesce((b.paid_date + time '12:00')::timestamptz, a.created_at))
    into v_paid_on
    from public.payment_allocations a
    left join public.disbursement_batches b on b.id = a.batch_id
   where a.payment_request_id = v_request;

  update public.payment_requests
  set paid_amount = v_total,
      -- fully paid (within one currency unit of rounding) -> stamp paid_at.
      -- Recomputed rather than kept, so correcting a transfer's date corrects
      -- the invoices it settled.
      paid_at = case
        when v_amount is not null and v_total >= v_amount - 0.01 then coalesce(v_paid_on, now())
        else null
      end
  where id = v_request;

  return null;
end;
$$;

-- ---------------------------------------------------------------------------
-- Correct the history: every settled item takes the date of the transfer that
-- settled it. Rows with no batch, or a batch with no date, are left alone.
-- ---------------------------------------------------------------------------
update public.payment_requests p
set paid_at = x.paid_on
from (
  select a.payment_request_id as id,
         max((b.paid_date + time '12:00')::timestamptz) as paid_on
  from public.payment_allocations a
  join public.disbursement_batches b on b.id = a.batch_id
  where b.paid_date is not null
  group by a.payment_request_id
) x
where p.id = x.id
  and p.paid_at is not null
  and p.paid_at::date is distinct from x.paid_on::date;

-- invoices settled before allocations existed, linked only by batch_id
update public.payment_requests p
set paid_at = (b.paid_date + time '12:00')::timestamptz
from public.disbursement_batches b
where b.id = p.batch_id
  and b.paid_date is not null
  and p.paid_at is not null
  and p.paid_at::date is distinct from b.paid_date;

update public.trip_reimbursements t
set paid_at = (b.paid_date + time '12:00')::timestamptz
from public.disbursement_batches b
where b.id = t.batch_id
  and b.paid_date is not null
  and t.paid_at is not null
  and t.paid_at::date is distinct from b.paid_date;

update public.petty_cash_claims c
set paid_at = (b.paid_date + time '12:00')::timestamptz
from public.disbursement_batches b
where b.id = c.batch_id
  and b.paid_date is not null
  and c.paid_at is not null
  and c.paid_at::date is distinct from b.paid_date;

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Check the result — every settled invoice should now agree with its
-- transfer. Anything listed here has no dated transfer behind it.
-- ============================================================================
select p.ref_number, p.payee_name, p.paid_at::date as paid_on, b.paid_date as transfer_date
from public.payment_requests p
left join public.disbursement_batches b on b.id = p.batch_id
where p.paid_at is not null
  and (b.paid_date is null or p.paid_at::date is distinct from b.paid_date)
order by p.paid_at desc;

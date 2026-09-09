-- ============================================================================
-- GS Operational System — correcting a payment that was keyed in wrong
--
-- The payment modal defaults to today, but a transfer is often entered days
-- after it was made. Until now there was no way to fix that date, and the date
-- on the transfer is the date every item it settled counts as paid.
--
-- This lets reviewers edit a payment record, and makes the settled items
-- follow it automatically — the paid date stays derived from the transfer,
-- never typed twice.
--
-- Run ONCE in the Supabase SQL Editor, AFTER setup-paid-date.sql.
-- Safe to re-run.
-- ============================================================================

-- reviewers may correct a payment they can already see
drop policy if exists "batch_update_admin" on public.disbursement_batches;
create policy "batch_update_admin" on public.disbursement_batches
  for update to authenticated
  using (public.can_review())
  with check (public.can_review());

-- ---------------------------------------------------------------------------
-- Re-date everything a corrected transfer settled.
-- Invoices are dated by the LAST transfer that cleared them, so an invoice
-- paid in instalments is recomputed across all of its transfers, not just
-- the one being edited.
-- ---------------------------------------------------------------------------
create or replace function public.resync_batch_dates()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.paid_date is distinct from old.paid_date then
    update public.payment_requests p
    set paid_at = x.paid_on
    from (
      select a.payment_request_id as id,
             max(coalesce((b.paid_date + time '12:00')::timestamptz, a.created_at)) as paid_on
      from public.payment_allocations a
      left join public.disbursement_batches b on b.id = a.batch_id
      where a.payment_request_id in (
        select payment_request_id from public.payment_allocations where batch_id = new.id
      )
      group by a.payment_request_id
    ) x
    where p.id = x.id
      and p.paid_at is not null;

    -- items settled before allocations existed, linked only by batch_id
    if new.paid_date is not null then
      update public.payment_requests p
      set paid_at = (new.paid_date + time '12:00')::timestamptz
      where p.batch_id = new.id
        and p.paid_at is not null
        and not exists (select 1 from public.payment_allocations a where a.payment_request_id = p.id);

      update public.trip_reimbursements t
      set paid_at = (new.paid_date + time '12:00')::timestamptz
      where t.batch_id = new.id and t.paid_at is not null;

      update public.petty_cash_claims c
      set paid_at = (new.paid_date + time '12:00')::timestamptz
      where c.batch_id = new.id and c.paid_at is not null;
    end if;
  end if;
  return null;
end;
$$;

drop trigger if exists trg_resync_batch_dates on public.disbursement_batches;
create trigger trg_resync_batch_dates
  after update on public.disbursement_batches
  for each row execute function public.resync_batch_dates();

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Open any paid invoice and use "Correct payment" in its payment
-- history to fix the date, amount, fees or reference of the transfer.
-- ============================================================================

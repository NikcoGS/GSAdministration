-- ============================================================================
-- GS Operational System — landed cost on invoices entered in the app
--
-- Landed cost is the unit price once the invoice's charges (PPN, biaya kirim,
-- handling) are spread over the lines, prorated by value. It came across on
-- the 102 invoices imported from the purchasing spreadsheet, but nothing in
-- the app ever calculated it, so every invoice entered since has gone in
-- without one — whether it was paid or not.
--
-- The app now works it out on save. This fills in the ones already entered.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

with net as (
  select p.id,
         coalesce(sum(coalesce((i->>'qty')::numeric, 1) * coalesce((i->>'unit_price')::numeric, 0)), 0) as items_net
  from public.payment_requests p,
       lateral jsonb_array_elements(p.items) i
  where p.items is not null and jsonb_typeof(p.items) = 'array'
  group by p.id
),
extra as (
  select p.id,
         coalesce(sum(coalesce((c->>'amount')::numeric, 0)), 0) as charges_total
  from public.payment_requests p
  left join lateral jsonb_array_elements(coalesce(p.charges, '[]'::jsonb)) c on true
  group by p.id
)
update public.payment_requests p
set items = (
  select jsonb_agg(
           i || jsonb_build_object(
             'landed_unit_price',
             round(coalesce((i->>'unit_price')::numeric, 0)
                   * (1 + extra.charges_total / net.items_net), 6)
           )
           order by ord
         )
  from jsonb_array_elements(p.items) with ordinality as t(i, ord)
)
from net, extra
where net.id = p.id
  and extra.id = p.id
  and net.items_net > 0
  -- only invoices no line of which has been costed yet
  and not exists (
    select 1 from jsonb_array_elements(p.items) x where x ? 'landed_unit_price'
  );

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Anything still listed here has item lines but no landed cost — an
-- invoice whose lines total zero, which cannot be prorated.
-- ============================================================================
select ref_number, payee_name, invoice_date, amount, currency
from public.payment_requests
where items is not null
  and jsonb_typeof(items) = 'array'
  and jsonb_array_length(items) > 0
  and not exists (select 1 from jsonb_array_elements(items) x where x ? 'landed_unit_price')
order by invoice_date desc nulls last;

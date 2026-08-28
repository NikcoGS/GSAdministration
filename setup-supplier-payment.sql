-- ============================================================================
-- GS Operational System — Feature 7: Supplier vs Expense payment requests
-- Run ONCE in the Supabase SQL Editor. Safe to run more than once.
-- ============================================================================

alter table public.payment_requests add column if not exists request_type text not null default 'expense';
alter table public.payment_requests drop constraint if exists payment_requests_request_type_check;
alter table public.payment_requests add constraint payment_requests_request_type_check
  check (request_type in ('expense', 'supplier'));

alter table public.payment_requests add column if not exists ref_number    text;            -- PO / invoice number
alter table public.payment_requests add column if not exists items         jsonb;           -- [{item_name, qty, unit, unit_price, idr_estimate}]
alter table public.payment_requests add column if not exists fx_rate       numeric(16,6);   -- foreign currency -> IDR rate used
alter table public.payment_requests add column if not exists idr_estimate  numeric(16,2);   -- estimated total in IDR

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

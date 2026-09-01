-- ============================================================================
-- GS Operational System — Feature 15: fields for the GS Purchasing compilation
-- Adds the few invoice facts the compilation spreadsheet needs that the app
-- did not store yet. Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests add column if not exists invoice_date    date;
alter table public.payment_requests add column if not exists buyer           text;            -- which entity bought (PT SGI, CV TKO, ...)
alter table public.payment_requests add column if not exists payment_terms   text;            -- e.g. C.O.D, Bank Transfer, 30 days
alter table public.payment_requests add column if not exists gross_subtotal  numeric(16,2);   -- items before discount, as printed
alter table public.payment_requests add column if not exists discount_total  numeric(16,2);   -- total discount, as printed

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

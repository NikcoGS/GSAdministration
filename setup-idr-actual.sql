-- ============================================================================
-- GS Operational System — Feature 10: actual IDR repricing after payment
-- When a foreign-currency invoice is paid, the items are repriced in IDR
-- using the actual paid value (excl. bank fees); foreign stays as info.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests add column if not exists idr_actual     numeric(16,2);  -- actual IDR paid, excl. fees
alter table public.payment_requests add column if not exists fx_rate_actual numeric(16,6);  -- realized rate used for repricing

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

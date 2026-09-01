-- ============================================================================
-- GS Operational System — Feature 11: invoice charges (biaya) on supplier payments
-- PPN, biaya kirim, handling etc. as named charges separate from item lines.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.payment_requests add column if not exists charges jsonb;  -- [{name, amount, idr_amount?}]

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

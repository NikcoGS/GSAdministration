-- ============================================================================
-- GS Operational System — Feature 8: link receiving to approved purchases
-- Run ONCE in the Supabase SQL Editor. Safe to run more than once.
-- ============================================================================

alter table public.receiving_orders
  add column if not exists payment_request_id uuid references public.payment_requests (id);

create index if not exists recv_orders_pr_idx on public.receiving_orders (payment_request_id);

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

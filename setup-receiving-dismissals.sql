-- ============================================================================
-- GS Operational System — dismiss purchases that need no goods receiving
-- Service invoices (consultancy, courier, commission) never get received, so
-- they can be removed from the "ready to receive" list without touching the
-- payment record itself.
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

create table if not exists public.receiving_dismissals (
  payment_request_id uuid primary key references public.payment_requests (id) on delete cascade,
  dismissed_by       uuid not null default auth.uid() references auth.users (id),
  dismissed_at       timestamptz not null default now(),
  reason             text
);

alter table public.receiving_dismissals enable row level security;

-- anyone who works in site operations can see / manage the list
drop policy if exists "rd_select" on public.receiving_dismissals;
create policy "rd_select" on public.receiving_dismissals
  for select to authenticated
  using (public.has_perm('siteops') or public.is_admin() or public.has_perm('tracking'));

drop policy if exists "rd_insert" on public.receiving_dismissals;
create policy "rd_insert" on public.receiving_dismissals
  for insert to authenticated
  with check (dismissed_by = auth.uid() and (public.has_perm('siteops') or public.is_admin()));

drop policy if exists "rd_delete" on public.receiving_dismissals;
create policy "rd_delete" on public.receiving_dismissals
  for delete to authenticated
  using (public.has_perm('siteops') or public.is_admin());

-- ============================================================================
-- DONE. Dismissing is reversible — the app can restore a hidden purchase.
-- ============================================================================

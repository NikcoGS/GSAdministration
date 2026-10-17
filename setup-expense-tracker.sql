-- ============================================================================
-- GS Operational System — Expense Tracker access
--
-- The Expense Tracker (trip reimbursements, petty cash, expense payments)
-- is gated by a new feature, "expenses". Admins have it already. For anyone
-- granted the feature on its own, reading everyone's claims must be allowed
-- by the database too — so "see everything" now includes that feature.
--
-- Run ONCE in the Supabase SQL Editor, AFTER setup-permissions.sql.
-- Safe to re-run.
-- ============================================================================

create or replace function public.can_view_all()
returns boolean language sql security definer stable set search_path = public as $$
  select public.can_review()
      or public.has_perm('tracking')
      or public.has_perm('purchasing')
      or public.has_perm('expenses');
$$;

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Grant "Expense tracker" to a person in Users & Access and they can
-- open it.
-- ============================================================================

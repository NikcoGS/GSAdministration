-- ============================================================================
-- GS Operational System — Feature 4: Disbursement + user bank details
-- Run this ONCE in the Supabase SQL Editor, AFTER setup.sql (and the others).
-- Safe to run more than once.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. User bank account (rekening) on the profile
-- ---------------------------------------------------------------------------
alter table public.profiles add column if not exists bank_name           text;
alter table public.profiles add column if not exists bank_account_number text;   -- rekening
alter table public.profiles add column if not exists bank_account_name    text;   -- account holder

-- ---------------------------------------------------------------------------
-- 2. "Paid" tracking on every reimbursable type
--    An item is "to disburse" when status = 'approved' AND paid_at IS NULL.
-- ---------------------------------------------------------------------------
alter table public.payment_requests    add column if not exists paid_at timestamptz;
alter table public.payment_requests    add column if not exists paid_by uuid references auth.users (id);
alter table public.trip_reimbursements add column if not exists paid_at timestamptz;
alter table public.trip_reimbursements add column if not exists paid_by uuid references auth.users (id);
alter table public.petty_cash_claims   add column if not exists paid_at timestamptz;
alter table public.petty_cash_claims   add column if not exists paid_by uuid references auth.users (id);

-- ---------------------------------------------------------------------------
-- 3. Security fix: stop a user from changing their own role via profile edit.
--    (Self-service settings now let users update their profile; role must
--     only ever be changed by an admin.)
-- ---------------------------------------------------------------------------
create or replace function public.protect_profile_role()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.role is distinct from old.role and not public.is_admin() then
    new.role := old.role;   -- silently ignore role changes by non-admins
  end if;
  return new;
end;
$$;

drop trigger if exists trg_protect_profile_role on public.profiles;
create trigger trg_protect_profile_role
  before update on public.profiles
  for each row execute function public.protect_profile_role();

-- ============================================================================
-- DONE. Reload the web app:
--   * Everyone gets "My Settings" to save their bank account (rekening).
--   * Admins get a "Disburse" menu listing approved & unpaid items by user.
-- ============================================================================

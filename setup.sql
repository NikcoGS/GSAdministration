-- ============================================================================
-- GS Operational System — Database setup
-- Run this ONCE in the Supabase SQL Editor (Dashboard -> SQL Editor -> New query)
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. PROFILES table (one row per user, holds role: employee / admin)
-- ---------------------------------------------------------------------------
create table if not exists public.profiles (
  id         uuid primary key references auth.users (id) on delete cascade,
  email      text,
  full_name  text,
  role       text not null default 'employee' check (role in ('employee', 'admin')),
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 2. Helper: is_admin() — SECURITY DEFINER so it can read profiles without
--    triggering row-level-security recursion.
-- ---------------------------------------------------------------------------
create or replace function public.is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- ---------------------------------------------------------------------------
-- 3. Auto-create a profile whenever a new auth user signs up
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    'employee'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- 4. PAYMENT REQUESTS table
-- ---------------------------------------------------------------------------
create table if not exists public.payment_requests (
  id                  uuid primary key default gen_random_uuid(),
  requester_id        uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title               text not null,
  payee_name          text not null,
  amount              numeric(14,2) not null check (amount >= 0),
  currency            text not null default 'IDR',
  bank_name           text,
  bank_account_name   text,
  bank_account_number text,
  transaction_date    date,
  description         text,
  invoice_path        text,               -- path in the 'invoices' storage bucket
  status              text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reviewed_by         uuid references auth.users (id),
  reviewed_at         timestamptz,
  review_note         text,
  created_at          timestamptz not null default now()
);

create index if not exists payment_requests_requester_idx on public.payment_requests (requester_id);
create index if not exists payment_requests_status_idx    on public.payment_requests (status);

-- ---------------------------------------------------------------------------
-- 5. Row Level Security
-- ---------------------------------------------------------------------------
alter table public.profiles         enable row level security;
alter table public.payment_requests enable row level security;

-- ---- profiles policies ----
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select to authenticated
  using (id = auth.uid() or public.is_admin());

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (id = auth.uid());

-- safety net so a user can create their own profile row if the trigger didn't
drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
  for insert to authenticated
  with check (id = auth.uid());

-- ---- payment_requests policies ----
-- employees create their own; admins can create too (requester_id defaults to auth.uid())
drop policy if exists "pr_insert_own" on public.payment_requests;
create policy "pr_insert_own" on public.payment_requests
  for insert to authenticated
  with check (requester_id = auth.uid());

-- see your own; admins see everything
drop policy if exists "pr_select_own_or_admin" on public.payment_requests;
create policy "pr_select_own_or_admin" on public.payment_requests
  for select to authenticated
  using (requester_id = auth.uid() or public.is_admin());

-- only admins can approve / reject (update)
drop policy if exists "pr_update_admin" on public.payment_requests;
create policy "pr_update_admin" on public.payment_requests
  for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- requester may delete their own request while still pending
drop policy if exists "pr_delete_own_pending" on public.payment_requests;
create policy "pr_delete_own_pending" on public.payment_requests
  for delete to authenticated
  using (requester_id = auth.uid() and status = 'pending');

-- ---------------------------------------------------------------------------
-- 6. STORAGE bucket for invoices/bills (private)
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('invoices', 'invoices', false)
on conflict (id) do nothing;

-- upload only into your own folder:  invoices/<your-user-id>/<file>
drop policy if exists "invoice_upload_own" on storage.objects;
create policy "invoice_upload_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'invoices'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- read your own files, or any if you are an admin
drop policy if exists "invoice_read_own_or_admin" on storage.objects;
create policy "invoice_read_own_or_admin" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'invoices'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin())
  );

-- ============================================================================
-- DONE. After running this:
--   1) Register your account in the web app (Sign up).
--   2) Then promote yourself to admin by running the line below with your email:
--
--        update public.profiles set role = 'admin' where email = 'nikco@golfsolutionsid.com';
--
-- ============================================================================

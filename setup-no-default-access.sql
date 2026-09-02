-- ============================================================================
-- GS Operational System — new sign-ups start with NO access
-- An admin must grant features in Admin -> Users & Access before the person
-- can do anything. Existing users are untouched.
-- Run ONCE in the Supabase SQL Editor, AFTER setup-permissions.sql.
-- ============================================================================

-- New profiles get an EMPTY permission list (not NULL, which means "role default").
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, role, permissions)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    'employee',
    '{}'::text[]          -- no access at all until an admin grants it
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
-- Anyone who signed up but has never been given access (empty list) stays
-- locked out. To grant access, use Admin -> Users & Access in the app, or:
--
--   -- give someone the standard employee features:
--   update public.profiles
--   set permissions = array['payment','trip','petty','siteops']
--   where email = 'someone@golfsolutionsid.com';
--
--   -- make someone a full admin (NULL = "everything for their role"):
--   update public.profiles
--   set role = 'admin', permissions = null
--   where email = 'someone@golfsolutionsid.com';
-- ---------------------------------------------------------------------------

-- Safety net: make sure the current admins can still get in.
-- (Only touches admins who were left on the old "role default" behaviour.)
update public.profiles
set permissions = null
where role = 'admin' and permissions = '{}'::text[];

select email, role,
       case when permissions is null then 'role default (all for admin)'
            when array_length(permissions, 1) is null then 'NO ACCESS - awaiting approval'
            else array_to_string(permissions, ', ') end as access
from public.profiles
order by role desc, email;

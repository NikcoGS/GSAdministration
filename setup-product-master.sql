-- ============================================================================
-- GS Operational System — product master for the Name Finder
--
-- The Golf Solutions product list (name, SKU, brand, item category) as
-- exported from Odoo. The Name Finder matches supplier descriptions against
-- it and proposes names and SKUs in the same convention for anything new.
-- Refresh it from the Name Finder's "Update master" upload whenever the
-- Odoo list changes.
--
-- Run ONCE in the Supabase SQL Editor, then run seed-product-master.sql.
-- Safe to re-run.
-- ============================================================================

create table if not exists public.product_master (
  sku            text primary key,
  name           text not null,
  brand          text,
  item_category  text,
  cost           numeric(16,2),
  weight_g       numeric(10,2),
  updated_at     timestamptz not null default now(),
  updated_by     uuid references auth.users (id)
);

create index if not exists product_master_brand_idx on public.product_master (brand);
create index if not exists product_master_cat_idx   on public.product_master (item_category);

alter table public.product_master enable row level security;

-- product names are internal reference data: anyone signed in may read them
drop policy if exists "pm_select" on public.product_master;
create policy "pm_select" on public.product_master
  for select to authenticated using (true);

-- only the Name Finder's keepers change the list
drop policy if exists "pm_write" on public.product_master;
create policy "pm_write" on public.product_master
  for all to authenticated
  using (public.is_admin() or public.has_perm('names'))
  with check (public.is_admin() or public.has_perm('names'));

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Now run seed-product-master.sql to load the current list.
-- ============================================================================

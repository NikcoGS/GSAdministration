-- ============================================================================
-- GS Operational System — Feature 5: Item Receiving + Store Movement
-- Run this ONCE in the Supabase SQL Editor, AFTER setup.sql.
-- Safe to run more than once.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. User directory view — lets any signed-in user see names/emails so they
--    can assign tasks (bank details & roles stay private in profiles).
-- ---------------------------------------------------------------------------
create or replace view public.user_directory as
  select id, full_name, email from public.profiles;

revoke all on public.user_directory from anon;
grant select on public.user_directory to authenticated;

-- ---------------------------------------------------------------------------
-- 2. ITEM RECEIVING
-- ---------------------------------------------------------------------------
create table if not exists public.receiving_orders (
  id              uuid primary key default gen_random_uuid(),
  created_by      uuid not null default auth.uid() references auth.users (id) on delete cascade,
  supplier        text,
  ref_number      text,                       -- PO / supplier invoice number
  location        text not null default 'Manhattan' check (location in ('Manhattan','Sedayu','Premiere')),
  notes           text,
  attachment_path text,                       -- PO / invoice file (bucket: receiving-files)
  assigned_to     uuid references auth.users (id),
  status          text not null default 'pending' check (status in ('pending','confirmed')),
  confirmed_by    uuid references auth.users (id),
  confirmed_at    timestamptz,
  created_at      timestamptz not null default now()
);

create table if not exists public.receiving_lines (
  id         uuid primary key default gen_random_uuid(),
  order_id   uuid not null references public.receiving_orders (id) on delete cascade,
  item_name  text not null,
  qty        numeric(12,2) not null default 1 check (qty > 0),
  unit       text,
  checked    boolean not null default false,
  position   int not null default 0
);

create index if not exists recv_orders_created_idx  on public.receiving_orders (created_by);
create index if not exists recv_orders_assigned_idx on public.receiving_orders (assigned_to);
create index if not exists recv_lines_order_idx     on public.receiving_lines (order_id);

alter table public.receiving_orders enable row level security;
alter table public.receiving_lines  enable row level security;

drop policy if exists "ro_insert_own" on public.receiving_orders;
create policy "ro_insert_own" on public.receiving_orders
  for insert to authenticated
  with check (created_by = auth.uid());

drop policy if exists "ro_select_participant" on public.receiving_orders;
create policy "ro_select_participant" on public.receiving_orders
  for select to authenticated
  using (created_by = auth.uid() or assigned_to = auth.uid() or public.is_admin());

drop policy if exists "ro_update_participant" on public.receiving_orders;
create policy "ro_update_participant" on public.receiving_orders
  for update to authenticated
  using (
    assigned_to = auth.uid()
    or public.is_admin()
    or (created_by = auth.uid() and status = 'pending')
  );

drop policy if exists "ro_delete_own_pending" on public.receiving_orders;
create policy "ro_delete_own_pending" on public.receiving_orders
  for delete to authenticated
  using ((created_by = auth.uid() and status = 'pending') or public.is_admin());

drop policy if exists "rl_insert" on public.receiving_lines;
create policy "rl_insert" on public.receiving_lines
  for insert to authenticated
  with check (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id and o.created_by = auth.uid() and o.status = 'pending'
  ));

drop policy if exists "rl_select" on public.receiving_lines;
create policy "rl_select" on public.receiving_lines
  for select to authenticated
  using (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id
      and (o.created_by = auth.uid() or o.assigned_to = auth.uid() or public.is_admin())
  ));

drop policy if exists "rl_update" on public.receiving_lines;
create policy "rl_update" on public.receiving_lines
  for update to authenticated
  using (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id
      and (o.assigned_to = auth.uid() or public.is_admin()
           or (o.created_by = auth.uid() and o.status = 'pending'))
  ));

drop policy if exists "rl_delete" on public.receiving_lines;
create policy "rl_delete" on public.receiving_lines
  for delete to authenticated
  using (exists (
    select 1 from public.receiving_orders o
    where o.id = order_id
      and ((o.created_by = auth.uid() and o.status = 'pending') or public.is_admin())
  ));

-- ---------------------------------------------------------------------------
-- 3. STORE MOVEMENT
-- ---------------------------------------------------------------------------
create table if not exists public.store_movements (
  id            uuid primary key default gen_random_uuid(),
  created_by    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  from_location text not null check (from_location in ('Manhattan','Sedayu','Premiere')),
  to_location   text not null check (to_location in ('Manhattan','Sedayu','Premiere')),
  notes         text,
  assigned_to   uuid references auth.users (id),
  status        text not null default 'pending' check (status in ('pending','preparing','completed')),
  completed_by  uuid references auth.users (id),
  completed_at  timestamptz,
  created_at    timestamptz not null default now()
);

create table if not exists public.movement_lines (
  id          uuid primary key default gen_random_uuid(),
  movement_id uuid not null references public.store_movements (id) on delete cascade,
  item_name   text not null,
  qty         numeric(12,2) not null default 1 check (qty > 0),
  unit        text,
  position    int not null default 0
);

create index if not exists mov_created_idx  on public.store_movements (created_by);
create index if not exists mov_assigned_idx on public.store_movements (assigned_to);
create index if not exists mov_lines_idx    on public.movement_lines (movement_id);

alter table public.store_movements enable row level security;
alter table public.movement_lines  enable row level security;

drop policy if exists "sm_insert_own" on public.store_movements;
create policy "sm_insert_own" on public.store_movements
  for insert to authenticated
  with check (created_by = auth.uid());

drop policy if exists "sm_select_participant" on public.store_movements;
create policy "sm_select_participant" on public.store_movements
  for select to authenticated
  using (created_by = auth.uid() or assigned_to = auth.uid() or public.is_admin());

drop policy if exists "sm_update_participant" on public.store_movements;
create policy "sm_update_participant" on public.store_movements
  for update to authenticated
  using (
    assigned_to = auth.uid()
    or public.is_admin()
    or (created_by = auth.uid() and status = 'pending')
  );

drop policy if exists "sm_delete_own_pending" on public.store_movements;
create policy "sm_delete_own_pending" on public.store_movements
  for delete to authenticated
  using ((created_by = auth.uid() and status = 'pending') or public.is_admin());

drop policy if exists "ml_insert" on public.movement_lines;
create policy "ml_insert" on public.movement_lines
  for insert to authenticated
  with check (exists (
    select 1 from public.store_movements m
    where m.id = movement_id and m.created_by = auth.uid() and m.status = 'pending'
  ));

drop policy if exists "ml_select" on public.movement_lines;
create policy "ml_select" on public.movement_lines
  for select to authenticated
  using (exists (
    select 1 from public.store_movements m
    where m.id = movement_id
      and (m.created_by = auth.uid() or m.assigned_to = auth.uid() or public.is_admin())
  ));

drop policy if exists "ml_delete" on public.movement_lines;
create policy "ml_delete" on public.movement_lines
  for delete to authenticated
  using (exists (
    select 1 from public.store_movements m
    where m.id = movement_id
      and ((m.created_by = auth.uid() and m.status = 'pending') or public.is_admin())
  ));

-- ---------------------------------------------------------------------------
-- 4. STORAGE bucket for PO / invoice attachments.
--    Any signed-in employee can view (assignees need to open the PO);
--    uploads go to the uploader's own folder.
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('receiving-files', 'receiving-files', false)
on conflict (id) do nothing;

drop policy if exists "recv_upload_own" on storage.objects;
create policy "recv_upload_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'receiving-files'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "recv_read_auth" on storage.objects;
create policy "recv_read_auth" on storage.objects
  for select to authenticated
  using (bucket_id = 'receiving-files');

-- ============================================================================
-- DONE. Reload the web app — everyone gets "Receiving" and "Store Movement".
-- ============================================================================

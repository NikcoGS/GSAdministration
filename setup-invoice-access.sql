-- ============================================================================
-- GS Operational System — invoice files readable by the people who check goods
--
-- The invoices bucket was locked to whoever uploaded the file plus admins, a
-- rule from the very first setup that the later per-feature permissions never
-- extended. So a checker opening a purchase from Receiving saw the invoice
-- button but got "attachment unavailable", and the same happened to anyone
-- with Purchasing Book or approval access who is not an admin.
--
-- Reading now follows feature access: your own uploads, site operations
-- (receiving), and anyone who can already see every purchase. Uploading is
-- unchanged — only the requester writes to their own folder.
--
-- Run ONCE in the Supabase SQL Editor, AFTER setup-permissions.sql.
-- Safe to re-run.
-- ============================================================================

drop policy if exists "invoice_read_own_or_admin" on storage.objects;
create policy "invoice_read_own_or_admin" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'invoices'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or public.is_admin()
      or public.has_perm('siteops')
      or public.can_view_all()
    )
  );

notify pgrst, 'reload schema';

-- ============================================================================
-- DONE. Anyone with Site operations access can now open the invoice behind a
-- purchase they are receiving.
-- ============================================================================

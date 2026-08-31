-- ============================================================================
-- GS Operational System — Feature 9: Payment input with proof attachment
-- "Mark paid" becomes a payment entry: date, amount, bank ref, note, and the
-- transfer receipt, stored on the payment batch. Run ONCE. Safe to re-run.
-- ============================================================================

alter table public.disbursement_batches add column if not exists paid_date    date;
alter table public.disbursement_batches add column if not exists amount       numeric(16,2);
alter table public.disbursement_batches add column if not exists currency     text;
alter table public.disbursement_batches add column if not exists bank_ref     text;            -- transfer reference number
alter table public.disbursement_batches add column if not exists fees         numeric(16,2);   -- transaction / remittance fees
alter table public.disbursement_batches add column if not exists note         text;
alter table public.disbursement_batches add column if not exists proof_path   text;            -- storage: payment-proofs
alter table public.disbursement_batches add column if not exists verification jsonb;           -- AI check result

-- private bucket for transfer receipts (admins only)
insert into storage.buckets (id, name, public)
values ('payment-proofs', 'payment-proofs', false)
on conflict (id) do nothing;

drop policy if exists "proof_upload_admin" on storage.objects;
create policy "proof_upload_admin" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'payment-proofs'
    and public.is_admin()
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "proof_read_admin" on storage.objects;
create policy "proof_read_admin" on storage.objects
  for select to authenticated
  using (bucket_id = 'payment-proofs' and public.is_admin());

-- ============================================================================
-- DONE. Reload the web app.
-- ============================================================================

-- ============================================================================
-- GS Operational System — import of GS_Purchasing_Compilation.xlsx
-- 102 invoices, 547 item lines, 32 payment batches.
-- Idempotent: rows already in the app (matched on invoice no.) are skipped.
-- Paste into Supabase -> SQL Editor -> Run.
-- ============================================================================
do $$
declare v_user uuid; v_batch uuid;
begin
  select id into v_user from public.profiles where email = 'nikco@golfsolutionsid.com' limit 1;
  if v_user is null then raise exception 'No profile found for nikco@golfsolutionsid.com - sign up in the app first.'; end if;

  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-18|5005635303') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-18', 16338500.00, 'IDR', '26081800351261', 'gsimport:2026-08-18|5005635303');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-21|5855-855833') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-21', 22878000.00, 'IDR', null, 'gsimport:2026-08-21|5855-855833');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-12|8868875134979764') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-12', 1626312.00, 'IDR', '26081204530203', 'gsimport:2026-08-12|8868875134979764');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-12|5855-855833') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-12', 7926500.00, 'IDR', '26081200252731', 'gsimport:2026-08-12|5855-855833');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-18|0616092001') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-18', 4074000.00, 'IDR', '26081800350532', 'gsimport:2026-08-18|0616092001');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-10|5005635303') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-10', 22087500.00, 'IDR', null, 'gsimport:2026-08-10|5005635303');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-11|(not printed on invoice)') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-11', 10000000.00, 'IDR', '26081102879489', 'gsimport:2026-08-11|(not printed on invoice)');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-10|N/A') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-10', 67000.00, 'IDR', null, 'gsimport:2026-08-10|N/A');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-10|141030013012092') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-10', 65409971.00, 'IDR', '218708008212691', 'gsimport:2026-08-10|141030013012092');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-10|0628514607') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-10', 11196774.00, 'IDR', '218799008215691', 'gsimport:2026-08-10|0628514607');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-07|0721400057') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-07', 103488075.00, 'IDR', '218702008205691', 'gsimport:2026-08-07|0721400057');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-07|0017001208012022') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-07', 49306158.00, 'IDR', '218702008203691', 'gsimport:2026-08-07|0017001208012022');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-20|833.5299.911') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-20', 840000.00, 'IDR', '26082000232563', 'gsimport:2026-08-20|833.5299.911');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-20|061.300.7579') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-20', 6160000.00, 'IDR', '26082000232675', 'gsimport:2026-08-20|061.300.7579');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-08-31|0721400057') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-08-31', 57970553.00, 'IDR', null, 'gsimport:2026-08-31|0721400057');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-02-12|000466644188') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-02-12', 224775297.00, 'IDR', null, 'gsimport:2026-02-12|000466644188');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-05-08|288-9003-886 (SGD)') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-05-08', 6097598.00, 'IDR', null, 'gsimport:2026-05-08|288-9003-886 (SGD)');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-05-08|0288-000330-011-022 (USD)') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-05-08', 133460639.00, 'IDR', null, 'gsimport:2026-05-08|0288-000330-011-022 (USD)');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-06-17|1410 3001 3015 369') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-06-17', 284300066.00, 'IDR', null, 'gsimport:2026-06-17|1410 3001 3015 369');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-03-11|0721400057') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-03-11', 111312624.00, 'IDR', null, 'gsimport:2026-03-11|0721400057');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-04-16|0721400057') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-04-16', 378085476.00, 'IDR', null, 'gsimport:2026-04-16|0721400057');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-06-10|0721400057') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-06-10', 234608168.00, 'IDR', null, 'gsimport:2026-06-10|0721400057');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-05-13|0017001208012022') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-05-13', 299068967.00, 'IDR', null, 'gsimport:2026-05-13|0017001208012022');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-04-28|0017001208012022') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-04-28', 30527672.00, 'IDR', null, 'gsimport:2026-04-28|0017001208012022');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-02-13|0721032970') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-02-13', 175628852.00, 'IDR', null, 'gsimport:2026-02-13|0721032970');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-06-08|0721032970') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-06-08', 146974235.00, 'IDR', null, 'gsimport:2026-06-08|0721032970');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-04-28|2000649833') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-04-28', 54933736.00, 'IDR', null, 'gsimport:2026-04-28|2000649833');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-03-11|1221 100 1001 3251') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-03-11', 167699354.00, 'IDR', null, 'gsimport:2026-03-11|1221 100 1001 3251');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-04-21|1221 100 1001 3251') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-04-21', 53857790.00, 'IDR', null, 'gsimport:2026-04-21|1221 100 1001 3251');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-05-06|1221 100 1001 3251') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-05-06', 134406562.00, 'IDR', null, 'gsimport:2026-05-06|1221 100 1001 3251');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-04-28|141030013012092') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-04-28', 31755011.00, 'IDR', null, 'gsimport:2026-04-28|141030013012092');
  end if;
  if not exists (select 1 from public.disbursement_batches where note = 'gsimport:2026-06-17|141030013012092') then
    insert into public.disbursement_batches (created_by, paid_date, amount, currency, bank_ref, note)
    values (v_user, '2026-06-17', 75655821.00, 'IDR', null, 'gsimport:2026-06-17|141030013012092');
  end if;

  -- SI.2026.08.00046 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.08.00046') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-18|5005635303' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.08.00046', 'CV Matkos Mandiri Utama', 'SI.2026.08.00046', '2026-08-12', 'Golf Solution Jacky Safriano', 'C.O.D',
      2655000.00, 'IDR', 3450000.00, 862500.00, '[{"item_name":"Fujikura Ventus Hybrid RED Velocore plus 70S","item_code":"100768","qty":1.0,"unit_price":2587500.0,"landed_unit_price":2655000.0}]'::jsonb, '[{"name":"Other fee","amount":67500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'Part of a single BCA transfer to Matkos (5005635303), Rp16,338,500.00, sent 18 Aug 2026 13:19:31, Ref No. 26081800351261, status Berhasil. Covers SI.2026.08.00046 + SI.2026.08.00049 + SI.2026.08.00059 exactly (2,655,000 + 10,658,000 + 3,025,500 = 16,338,500). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-12'::timestamptz, '2026-08-18'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.08.00049 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.08.00049') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-18|5005635303' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.08.00049', 'CV Matkos Mandiri Utama', 'SI.2026.08.00049', '2026-08-14', 'Golf Solution Jacky Safriano', 'C.O.D',
      10658000.00, 'IDR', 14190000.00, 3547500.00, '[{"item_name":"Fujikura Ventus Blue VeloCore Plus 2024 6S Wood","item_code":"100682","qty":3.0,"unit_price":3547500.0,"landed_unit_price":3552666.66666667}]'::jsonb, '[{"name":"Other fee","amount":15500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'Part of the same bulk BCA transfer as SI.2026.08.00046 - see that row''s note for the full breakdown. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-14'::timestamptz, '2026-08-18'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.08.00059 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.08.00059') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-18|5005635303' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.08.00059', 'CV Matkos Mandiri Utama', 'SI.2026.08.00059', '2026-08-18', 'Golf Solution Jacky Safriano', 'C.O.D',
      3025500.00, 'IDR', 4300000.00, 1290000.00, '[{"item_name":"KBS TGI 70 Tour Parallel Iron Graphite","item_code":"100615","qty":4.0,"unit_price":752500.0,"landed_unit_price":756375.0}]'::jsonb, '[{"name":"Other fee","amount":15500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'Part of the same bulk BCA transfer as SI.2026.08.00046 - see that row''s note for the full breakdown. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-18'::timestamptz, '2026-08-18'::timestamptz, v_user, v_batch
    );
  end if;
  -- TNA/IN/0428/26 (PT. Tri Nara Adyasa (Golf Gift))
  if not exists (select 1 from public.payment_requests where ref_number = 'TNA/IN/0428/26') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-21|5855-855833' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT. Tri Nara Adyasa (Golf Gift) — TNA/IN/0428/26', 'PT. Tri Nara Adyasa (Golf Gift)', 'TNA/IN/0428/26', '2026-08-18', 'PT. Solusi Golf Indonesia', 'Bank Transfer',
      22878000.00, 'IDR', 20610811.00, 0.00, '[{"item_name":"GTS300 RH MCA TENSEI 1L BLUE S","item_code":"683RG2S13A","qty":3.0,"unit_price":6870270.0,"landed_unit_price":7625999.66666667}]'::jsonb, '[{"name":"Tax / PPN","amount":2267189.0}]'::jsonb,
      'BCA KCP Ampera Raya', 'PT. Tri Nara Adyasa', '5855-855833', 'User-confirmed PAID on 21 Aug 2026 (BCA transfer, receipt to follow) - Amount Paid set equal to the invoice total; attach the transfer receipt/reference when it arrives. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-18'::timestamptz, '2026-08-21'::timestamptz, v_user, v_batch
    );
  end if;
  -- 132875134979764 (PT FedEx Express International)
  if not exists (select 1 from public.payment_requests where ref_number = '132875134979764') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-12|8868875134979764' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT FedEx Express International — 132875134979764', 'PT FedEx Express International', '132875134979764', '2026-08-10', 'Golf Solutions (c/o FST Japan Ltd shipment)', 'ROD (pay to Citibank Virtual Account)',
      1626312.00, 'IDR', 1600121.00, 0.00, '[{"item_name":"FedEx import charges - Duty Tax + Courier Fee (shipment from FST Japan Ltd)","item_code":"HAWB 875134979764","qty":1.0,"unit_price":1600121.0,"landed_unit_price":1626312.0}]'::jsonb, '[{"name":"Tax / PPN","amount":26191.0}]'::jsonb,
      'Citibank Virtual Account', 'PT FedEx Express International', '8868875134979764', 'BCA transfer to VA 700701502169530620, Ref No. 26081204530203; bank receipt shows status ''Dalam Proses'' (authorized, processing) as of 12 Aug 2026 16:21 | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-10'::timestamptz, '2026-08-12'::timestamptz, v_user, v_batch
    );
  end if;
  -- TNA/IN/0423/26 (PT. Tri Nara Adyasa (Golf Gift))
  if not exists (select 1 from public.payment_requests where ref_number = 'TNA/IN/0423/26') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-12|5855-855833' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT. Tri Nara Adyasa (Golf Gift) — TNA/IN/0423/26', 'PT. Tri Nara Adyasa (Golf Gift)', 'TNA/IN/0423/26', '2026-08-11', 'PT. Solusi Golf Indonesia', 'Bank Transfer',
      7926500.00, 'IDR', 7140991.00, 0.00, '[{"item_name":"U505 3G RH HZD BLK 80 6.0 4 A","item_code":"558RG1S4A","qty":1.0,"unit_price":3477027.0,"landed_unit_price":3859499.96513089},{"item_name":"U505 4G RH TENSEI 1K BLUE 65 HY S 3 A","item_code":"565RGS3A","qty":1.0,"unit_price":3663964.0,"landed_unit_price":4067000.03486911}]'::jsonb, '[{"name":"Tax / PPN","amount":785509.0}]'::jsonb,
      'BCA KCP Ampera Raya', 'PT. Tri Nara Adyasa', '5855-855833', 'BCA transfer to VA 5855855833 (TRI NARA ADYASA PT), Ref No. 26081200252731, status Berhasil | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-11'::timestamptz, '2026-08-12'::timestamptz, v_user, v_batch
    );
  end if;
  -- 2026081408 (Portasi)
  if not exists (select 1 from public.payment_requests where ref_number = '2026081408') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-18|0616092001' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Portasi — 2026081408', 'Portasi', '2026081408', '2026-08-14', 'PRTS Benny Ng (Golf Solutions)', 'Advance Payment',
      4074000.00, 'IDR', 4074000.00, 0.00, '[{"item_name":"Consolidation Air (Regular) Freight Service - Batam to Surabaya","item_code":"N/A","qty":42.0,"unit_price":97000.0,"landed_unit_price":97000.0}]'::jsonb, null,
      'BCA', 'Leonardus Fernando', '0616092001', 'BCA transfer to 0616092001 (Leonardus Fernando), Ref No. 26081800350532, status Berhasil | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-14'::timestamptz, '2026-08-18'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.08.00008 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.08.00008') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-10|5005635303' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.08.00008', 'CV Matkos Mandiri Utama', 'SI.2026.08.00008', '2026-08-04', 'Golf Solution Jacky Safriano', 'C.O.D',
      13297500.00, 'IDR', 17640000.00, 4410000.00, '[{"item_name":"Fujikura Ventus TR Plus Blue 70 S wood 0.335","item_code":"100832","qty":2.0,"unit_price":3547500.0,"landed_unit_price":3565599.48979592},{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70S","item_code":"100772","qty":1.0,"unit_price":2587500.0,"landed_unit_price":2600701.53061224},{"item_name":"Fujikura Ventus TR Plus Black 60 X wood 0.335","item_code":"100841","qty":1.0,"unit_price":3547500.0,"landed_unit_price":3565599.48979592}]'::jsonb, '[{"name":"Other fee","amount":67500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'Part of a single BCA transfer to Matkos (5005635303): Rp22,154,500 + Rp2,500 admin fee = Rp22,157,000 total, sent 10 Aug 2026 19:32. User confirmed this transfer covers SI.2026.08.00008 + SI.2026.08.00023 + SO.2026.08.00043 + the Rp67,000 Grab/GoPay courier fee (see GRAB-260810-SHAFT row) = Rp22,154,500 exactly. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-04'::timestamptz, '2026-08-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.08.00023 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.08.00023') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-10|5005635303' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.08.00023', 'CV Matkos Mandiri Utama', 'SI.2026.08.00023', '2026-08-06', 'Golf Solution Jacky Safriano', 'C.O.D',
      2655000.00, 'IDR', 3450000.00, 862500.00, '[{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70S","item_code":"100772","qty":1.0,"unit_price":2587500.0,"landed_unit_price":2655000.0}]'::jsonb, '[{"name":"Other fee","amount":67500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'Part of the same bulk BCA transfer as SI.2026.08.00008 - see that row''s note for the full breakdown. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-06'::timestamptz, '2026-08-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/0826/001 (PT. Fokus Untuk Cari Konsultan)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/0826/001') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-11|(not printed on invoice)' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT. Fokus Untuk Cari Konsultan — INV/0826/001', 'PT. Fokus Untuk Cari Konsultan', 'INV/0826/001', '2026-08-01', 'Golf Solutions', 'Monthly installment, due 10th, to CIMB Niaga',
      10000000.00, 'IDR', 10000000.00, 0.00, '[{"item_name":"Software dev project - August 2026 installment (termin 4 of 20, Rp200,000,000 total project)","item_code":"N/A","qty":1.0,"unit_price":10000000.0,"landed_unit_price":10000000.0}]'::jsonb, null,
      'CIMB Niaga', 'PT. Fokus Untuk Cari Konsultan', '(not printed on invoice)', 'BI-Fast transfer from ''Teknologi Keahlian Olahr(aga)'' account to VA 707333161800, Ref No. 26081102879489, status Berhasil. Amount matches the August installment exactly; recipient account not independently confirmed against the invoice (invoice names only ''CIMB Niaga a.n. PT. Fokus Untuk Cari Konsultan'', no account number printed). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-01'::timestamptz, '2026-08-11'::timestamptz, v_user, v_batch
    );
  end if;
  -- SO.2026.08.00043 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SO.2026.08.00043') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-10|5005635303' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SO.2026.08.00043', 'CV Matkos Mandiri Utama', 'SO.2026.08.00043', '2026-08-10', 'Golf Solution Jacky Safriano', 'C.O.D (Sales Order - paid before formal Faktur Penjualan issued)',
      6135000.00, 'IDR', 8180000.00, 2045000.00, '[{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70S","item_code":"N/A","qty":1.0,"unit_price":2587500.0,"landed_unit_price":2587500.0},{"item_name":"Fujikura Ventus Red Velocore Plus Wood 6S","item_code":"N/A","qty":1.0,"unit_price":3547500.0,"landed_unit_price":3547500.0}]'::jsonb, null,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'Part of the same bulk BCA transfer as SI.2026.08.00008 - see that row''s note. This Sales Order was paid before a formal Faktur Penjualan/invoice was issued for it - if/when the formal invoice arrives for these same 2 items, reconcile against this row rather than adding a duplicate. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-10'::timestamptz, '2026-08-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- GRAB-260810-SHAFT (Gojek/Grab (Instant courier))
  if not exists (select 1 from public.payment_requests where ref_number = 'GRAB-260810-SHAFT') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-10|N/A' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'expense', 'Gojek/Grab (Instant courier) — GRAB-260810-SHAFT', 'Gojek/Grab (Instant courier)', 'GRAB-260810-SHAFT', '2026-08-10', 'Golf Solution', 'GoPay (COD courier fee)',
      67000.00, 'IDR', 67000.00, 0.00, '[{"item_name":"Grab/GoPay courier delivery fee - shaft delivery to Golf Solution","item_code":"N/A","qty":1.0,"unit_price":67000.0,"landed_unit_price":67000.0}]'::jsonb, null,
      'GoPay', 'N/A', 'N/A', 'Courier fee for delivering a shaft to Golf Solution, paid via GoPay per Grab app screenshot (WhatsApp Image 2026-08-10 at 17.20.20.jpeg). User confirmed this Rp67,000 is bundled into the Rp22,154,500 total of the same-day bulk BCA transfer alongside SI.2026.08.00008, SI.2026.08.00023 and SO.2026.08.00043 (see those rows). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-10'::timestamptz, '2026-08-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- SG-00059 (SG Performance Sdn. Bhd.)
  if not exists (select 1 from public.payment_requests where ref_number = 'SG-00059') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-10|141030013012092' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'SG Performance Sdn. Bhd. — SG-00059', 'SG Performance Sdn. Bhd.', 'SG-00059', '2026-08-01', 'PT Teknologi Keahlian Olahraga (Golf Solutions)', 'International wire (MYR)',
      64872371.00, 'IDR', 64872371.00, 0.00, '[{"item_name":"June & July 2026 Commission (SG Performance)","item_code":"N/A","qty":1.0,"unit_price":64872371.0,"landed_unit_price":64872371.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'SG Performance Sdn. Bhd.', '141030013012092', 'International wire via BRIfast Remittance (Bank BRI), Ref No. 218708008212691 / UETR 07ab0899-e53e-4893-abce-abf45c23622a, to Alliance Bank Malaysia acct 141030013012092. Transaction amount MYR 14,453.64 = IDR 64,872,371.20 (Nominal Debet, = Invoice Total). Wire fee IDR 537,600.00 (Nominal Biaya) EXCLUDED from Invoice Total/Final Price per user instruction; Amount Paid here is the full Total Debet (IDR 65,409,971.20) reflecting actual cash outflow including the fee. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-01'::timestamptz, '2026-08-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- QT-202608001 (CNX Golf (CNX & Co Co., Ltd))
  if not exists (select 1 from public.payment_requests where ref_number = 'QT-202608001') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-10|0628514607' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CNX Golf (CNX & Co Co., Ltd) — QT-202608001', 'CNX Golf (CNX & Co Co., Ltd)', 'QT-202608001', '2026-08-07', 'Golf Solutions (attn: Mr. Gani)', 'International wire (THB)',
      10659174.00, 'IDR', 13323968.00, 2664794.00, '[{"item_name":"VESSEL: Player V Pro - Stand - Kintsugi / 7-Way","item_code":"CNX P6054","qty":1.0,"unit_price":10659174.0,"landed_unit_price":10659174.0}]'::jsonb, null,
      'Kasikornbank Public Company Limited', 'CNX & Co Co., Ltd', '0628514607', 'International wire via BRIfast Remittance (Bank BRI), Ref No. 218799008215691 / UETR de987d5d-c29e-40fa-9946-328036f61238, to Kasikornbank acct 0628514607. Transaction amount THB 19,200.00 = IDR 10,659,174.40 (Nominal Debet, = Invoice Total). Wire fee IDR 537,600.00 (Nominal Biaya) EXCLUDED from Invoice Total/Final Price per user instruction; Amount Paid here is the full Total Debet (IDR 11,196,774.40) reflecting actual cash outflow including the fee. Source document is a CNX Golf quotation (ใบเสนอราคา QT-202608001), not a formal tax invoice - used since its amount matches the wire exactly. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-07'::timestamptz, '2026-08-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV-0826-001 (Point Leo Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV-0826-001') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-07|0721400057' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Point Leo Pte Ltd — INV-0826-001', 'Point Leo Pte Ltd', 'INV-0826-001', '2026-08-07', 'CV. Teknologi Keahlian Olahraga Golf', 'International wire (USD), Due on Receipt',
      102856500.00, 'IDR', 108270000.00, 5413500.00, '[{"item_name":"MIURA HD RH IC602 QPQ BLK IR #5","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH IC602 QPQ BLK IR #6","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH IC602 QPQ BLK IR #7","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH IC602 QPQ BLK IR #8","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH IC602 QPQ BLK IR #9","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH IC602 QPQ BLK IR #PW","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH KM700 QPQ IR #5","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH KM700 QPQ IR #6","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH KM700 QPQ IR #7","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH KM700 QPQ IR #8","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH KM700 QPQ IR #9","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH KM700 QPQ IR #PW","item_code":"N/A","qty":1.0,"unit_price":4114260.0,"landed_unit_price":4114260.0},{"item_name":"MIURA HD RH PI402 CHROME IR #5","item_code":"N/A","qty":2.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #6","item_code":"N/A","qty":2.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #7","item_code":"N/A","qty":2.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #8","item_code":"N/A","qty":2.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #9","item_code":"N/A","qty":2.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #PW","item_code":"N/A","qty":2.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH FORGED CHRME YG WG 52","item_code":"N/A","qty":1.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #4","item_code":"N/A","qty":1.0,"unit_price":3565692.0,"landed_unit_price":3565692.0},{"item_name":"MIURA HD RH PI402 CHROME IR #GW","item_code":"N/A","qty":1.0,"unit_price":3565692.0,"landed_unit_price":3565692.0}]'::jsonb, null,
      'DBS Singapore Pte Ltd', 'Point Leo Pte Ltd', '0721400057', 'International wire via BRIfast Remittance (Bank BRI), Ref No. 218702008205691 / UETR 72ce13e5-22e9-4c50-83c0-3f2ad13d546d, to DBS Bank Ltd (Singapore) acct 0721400057. Transaction amount USD 5,700.00 = IDR 102,856,500.00 (Nominal Debet, = Invoice Total). Wire fee IDR 631,575.00 (Nominal Biaya) EXCLUDED from Invoice Total/Final Price; Amount Paid is the full Total Debet (IDR 103,488,075.00). NOTE: invoice number ''INV-0826-001'' (dashes, Point Leo Pte Ltd) is visually similar to but distinct from ''INV/0826/001'' (slashes, PT. Fokus Untuk Cari Konsultan) - different vendors. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-07'::timestamptz, '2026-08-07'::timestamptz, v_user, v_batch
    );
  end if;
  -- PRO-01697 (WinGolf Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'PRO-01697') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-07|0017001208012022' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'WinGolf Pte Ltd — PRO-01697', 'WinGolf Pte Ltd', 'PRO-01697', '2026-07-07', 'Golf Solution PIK (attn: Mr. Jacky Safriano)', 'ADV (advance payment), International wire (USD)',
      48764808.00, 'IDR', 93328740.00, 44563932.00, '[{"item_name":"WEDGE RH 2024 ProdiG 54/S ProdiG S STD Black Junior","item_code":"N/A","qty":1.0,"unit_price":1414367.0,"landed_unit_price":1414367.0},{"item_name":"WEDGE RH 2024 ProdiG 58/H ProdiG S STD Black Junior","item_code":"N/A","qty":1.0,"unit_price":1414367.0,"landed_unit_price":1414367.0},{"item_name":"IRON RH 2024 ProdiG #7-9PW ProdiG S STD Black Junior","item_code":"N/A","qty":1.0,"unit_price":5657108.0,"landed_unit_price":5657108.0},{"item_name":"DRIVER RH 2024 ProdiG 15 DEG ProdiG S 39.5 Junior","item_code":"N/A","qty":2.0,"unit_price":3582835.0,"landed_unit_price":3582835.0},{"item_name":"WEDGE RH 2024 ProdiG 54/S ProdiG R -0.5 Black Junior","item_code":"N/A","qty":1.0,"unit_price":1414367.0,"landed_unit_price":1414367.0},{"item_name":"WEDGE RH 2024 ProdiG 58/H ProdiG R -0.5 Black Junior","item_code":"N/A","qty":1.0,"unit_price":1414367.0,"landed_unit_price":1414367.0},{"item_name":"IRON RH 2024 ProdiG #7-9PW ProdiG R -0.5 Black Junior","item_code":"N/A","qty":3.0,"unit_price":5657107.33333333,"landed_unit_price":5657107.33333333},{"item_name":"PUTTER RH 2024 ProdiG Anser 3 DEG ProdiG -2in Black PP58","item_code":"N/A","qty":2.0,"unit_price":1536892.5,"landed_unit_price":1536892.5},{"item_name":"PUTTER RH 2024 ProdiG Tyne H 3 DEG ProdiG -2in Black PP58","item_code":"N/A","qty":2.0,"unit_price":1536892.5,"landed_unit_price":1536892.5},{"item_name":"DRIVER RH 2024 ProdiG 15 DEG ProdiG R -0.75 Junior","item_code":"N/A","qty":2.0,"unit_price":3582835.0,"landed_unit_price":3582835.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'WinGolf Pte Ltd', '0017001208012022', 'International wire via BRIfast Remittance (Bank BRI), Ref No. 218702008203691 / UETR 0556e3ae-56f6-473f-87a0-3a564cb6d7f9, to DBS Bank Ltd (Singapore) acct 0017001208012022. Transaction amount USD 2,702.40 = IDR 48,764,808.00 (Nominal Debet, = Invoice Total). Wire fee IDR 541,350.00 (Nominal Biaya) EXCLUDED from Invoice Total/Final Price; Amount Paid is the full Total Debet (IDR 49,306,158.00). Source document is a Proforma Invoice dated 7 Jul 2026 (ADV/advance-payment terms), not a finalized tax invoice; paid via wire on 7 Aug 2026. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-07'::timestamptz, '2026-08-07'::timestamptz, v_user, v_batch
    );
  end if;
  -- 2026-0051 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0051') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0051', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0051', '2026-04-07', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), CBD',
      1189320.00, 'IDR', 1189320.00, 0.00, '[{"item_name":"GEOTECH REACE HYBRID WITH HC","item_code":"30358","qty":1.0,"unit_price":1189320.0,"landed_unit_price":1189320.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-07'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0068 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0068') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0068', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0068', '2026-05-26', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), 60 DAYS',
      17503200.00, 'IDR', 17503200.00, 0.00, '[{"item_name":"ITOBORI DRIVER JACKPOT 2026 - LIMITED EDITION - BLACK - 10.5","item_code":"30616","qty":2.0,"unit_price":8751600.0,"landed_unit_price":8751600.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-05-26'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0078 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0078') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0078', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0078', '2026-06-15', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), 60 DAYS',
      132449856.00, 'IDR', 132449856.00, 0.00, '[{"item_name":"FUJIKURA SHAFT VENTUS DRIVER BLUE TR 5R 2026 - FLEX R","item_code":"20176","qty":5.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS DRIVER BLUE TR 5S 2026 - FLEX R","item_code":"20176","qty":10.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS DRIVER BLUE TR 6S 2026 - FLEX R","item_code":"20176","qty":7.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS DRIVER BLUE TR 6X 2026 - FLEX R","item_code":"20176","qty":3.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"PXG-MITSUBISHI SHAFT IRON MMT 60R - FLEX R","item_code":"20317","qty":14.0,"unit_price":359040.0,"landed_unit_price":359040.0},{"item_name":"FUJIKURA SHAFT VENTUS DRIVER RED 5S 2024 - FLEX S","item_code":"20176","qty":1.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"GRAPHITE DESIGN SHAFT WOOD TOUR AD DI 5S - FLEX S","item_code":"20011","qty":1.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT WOOD TOUR AD DI 6S - FLEX S","item_code":"20011","qty":1.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT WOOD TOUR AD VF 5S - FLEX S","item_code":"20011","qty":1.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"PXG IRON BLACK OPS - #5 - #GW","item_code":"30488","qty":7.0,"unit_price":1122000.0,"landed_unit_price":1122000.0},{"item_name":"PXG-MITSUBISHI SHAFT HY - DAIMANA 60S","item_code":"20319","qty":7.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"PXG-LAMKIN GRIP Z5 - STD","item_code":"10119","qty":7.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"TITLEIST WEDGE SM11 - TC 60.12D","item_code":"30584","qty":1.0,"unit_price":3002472.0,"landed_unit_price":3002472.0},{"item_name":"TITLEIST WEDGE SM11 - TC 58.08M","item_code":"30584","qty":1.0,"unit_price":3002472.0,"landed_unit_price":3002472.0},{"item_name":"TITLEIST WEDGE SM11 - TC 52.08F","item_code":"30584","qty":1.0,"unit_price":3002472.0,"landed_unit_price":3002472.0},{"item_name":"TITLEIST WEDGE SM11 - TC 60.08M","item_code":"30584","qty":1.0,"unit_price":3002472.0,"landed_unit_price":3002472.0},{"item_name":"TITLEIST WEDGE SM11 - TC 56.10S","item_code":"30584","qty":1.0,"unit_price":3002472.0,"landed_unit_price":3002472.0},{"item_name":"TITLEIST WEDGE SM11 - TC 50.08F","item_code":"30584","qty":1.0,"unit_price":3002472.0,"landed_unit_price":3002472.0},{"item_name":"KINETIXX SHAFT PUTTER ZERO TORQUE","item_code":"20292","qty":2.0,"unit_price":3038376.0,"landed_unit_price":3038376.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-15'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0079 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0079') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0079', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0079', '2026-06-16', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), 60 DAYS',
      56894376.00, 'IDR', 56894376.00, 0.00, '[{"item_name":"PXG IRON BLACK OPS - #5 - #GW","item_code":"30488","qty":7.0,"unit_price":1122000.0,"landed_unit_price":1122000.0},{"item_name":"PXG-MITSUBISHI SHAFT HY - DAIMANA 60S","item_code":"20319","qty":7.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"PXG-LAMKIN GRIP Z5 - STD","item_code":"10119","qty":7.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"TITLEIST DRIVER GTS3 9.0deg","item_code":"30619","qty":1.0,"unit_price":10499227.0,"landed_unit_price":10499227.0},{"item_name":"TITLEIST DRIVER GTS2 9.0deg","item_code":"30619","qty":1.0,"unit_price":10499227.0,"landed_unit_price":10499227.0},{"item_name":"TITLEIST DRIVER GTS2 10.0deg","item_code":"30619","qty":1.0,"unit_price":10499227.0,"landed_unit_price":10499227.0},{"item_name":"TITLEIST FW GTS3 15.0deg","item_code":"30620","qty":1.0,"unit_price":6056107.0,"landed_unit_price":6056107.0},{"item_name":"TITLEIST FW GTS3 18.0deg","item_code":"30620","qty":1.0,"unit_price":6056107.0,"landed_unit_price":6056107.0},{"item_name":"ITOBORI IRON STRAIGHT FLUSH POCKET CAVITY 2026 - DLC #DEMO","item_code":"70284","qty":2.0,"unit_price":2715240.0,"landed_unit_price":2715240.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-16'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0091 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0091') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0091', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0091', '2026-07-02', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), Cash On Delivery',
      177814560.00, 'IDR', 177814560.00, 0.00, '[{"item_name":"ITOBORI IRON STRAIGHT FLUSH POCKET CAVITY 2026 - DLC - #5 - #PW","item_code":"30613","qty":6.0,"unit_price":4523904.0,"landed_unit_price":4523904.0},{"item_name":"ITOBORI IRON STRAIGHT FLUSH POCKET CAVITY 2026 - CHROME - #5 - #PW","item_code":"30613","qty":6.0,"unit_price":3962904.0,"landed_unit_price":3962904.0},{"item_name":"ITOBORI IRON STRAIGHT FLUSH CAVITY - BLK BORON - #5 - #PW","item_code":"30458","qty":6.0,"unit_price":3675672.0,"landed_unit_price":3675672.0},{"item_name":"ZL WEDGE - 50deg","item_code":"30461","qty":3.0,"unit_price":1211760.0,"landed_unit_price":1211760.0},{"item_name":"ZL WEDGE - 52deg","item_code":"30461","qty":3.0,"unit_price":1211760.0,"landed_unit_price":1211760.0},{"item_name":"ZL WEDGE - 54deg","item_code":"30461","qty":3.0,"unit_price":1211760.0,"landed_unit_price":1211760.0},{"item_name":"ZL WEDGE - 56deg","item_code":"30461","qty":3.0,"unit_price":1211760.0,"landed_unit_price":1211760.0},{"item_name":"ZL WEDGE - 58deg","item_code":"30461","qty":3.0,"unit_price":1211760.0,"landed_unit_price":1211760.0},{"item_name":"ZL WEDGE - 60deg","item_code":"30461","qty":3.0,"unit_price":1211760.0,"landed_unit_price":1211760.0},{"item_name":"FUJIKURA SHAFT VENTUS BLUE VELOCORE+ 2024 - 5S","item_code":"20176","qty":5.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS BLUE VELOCORE+ 2024 - 5R","item_code":"20176","qty":5.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS BLUE VELOCORE+ 2024 - 6S","item_code":"20176","qty":5.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS BLACK VELOCORE+ 2024 - 5S","item_code":"20176","qty":5.0,"unit_price":3321120.0,"landed_unit_price":3321120.0},{"item_name":"FUJIKURA SHAFT VENTUS BLACK VELOCORE+ 2024 - 6S","item_code":"20176","qty":5.0,"unit_price":3321120.0,"landed_unit_price":3321120.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-02'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0094 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0094') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0094', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0094', '2026-07-08', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), CBD',
      115628832.00, 'IDR', 115628832.00, 0.00, '[{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - FI-5R1","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - FI-5S","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - FI-5X","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - FI-6S","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - FI-6X","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - DI-5S","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - DI-6S","item_code":"20011","qty":5.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - DI-6X","item_code":"20011","qty":2.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"GRAPHITE DESIGN SHAFT TOUR AD - DI-7X","item_code":"20011","qty":1.0,"unit_price":3042864.0,"landed_unit_price":3042864.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-08'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0096 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0096') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0096', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0096', '2026-07-08', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), CBD',
      6049824.00, 'IDR', 6049824.00, 0.00, '[{"item_name":"GRAPHITE DESIGN SHAFT DRIVER TOUR AD FI-4R1","item_code":"20011","qty":1.0,"unit_price":3042864.0,"landed_unit_price":3042864.0},{"item_name":"PXG-MITSUBISHI SHAFT HY/IRON - 60R WHITE","item_code":"20322","qty":2.0,"unit_price":403920.0,"landed_unit_price":403920.0},{"item_name":"PXG-ICON GRIP - MIDSIZE","item_code":"10119","qty":14.0,"unit_price":157080.0,"landed_unit_price":157080.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-08'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0097 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0097') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0097', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0097', '2026-07-09', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), 60 DAYS',
      76421664.00, 'IDR', 76421664.00, 0.00, '[{"item_name":"RODDIO SHAFT DRIVER NP4 - MONO","item_code":"20390","qty":3.0,"unit_price":3554496.0,"landed_unit_price":3554496.0},{"item_name":"RODDIO SHAFT DRIVER NP5 - TRI","item_code":"20390","qty":5.0,"unit_price":3554496.0,"landed_unit_price":3554496.0},{"item_name":"RODDIO SHAFT FW - SUN F4","item_code":"20388","qty":3.0,"unit_price":2073456.0,"landed_unit_price":2073456.0},{"item_name":"RODDIO SHAFT FW - STAR F6","item_code":"20388","qty":3.0,"unit_price":2073456.0,"landed_unit_price":2073456.0},{"item_name":"RODDIO SHAFT FW - MOON F5","item_code":"20388","qty":3.0,"unit_price":2073456.0,"landed_unit_price":2073456.0},{"item_name":"RODDIO SHAFT FW - MOON F6","item_code":"20388","qty":3.0,"unit_price":2073456.0,"landed_unit_price":2073456.0},{"item_name":"RODDIO SHAFT HY - STAR U5","item_code":"20407","qty":3.0,"unit_price":1777248.0,"landed_unit_price":1777248.0},{"item_name":"RODDIO SHAFT IRON - I6 - #5-#PW - 2 SETS","item_code":"20391","qty":12.0,"unit_price":1481040.0,"landed_unit_price":1481040.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-09'::timestamptz, null, null, v_batch
    );
  end if;
  -- INDO-2026-002 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INDO-2026-002') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — INDO-2026-002', 'AE Sports Sdn Bhd (Impact Golf)', 'INDO-2026-002', '2026-05-04', 'Golf Solutions (attn: Mr Jack)', 'International wire (MYR), CBD',
      74630952.00, 'IDR', 74630952.00, 0.00, '[{"item_name":"TITLEIST IRON LIMITED EDITION OIL CAN - T150 - #4-#PW (1 SET)","item_code":"30609","qty":1.0,"unit_price":28274400.0,"landed_unit_price":28274400.0},{"item_name":"PXG FERRULE","item_code":"80001","qty":50.0,"unit_price":6732.0,"landed_unit_price":6732.0},{"item_name":"ADAPTOR - CALLAWAY DR - 0.335","item_code":"60038","qty":25.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"BRAMPTON INTERTAPE (44 KG)","item_code":"22003","qty":44.0,"unit_price":385968.0,"landed_unit_price":385968.0},{"item_name":"ADAPTOR - CALLAWAY FW - 0.335","item_code":"60038","qty":25.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"FERRULE - CALLAWAY DRIVER - 0.335","item_code":"40005","qty":50.0,"unit_price":4488.0,"landed_unit_price":4488.0},{"item_name":"ADAPTOR - PING DR G440 - 0.335","item_code":"60038","qty":30.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"ADAPTOR - PING HY G430 - 0.370","item_code":"60038","qty":15.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"ADAPTOR - TITLEIST DR - 0.335","item_code":"60038","qty":25.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"ADAPTOR - TITLEIST FW - 0.335","item_code":"60038","qty":10.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"ADAPTOR - TITLEIST HY - 0.370","item_code":"60038","qty":10.0,"unit_price":121176.0,"landed_unit_price":121176.0},{"item_name":"UNIVERSAL WRENCH GOLF","item_code":"60279","qty":10.0,"unit_price":197472.0,"landed_unit_price":197472.0},{"item_name":"GRAPHITE EXTENDER 0.490 INCH","item_code":"60089","qty":50.0,"unit_price":31416.0,"landed_unit_price":31416.0},{"item_name":"GRAPHITE EXTENDER 0.550 INCH","item_code":"60089","qty":50.0,"unit_price":31416.0,"landed_unit_price":31416.0},{"item_name":"LEAD TAPE - 2G","item_code":"22005","qty":30.0,"unit_price":224400.0,"landed_unit_price":224400.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-05-04'::timestamptz, null, null, v_batch
    );
  end if;
  -- 045P08IN (PT Panamas Mitra Sejahtera)
  if not exists (select 1 from public.payment_requests where ref_number = '045P08IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|833.5299.911' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Panamas Mitra Sejahtera — 045P08IN', 'PT Panamas Mitra Sejahtera', '045P08IN', '2026-08-13', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      280000.00, 'IDR', 280000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":280000.0,"landed_unit_price":280000.0}]'::jsonb, null,
      'BCA', 'PT Panamas Mitra Sejahtera', '833.5299.911', 'Part of the same bulk BCA transfer as 115P06IN - see that row''s note. Status ''Dalam Proses'' at time of screenshot - confirm completion. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-13'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- 064T07IN (PT Tirta Mandiri Sukses)
  if not exists (select 1 from public.payment_requests where ref_number = '064T07IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|061.300.7579' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Tirta Mandiri Sukses — 064T07IN', 'PT Tirta Mandiri Sukses', '064T07IN', '2026-07-07', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      1960000.00, 'IDR', 1960000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":1960000.0,"landed_unit_price":1960000.0}]'::jsonb, null,
      'BCA', 'PT Tirta Mandiri Sukses', '061.300.7579', 'Part of a single BCA transfer to PT Tirta Mandiri Sukses (061-3007579), Rp6,160,000.00, sent 20 Aug 2026 21:17:56, Ref No. 26082000232675. Covers 280T06IN + 064T07IN + 074T07IN + 170T07IN exactly (1,680,000 + 1,960,000 + 1,680,000 + 840,000 = 6,160,000). Bank screenshot shows transfer status ''Dalam Proses'' (in process, not yet ''Berhasil'') as of the screenshot - confirm completion before treating as final. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-07'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- 074T07IN (PT Tirta Mandiri Sukses)
  if not exists (select 1 from public.payment_requests where ref_number = '074T07IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|061.300.7579' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Tirta Mandiri Sukses — 074T07IN', 'PT Tirta Mandiri Sukses', '074T07IN', '2026-07-09', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      1680000.00, 'IDR', 1680000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":1680000.0,"landed_unit_price":1680000.0}]'::jsonb, null,
      'BCA', 'PT Tirta Mandiri Sukses', '061.300.7579', 'Part of the same bulk BCA transfer as 064T07IN - see that row''s note. Status ''Dalam Proses'' at time of screenshot - confirm completion. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-09'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- 089P07IN (PT Panamas Mitra Sejahtera)
  if not exists (select 1 from public.payment_requests where ref_number = '089P07IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|833.5299.911' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Panamas Mitra Sejahtera — 089P07IN', 'PT Panamas Mitra Sejahtera', '089P07IN', '2026-07-20', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      280000.00, 'IDR', 280000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":280000.0,"landed_unit_price":280000.0}]'::jsonb, null,
      'BCA', 'PT Panamas Mitra Sejahtera', '833.5299.911', 'Part of the same bulk BCA transfer as 115P06IN - see that row''s note. Status ''Dalam Proses'' at time of screenshot - confirm completion. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-20'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- 115P06IN (PT Panamas Mitra Sejahtera)
  if not exists (select 1 from public.payment_requests where ref_number = '115P06IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|833.5299.911' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Panamas Mitra Sejahtera — 115P06IN', 'PT Panamas Mitra Sejahtera', '115P06IN', '2026-06-25', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      280000.00, 'IDR', 280000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":280000.0,"landed_unit_price":280000.0}]'::jsonb, null,
      'BCA', 'PT Panamas Mitra Sejahtera', '833.5299.911', 'Part of a single BCA transfer to PT Panamas Mitra Sejahtera (833-5299911), Rp840,000.00, sent 20 Aug 2026 21:17:22, Ref No. 26082000232563. Covers 115P06IN + 089P07IN + 045P08IN exactly (280,000 x 3 = 840,000). Bank screenshot shows transfer status ''Dalam Proses'' (in process, not yet ''Berhasil'') as of the screenshot - confirm completion before treating as final. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-25'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- 170T07IN (PT Tirta Mandiri Sukses)
  if not exists (select 1 from public.payment_requests where ref_number = '170T07IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|061.300.7579' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Tirta Mandiri Sukses — 170T07IN', 'PT Tirta Mandiri Sukses', '170T07IN', '2026-07-28', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      840000.00, 'IDR', 840000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":840000.0,"landed_unit_price":840000.0}]'::jsonb, null,
      'BCA', 'PT Tirta Mandiri Sukses', '061.300.7579', 'Part of the same bulk BCA transfer as 064T07IN - see that row''s note. Status ''Dalam Proses'' at time of screenshot - confirm completion. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-28'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- 280T06IN (PT Tirta Mandiri Sukses)
  if not exists (select 1 from public.payment_requests where ref_number = '280T06IN') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-20|061.300.7579' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Tirta Mandiri Sukses — 280T06IN', 'PT Tirta Mandiri Sukses', '280T06IN', '2026-06-30', 'Vincent (Golf Solutions freight consolidator, MST/VSF Golf - 0877)', 'Bank Transfer, Net 30th after EOM',
      1680000.00, 'IDR', 1680000.00, 0.00, '[{"item_name":"Batam import freight/consolidation charge (P/D General Cargo)","item_code":"N/A","qty":1.0,"unit_price":1680000.0,"landed_unit_price":1680000.0}]'::jsonb, null,
      'BCA', 'PT Tirta Mandiri Sukses', '061.300.7579', 'Part of the same bulk BCA transfer as 064T07IN - see that row''s note. Status ''Dalam Proses'' at time of screenshot - confirm completion. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-30'::timestamptz, '2026-08-20'::timestamptz, v_user, v_batch
    );
  end if;
  -- IN26050560 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'IN26050560') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — IN26050560', 'C & G Express Pte Ltd', 'IN26050560', '2026-05-01', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      1455294.00, 'IDR', 1455294.00, 0.00, '[{"item_name":"International freight forwarding / duty / GST / export permit charge (SGD 123.33)","item_code":"N/A","qty":1.0,"unit_price":1455294.0,"landed_unit_price":1455294.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-05-01'::timestamptz, null, null, v_batch
    );
  end if;
  -- IN26060670 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'IN26060670') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — IN26060670', 'C & G Express Pte Ltd', 'IN26060670', '2026-06-29', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      5129106.00, 'IDR', 5129106.00, 0.00, '[{"item_name":"International freight forwarding / duty / GST / export permit charge (SGD 434.67)","item_code":"N/A","qty":1.0,"unit_price":5129106.0,"landed_unit_price":5129106.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-29'::timestamptz, null, null, v_batch
    );
  end if;
  -- IN26070032 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'IN26070032') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — IN26070032', 'C & G Express Pte Ltd', 'IN26070032', '2026-07-01', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      472000.00, 'IDR', 472000.00, 0.00, '[{"item_name":"International freight forwarding / duty / GST / export permit charge (SGD 40.00)","item_code":"N/A","qty":1.0,"unit_price":472000.0,"landed_unit_price":472000.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-01'::timestamptz, null, null, v_batch
    );
  end if;
  -- IN26070695 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'IN26070695') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — IN26070695', 'C & G Express Pte Ltd', 'IN26070695', '2026-07-07', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      1652000.00, 'IDR', 1652000.00, 0.00, '[{"item_name":"International freight forwarding / duty / GST / export permit charge (SGD 140.00)","item_code":"N/A","qty":1.0,"unit_price":1652000.0,"landed_unit_price":1652000.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-07'::timestamptz, null, null, v_batch
    );
  end if;
  -- IN26070696 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'IN26070696') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — IN26070696', 'C & G Express Pte Ltd', 'IN26070696', '2026-07-20', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      531000.00, 'IDR', 531000.00, 0.00, '[{"item_name":"International freight forwarding / duty / GST / export permit charge (SGD 45.00)","item_code":"N/A","qty":1.0,"unit_price":531000.0,"landed_unit_price":531000.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-07-20'::timestamptz, null, null, v_batch
    );
  end if;
  -- LCIN26010490 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'LCIN26010490') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — LCIN26010490', 'C & G Express Pte Ltd', 'LCIN26010490', '2026-01-22', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      472000.00, 'IDR', 472000.00, 0.00, '[{"item_name":"International freight forwarding charge (SGD 40.00)","item_code":"N/A","qty":1.0,"unit_price":472000.0,"landed_unit_price":472000.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-01-22'::timestamptz, null, null, v_batch
    );
  end if;
  -- LCIN26010660 (C & G Express Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'LCIN26010660') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'C & G Express Pte Ltd — LCIN26010660', 'C & G Express Pte Ltd', 'LCIN26010660', '2026-01-27', 'Vincent (Golf Solutions freight forwarding)', 'International wire (SGD), C.O.D',
      531000.00, 'IDR', 4757996.00, 4226996.00, '[{"item_name":"International freight forwarding charge (SGD 403.22 less SGD 358.22 credit note)","item_code":"N/A","qty":1.0,"unit_price":531000.0,"landed_unit_price":531000.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'C & G Express Pte Ltd', '012-900435-9', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-01-27'::timestamptz, null, null, v_batch
    );
  end if;
  -- INV-0826-004 (Point Leo Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV-0826-004') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-08-31|0721400057' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Point Leo Pte Ltd — INV-0826-004', 'Point Leo Pte Ltd', 'INV-0826-004', '2026-08-28', 'CV. Teknologi Keahlian Olahraga Golf', 'International wire (USD), Due on Receipt',
      57435052.00, 'IDR', 60457950.00, 3022898.00, '[{"item_name":"MIURA RH KM008 V2 PUTTER CHROME (BUILD)","item_code":"N/A","qty":3.0,"unit_price":19145017.3333333,"landed_unit_price":19145017.3333333}]'::jsonb, null,
      'DBS Singapore Pte Ltd', 'Point Leo Pte Ltd', '0721400057', 'BRIfast wire USD 3,217.65 (31 Aug 2026, Ref 218702008431691, UETR dea8a07b-bbe7-4b6e-82ae-015a1efb2e97) matching this invoice exactly. Remittance advice: Nominal Debet IDR 57,435,052.50 (exact rate 17,850 IDR/USD), fee IDR 535,500, Total Debet IDR 57,970,552.50 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-28'::timestamptz, '2026-08-31'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2025.12.00063 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2025.12.00063') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2025.12.00063', 'CV Matkos Mandiri Utama', 'SI.2025.12.00063', '2025-12-22', 'Golf Solution Jacky Safriano', 'C.O.D',
      2263500.00, 'IDR', 3130000.00, 942500.00, '[{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70R","item_code":"100771","qty":1.0,"unit_price":2187500.0,"landed_unit_price":2263500.0},{"item_name":"Box Golfshafts 5x5","item_code":"100004","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0}]'::jsonb, '[{"name":"Other fee","amount":76000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2025-12-22'::timestamptz, '2025-12-22'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.01.00003 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.01.00003') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.01.00003', 'CV Matkos Mandiri Utama', 'SI.2026.01.00003', '2026-01-02', 'Golf Solution Jacky Safriano', 'C.O.D',
      5162500.00, 'IDR', 7375000.00, 2212500.00, '[{"item_name":"Fujikura Ventus Blue VeloCore Plus 2024 7S Wood","item_code":"100684","qty":1.0,"unit_price":2975000.0,"landed_unit_price":2975000.0},{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70S","item_code":"100772","qty":1.0,"unit_price":2187500.0,"landed_unit_price":2187500.0}]'::jsonb, null,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-01-02'::timestamptz, '2026-01-02'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.01.00041 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.01.00041') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.01.00041', 'CV Matkos Mandiri Utama', 'SI.2026.01.00041', '2026-01-15', 'Golf Solution Jacky Safriano', 'C.O.D',
      2447200.00, 'IDR', 3416000.00, 1024800.00, '[{"item_name":"NS Pro Zelos 8 Taper Iron Set #5-PW R","item_code":"100451","qty":1.0,"unit_price":2391200.0,"landed_unit_price":2447200.0}]'::jsonb, '[{"name":"Other fee","amount":56000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-01-15'::timestamptz, '2026-01-15'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.01.00046 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.01.00046') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.01.00046', 'CV Matkos Mandiri Utama', 'SI.2026.01.00046', '2026-01-17', 'Golf Solution Jacky Safriano', 'C.O.D',
      2461570.00, 'IDR', 3415100.00, 1024530.00, '[{"item_name":"NS Pro GH 950 Neo #5-PW STIFF Iron Set Taper","item_code":"100556","qty":1.0,"unit_price":2390570.0,"landed_unit_price":2461570.0}]'::jsonb, '[{"name":"Other fee","amount":71000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-01-17'::timestamptz, '2026-01-17'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.01.00048 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.01.00048') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.01.00048', 'CV Matkos Mandiri Utama', 'SI.2026.01.00048', '2026-01-19', 'Golf Solution Jacky Safriano', 'C.O.D',
      3359000.00, 'IDR', 4700000.00, 1410000.00, '[{"item_name":"KBS PGI 80 Parallel Iron Graphite Shaft","item_code":"100785","qty":4.0,"unit_price":822500.0,"landed_unit_price":839750.0}]'::jsonb, '[{"name":"Other fee","amount":69000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-01-19'::timestamptz, '2026-01-19'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.01.00071 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.01.00071') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.01.00071', 'CV Matkos Mandiri Utama', 'SI.2026.01.00071', '2026-01-27', 'Golf Solution Jacky Safriano', 'C.O.D',
      453880.00, 'IDR', 623400.00, 187020.00, '[{"item_name":"NS Pro Modus 3 Tour 105 #4 STIFF Taper Tip","item_code":"100620","qty":1.0,"unit_price":436380.0,"landed_unit_price":453880.0}]'::jsonb, '[{"name":"Other fee","amount":17500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-01-27'::timestamptz, '2026-01-27'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.02.00011 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.02.00011') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.02.00011', 'CV Matkos Mandiri Utama', 'SI.2026.02.00011', '2026-02-05', 'Golf Solution Jacky Safriano', 'C.O.D',
      4129500.00, 'IDR', 5875000.00, 1762500.00, '[{"item_name":"KBS PGI 60 Parallel Iron Graphite Shaft","item_code":"100610","qty":5.0,"unit_price":822500.0,"landed_unit_price":825900.0}]'::jsonb, '[{"name":"Other fee","amount":17000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-02-05'::timestamptz, '2026-02-05'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.02.00051 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.02.00051') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.02.00051', 'CV Matkos Mandiri Utama', 'SI.2026.02.00051', '2026-02-16', 'Golf Solution Jacky Safriano', 'C.O.D',
      137200.00, 'IDR', 196000.00, 58800.00, '[{"item_name":"Iomic iX Touch 2.0 Black-cap red","item_code":"100222","qty":1.0,"unit_price":137200.0,"landed_unit_price":137200.0}]'::jsonb, null,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-02-16'::timestamptz, '2026-02-16'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00002 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00002') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00002', 'CV Matkos Mandiri Utama', 'SI.2026.03.00002', '2026-03-02', 'Golf Solution Jacky Safriano', 'C.O.D',
      823200.00, 'IDR', 1176000.00, 352800.00, '[{"item_name":"Iomic iXX 2.3 Black-cap black","item_code":"100224","qty":6.0,"unit_price":137200.0,"landed_unit_price":137200.0}]'::jsonb, null,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-02'::timestamptz, '2026-03-02'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00014 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00014') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00014', 'CV Matkos Mandiri Utama', 'SI.2026.03.00014', '2026-03-06', 'Golf Solution Jacky Safriano', 'C.O.D',
      891500.00, 'IDR', 1175000.00, 352500.00, '[{"item_name":"KBS PGI 80 Parallel Iron Graphite Shaft","item_code":"100785","qty":1.0,"unit_price":822500.0,"landed_unit_price":891500.0}]'::jsonb, '[{"name":"Other fee","amount":69000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-06'::timestamptz, '2026-03-06'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00016 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00016') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00016', 'CV Matkos Mandiri Utama', 'SI.2026.03.00016', '2026-03-07', 'Golf Solution Jacky Safriano', 'C.O.D',
      841000.00, 'IDR', 1175000.00, 352500.00, '[{"item_name":"KBS PGI 80 Parallel Iron Graphite Shaft","item_code":"100785","qty":1.0,"unit_price":822500.0,"landed_unit_price":841000.0}]'::jsonb, '[{"name":"Other fee","amount":18500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-07'::timestamptz, '2026-03-07'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00021 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00021') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00021', 'CV Matkos Mandiri Utama', 'SI.2026.03.00021', '2026-03-09', 'Golf Solution Jacky Safriano', 'C.O.D',
      1372000.00, 'IDR', 1960000.00, 588000.00, '[{"item_name":"Iomic iXX 2.3 Black-cap black","item_code":"100224","qty":10.0,"unit_price":137200.0,"landed_unit_price":137200.0}]'::jsonb, null,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-09'::timestamptz, '2026-03-09'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00048 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00048') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00048', 'CV Matkos Mandiri Utama', 'SI.2026.03.00048', '2026-03-27', 'Golf Solution Jacky Safriano', 'C.O.D',
      4935000.00, 'IDR', 7055000.00, 2120000.00, '[{"item_name":"KBS PGI 70 Parallel Iron Graphite Shaft","item_code":"100611","qty":6.0,"unit_price":822500.0,"landed_unit_price":822500.0},{"item_name":"Box Golfshafts 5x5","item_code":"100004","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0}]'::jsonb, null,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-27'::timestamptz, '2026-03-27'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00062 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00062') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00062', 'CV Matkos Mandiri Utama', 'SI.2026.03.00062', '2026-03-31', 'Golf Solution Jacky Safriano', 'C.O.D',
      1520000.00, 'IDR', 2155000.00, 650000.00, '[{"item_name":"KBS TGI 80 Tour Parallel Iron Graphite","item_code":"100786","qty":2.0,"unit_price":752500.0,"landed_unit_price":760000.0},{"item_name":"Box Golfshafts 5x5","item_code":"100004","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0}]'::jsonb, '[{"name":"Other fee","amount":15000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-31'::timestamptz, '2026-03-31'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.03.00063 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.03.00063') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.03.00063', 'CV Matkos Mandiri Utama', 'SI.2026.03.00063', '2026-03-31', 'Golf Solution Jacky Safriano', 'C.O.D',
      236000.00, 'IDR', 315000.00, 94500.00, '[{"item_name":"Iomic Putter Absolute Pink","item_code":"100232","qty":1.0,"unit_price":220500.0,"landed_unit_price":236000.0}]'::jsonb, '[{"name":"Other fee","amount":15500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-03-31'::timestamptz, '2026-03-31'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.04.00027 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.04.00027') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.04.00027', 'CV Matkos Mandiri Utama', 'SI.2026.04.00027', '2026-04-07', 'Golf Solution Jacky Safriano', 'C.O.D',
      5006000.00, 'IDR', 7050000.00, 2115000.00, '[{"item_name":"KBS PGI 70 Parallel Iron Graphite Shaft","item_code":"100611","qty":6.0,"unit_price":822500.0,"landed_unit_price":834333.333333333}]'::jsonb, '[{"name":"Other fee","amount":71000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-04-07'::timestamptz, '2026-04-07'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.04.00030 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.04.00030') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.04.00030', 'CV Matkos Mandiri Utama', 'SI.2026.04.00030', '2026-04-09', 'Golf Solution Jacky Safriano', 'C.O.D',
      1388000.00, 'IDR', 1960000.00, 588000.00, '[{"item_name":"Iomic Sticky 2.3 Black- Black cap","item_code":"100250","qty":10.0,"unit_price":137200.0,"landed_unit_price":138800.0}]'::jsonb, '[{"name":"Other fee","amount":16000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-04-09'::timestamptz, '2026-04-09'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.04.00059 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.04.00059') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.04.00059', 'CV Matkos Mandiri Utama', 'SI.2026.04.00059', '2026-04-18', 'Golf Solution Jacky Safriano', 'C.O.D',
      3092000.00, 'IDR', 4300000.00, 1290000.00, '[{"item_name":"KBS TGI 70 Tour Parallel Iron Graphite","item_code":"100615","qty":4.0,"unit_price":752500.0,"landed_unit_price":773000.0}]'::jsonb, '[{"name":"Other fee","amount":82000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-04-18'::timestamptz, '2026-04-18'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.04.00074 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.04.00074') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.04.00074', 'CV Matkos Mandiri Utama', 'SI.2026.04.00074', '2026-04-23', 'Golf Solution Jacky Safriano', 'C.O.D',
      457000.00, 'IDR', 630000.00, 189000.00, '[{"item_name":"Iomic Putter Sticky Black","item_code":"100240","qty":2.0,"unit_price":220500.0,"landed_unit_price":228500.0}]'::jsonb, '[{"name":"Other fee","amount":16000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-04-23'::timestamptz, '2026-04-23'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.05.00019 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.05.00019') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.05.00019', 'CV Matkos Mandiri Utama', 'SI.2026.05.00019', '2026-05-06', 'Golf Solution Jacky Safriano', 'C.O.D',
      1576000.00, 'IDR', 2150000.00, 645000.00, '[{"item_name":"KBS TGI 70 Tour Parallel Iron Graphite","item_code":"100615","qty":2.0,"unit_price":752500.0,"landed_unit_price":788000.0}]'::jsonb, '[{"name":"Other fee","amount":71000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-06'::timestamptz, '2026-05-06'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.05.00040 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.05.00040') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.05.00040', 'CV Matkos Mandiri Utama', 'SI.2026.05.00040', '2026-05-13', 'Golf Solution Jacky Safriano', 'C.O.D',
      5002500.00, 'IDR', 7050000.00, 2115000.00, '[{"item_name":"KBS PGI 70 Parallel Iron Graphite Shaft","item_code":"100611","qty":6.0,"unit_price":822500.0,"landed_unit_price":833750.0}]'::jsonb, '[{"name":"Other fee","amount":67500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-13'::timestamptz, '2026-05-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.05.00065 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.05.00065') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.05.00065', 'CV Matkos Mandiri Utama', 'SI.2026.05.00065', '2026-05-28', 'Golf Solution Jacky Safriano', 'C.O.D',
      1100000.00, 'IDR', 1470000.00, 441000.00, '[{"item_name":"Fujikura AXIOM 75 SP (Short Iron) STIFF Iron Graphite","item_code":"100588","qty":1.0,"unit_price":1029000.0,"landed_unit_price":1100000.0}]'::jsonb, '[{"name":"Other fee","amount":71000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-28'::timestamptz, '2026-05-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.05.00067 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.05.00067') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.05.00067', 'CV Matkos Mandiri Utama', 'SI.2026.05.00067', '2026-05-28', 'Golf Solution Jacky Safriano', 'C.O.D',
      843200.00, 'IDR', 1176000.00, 352800.00, '[{"item_name":"Iomic iXX 2.3 Black-cap black","item_code":"100224","qty":6.0,"unit_price":137200.0,"landed_unit_price":140533.333333333}]'::jsonb, '[{"name":"Other fee","amount":20000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-28'::timestamptz, '2026-05-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.05.00069 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.05.00069') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.05.00069', 'CV Matkos Mandiri Utama', 'SI.2026.05.00069', '2026-05-28', 'Golf Solution Jacky Safriano', 'C.O.D',
      3045000.00, 'IDR', 4250000.00, 1275000.00, '[{"item_name":"Graphite Design TourAD DI Black 6S Wood","item_code":"100751","qty":1.0,"unit_price":2975000.0,"landed_unit_price":3045000.0}]'::jsonb, '[{"name":"Other fee","amount":70000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-28'::timestamptz, '2026-05-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.05.00079 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.05.00079') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.05.00079', 'CV Matkos Mandiri Utama', 'SI.2026.05.00079', '2026-05-28', 'Golf Solution Jacky Safriano', 'C.O.D',
      1030400.00, 'IDR', 1372000.00, 411600.00, '[{"item_name":"Iomic Sticky Ladies RIBBED SkyBlue-white Cap","item_code":"100647","qty":7.0,"unit_price":137200.0,"landed_unit_price":147200.0}]'::jsonb, '[{"name":"Other fee","amount":70000.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-28'::timestamptz, '2026-05-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.06.00009 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.06.00009') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.06.00009', 'CV Matkos Mandiri Utama', 'SI.2026.06.00009', '2026-06-02', 'Golf Solution Jacky Safriano', 'C.O.D',
      2254000.00, 'IDR', 3125000.00, 937500.00, '[{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70R","item_code":"100771","qty":1.0,"unit_price":2187500.0,"landed_unit_price":2254000.0}]'::jsonb, '[{"name":"Other fee","amount":66500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-06-02'::timestamptz, '2026-06-02'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.06.00026 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.06.00026') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.06.00026', 'CV Matkos Mandiri Utama', 'SI.2026.06.00026', '2026-06-11', 'Golf Solution Jacky Safriano', 'C.O.D',
      3102500.00, 'IDR', 4410000.00, 1323000.00, '[{"item_name":"NS Pro Zelos 7 #4 REG Taper","item_code":"100372","qty":1.0,"unit_price":441000.0,"landed_unit_price":443214.285714286},{"item_name":"NS Pro Zelos 7 #5-PW REG Taper iron set","item_code":"100450","qty":1.0,"unit_price":2646000.0,"landed_unit_price":2659285.71428571}]'::jsonb, '[{"name":"Other fee","amount":15500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-06-11'::timestamptz, '2026-06-11'::timestamptz, v_user, v_batch
    );
  end if;
  -- SI.2026.06.00033 (CV Matkos Mandiri Utama)
  if not exists (select 1 from public.payment_requests where ref_number = 'SI.2026.06.00033') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CV Matkos Mandiri Utama — SI.2026.06.00033', 'CV Matkos Mandiri Utama', 'SI.2026.06.00033', '2026-06-12', 'Golf Solution Jacky Safriano', 'C.O.D',
      2255000.00, 'IDR', 3125000.00, 937500.00, '[{"item_name":"Fujikura Ventus Hybrid BLUE Velocore plus 70R","item_code":"100771","qty":1.0,"unit_price":2187500.0,"landed_unit_price":2255000.0}]'::jsonb, '[{"name":"Other fee","amount":67500.0}]'::jsonb,
      'BCA', 'CV Matkos Mandiri Utama', '5005635303', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-06-12'::timestamptz, '2026-06-12'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2025/003094 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2025/003094') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2025/003094', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2025/003094', '2025-11-11', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      3152000.00, 'IDR', 3940000.00, 788000.00, '[{"item_name":"NS IR SET SHAFT PRO ZELOS 8 REG #5P","item_code":"N/A","qty":1.0,"unit_price":3152000.0,"landed_unit_price":3152000.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2025-11-11'::timestamptz, '2025-11-11'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2025/003102 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2025/003102') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2025/003102', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2025/003102', '2025-11-13', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      1704000.00, 'IDR', 2400000.00, 696000.00, '[{"item_name":"TITLEIST BALL PRO V1 25","item_code":"T2029S","qty":2.0,"unit_price":852000.0,"landed_unit_price":852000.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2025-11-13'::timestamptz, '2025-11-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2026/000187 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2026/000187') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2026/000187', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2026/000187', '2026-01-15', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      4364500.00, 'IDR', 14924000.00, 10559500.00, '[{"item_name":"MIURA WG HEAD FORGED CHRME YG 54","item_code":"N/A","qty":1.0,"unit_price":4364500.0,"landed_unit_price":4364500.0},{"item_name":"MIURA WG HEAD FORGED CHRME CG 58 (FREE - 100% disc)","item_code":"N/A","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"GP GRIP CP2 PRO STANDARD 60R BLACK (FREE - 100% disc)","item_code":"GGPSSRBPR006R","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"CALLAWAY DR HEAD ELYTE MAX FAST 9.5 (FREE - 100% disc)","item_code":"4L09","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"CALLAWAY DR SHAFT LINQ STF 40 (FREE)","item_code":"4L091570Y300","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-01-15'::timestamptz, '2026-01-15'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2026/000382 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2026/000382') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2026/000382', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2026/000382', '2026-02-05', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      5000000.00, 'IDR', 5000000.00, 0.00, '[{"item_name":"MIURA DR COVER X DORMIE 2025 SE DRAGON (LIMITED EDITION, normal price 6,500,000)","item_code":"N/A","qty":1.0,"unit_price":5000000.0,"landed_unit_price":5000000.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-02-05'::timestamptz, '2026-02-05'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2026/000430 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2026/000430') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2026/000430', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2026/000430', '2026-02-09', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      17722000.00, 'IDR', 20940000.00, 3218000.00, '[{"item_name":"MITSUBISHI CHEMICAL IR SET MMT TAPER 95S 5P","item_code":"N/A","qty":1.0,"unit_price":7225000.0,"landed_unit_price":7225000.0},{"item_name":"BUSHNELL PRO X3+ RANGEFINDER","item_code":"N/A","qty":1.0,"unit_price":9265000.0,"landed_unit_price":9265000.0},{"item_name":"GP GRIP CPX 60R","item_code":"GGPSSRBPX006R","qty":7.0,"unit_price":176000.0,"landed_unit_price":176000.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-02-09'::timestamptz, '2026-02-09'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2026/001876 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2026/001876') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2026/001876', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2026/001876', '2026-05-21', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      8992000.00, 'IDR', 11240000.00, 2248000.00, '[{"item_name":"CALLAWAY DR QUANTUM TD MAX GR JV (9.0, STF, TENSEI GRY 60)","item_code":"4N409088W300","qty":1.0,"unit_price":8792000.0,"landed_unit_price":8792000.0},{"item_name":"GP GRIP MIDSIZE MCC TEAMS (LIGHT BLUE/WHITE)","item_code":"GGPMSNDMTLB6R","qty":1.0,"unit_price":200000.0,"landed_unit_price":200000.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-05-21'::timestamptz, '2026-05-21'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2026/002373 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2026/002373') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2026/002373', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2026/002373', '2026-06-15', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      7342000.00, 'IDR', 10620000.00, 3278000.00, '[{"item_name":"MIURA GRIP LAMKIN","item_code":"N/A","qty":20.0,"unit_price":192000.0,"landed_unit_price":192000.0},{"item_name":"ROMARO WG HEAD ALCOBACA (58)","item_code":"N/A","qty":1.0,"unit_price":1759500.0,"landed_unit_price":1759500.0},{"item_name":"ROMARO WG HEAD RAY SX-R 22 (50)","item_code":"N/A","qty":1.0,"unit_price":1742500.0,"landed_unit_price":1742500.0},{"item_name":"SHIMADA IR SHAFT K''S NINE9 STF #PW (FREE - 100% disc)","item_code":"N/A","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"SHIMADA IR SHAFT K''S NINE9 STF #PW (FREE - 100% disc) [2nd]","item_code":"N/A","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"ELITE GRIP X360 RUBBER M60 CR NBL (FREE - 100% disc)","item_code":"N/A","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"ELITE GRIP X360 RUBBER M60 CR NBL (FREE - 100% disc) [2nd]","item_code":"N/A","qty":1.0,"unit_price":0.0,"landed_unit_price":0.0},{"item_name":"FR TGF001 0.355 inch (FREE)","item_code":"TGF001","qty":2.0,"unit_price":0.0,"landed_unit_price":0.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-06-15'::timestamptz, '2026-06-15'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/2026/002758 (PT Leonian Golf Indonesia (Leo Golf))
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/2026/002758') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT Leonian Golf Indonesia (Leo Golf) — INV/2026/002758', 'PT Leonian Golf Indonesia (Leo Golf)', 'INV/2026/002758', '2026-06-29', 'CV. Teknologi Keahlian Olahraga Golf', 'Immediate Payment',
      400000.00, 'IDR', 500000.00, 100000.00, '[{"item_name":"GP GRIP MCC TEAMS 60R (LIGHT BLUE/WHITE)","item_code":"GGPSSNDMTLB6R","qty":2.0,"unit_price":200000.0,"landed_unit_price":200000.0}]'::jsonb, null,
      'BCA', 'PT. Leonian Golf Indonesia', '5250307855', 'User-confirmed PAID (2026-08-29): no transfer receipt/date on file - Amount Paid set equal to the invoice total (domestic BCA transfers carry no fee); attach the payment proof and date if it surfaces. | Imported from GS Purchasing compilation. Payment date not recorded in the source.',
      'approved', v_user, '2026-06-29'::timestamptz, '2026-06-29'::timestamptz, v_user, v_batch
    );
  end if;
  -- 42158-1 (OLJ International USA Inc (dba CA Golf Center))
  if not exists (select 1 from public.payment_requests where ref_number = '42158-1') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-02-12|000466644188' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'OLJ International USA Inc (dba CA Golf Center) — 42158-1', 'OLJ International USA Inc (dba CA Golf Center)', '42158-1', '2026-01-14', 'Golf Solutions (Soho Manhattan PIK 2)', 'International wire (USD)',
      6826469.00, 'IDR', 7632510.00, 1602912.00, '[{"item_name":"CALLAWAY HBD REVA RISE 8H RH UST LINQ 45 GR WMS","item_code":"N/A","qty":1.0,"unit_price":3014799.0,"landed_unit_price":3413234.5},{"item_name":"CALLAWAY HBD REVA RISE 9H RH UST LINQ 45 GR WMS","item_code":"N/A","qty":1.0,"unit_price":3014799.0,"landed_unit_price":3413234.5}]'::jsonb, '[{"name":"Other fee","amount":796871.0}]'::jsonb,
      'Bank of America (BOFAUS3N)', 'OLJ International U.S.A. Inc. (dba CA Golf Center)', '000466644188', 'Part of one BRIfast wire of USD 13,202.65 (12 Feb 2026, Ref 218702006636691) covering 42158-1+42159-1+42159-2 exactly. Remittance advice now on file: Nominal Debet IDR 224,180,997.00 (exact rate 16,980 IDR/USD), wire fee IDR 594,300 (charged once for the whole wire, included in THIS row''s Amount Paid per the wire-fee rule), Total Debet IDR 224,775,297.00. This row''s Amount Paid = its USD share (402.03 x 16,980 = 6,826,469) + the full fee. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-01-14'::timestamptz, '2026-02-12'::timestamptz, v_user, v_batch
    );
  end if;
  -- 42159-1 (OLJ International USA Inc (dba CA Golf Center))
  if not exists (select 1 from public.payment_requests where ref_number = '42159-1') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-02-12|000466644188' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'OLJ International USA Inc (dba CA Golf Center) — 42159-1', 'OLJ International USA Inc (dba CA Golf Center)', '42159-1', '2026-01-27', 'Golf Solutions (Soho Manhattan PIK 2)', 'International wire (USD)',
      3879930.00, 'IDR', 4329900.00, 1082475.00, '[{"item_name":"TAYLORMADE HBD MWR-Drax Max 7-34/Rh R","item_code":"N/A","qty":1.0,"unit_price":3247425.0,"landed_unit_price":3879930.0}]'::jsonb, '[{"name":"Other fee","amount":632505.0}]'::jsonb,
      'Bank of America (BOFAUS3N)', 'OLJ International U.S.A. Inc. (dba CA Golf Center)', '000466644188', 'Share of the same 12 Feb wire as 42158-1: USD 228.50 x 16,980 = IDR 3,879,930 (fee carried on 42158-1''s row). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-01-27'::timestamptz, '2026-02-12'::timestamptz, v_user, v_batch
    );
  end if;
  -- 42159-2 (OLJ International USA Inc (dba CA Golf Center))
  if not exists (select 1 from public.payment_requests where ref_number = '42159-2') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-02-12|000466644188' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'OLJ International USA Inc (dba CA Golf Center) — 42159-2', 'OLJ International USA Inc (dba CA Golf Center)', '42159-2', '2026-01-27', 'Golf Solutions (Soho Manhattan PIK 2)', 'International wire (USD)',
      213475442.00, 'IDR', 266288850.00, 66571283.00, '[{"item_name":"TAYLORMADE DRV MWD-Drax Tour MR60 8.0/RhX","item_code":"N/A","qty":4.0,"unit_price":7036087.5,"landed_unit_price":7520780.02739326},{"item_name":"TAYLORMADE DRV MWD-Drax Tour-LR60 8.0/RhX","item_code":"N/A","qty":3.0,"unit_price":7036115.66666667,"landed_unit_price":7520810.13436736},{"item_name":"TAYLORMADE DRV MWD-Drax MR50 8.0/Rh X","item_code":"N/A","qty":7.0,"unit_price":7036099.57142857,"landed_unit_price":7520792.93038216},{"item_name":"TAYLORMADE FWD MWF-Drax Tour #7/Rh S","item_code":"N/A","qty":5.0,"unit_price":4871154.4,"landed_unit_price":5206711.92930287},{"item_name":"TAYLORMADE FWD MWF-Drax Max #9/Rh R","item_code":"N/A","qty":3.0,"unit_price":4113405.0,"landed_unit_price":4396763.70832221},{"item_name":"TAYLORMADE FWD MWF-Drax Max #9/Rh A","item_code":"N/A","qty":2.0,"unit_price":4113405.0,"landed_unit_price":4396763.70832221},{"item_name":"TAYLORMADE DRV MWD-Drax Tour MR60 9.0/RhX","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax Tour-MR60 10.5/RhS","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax MR50 9.0/Rh S","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax MR50 10.5/Rh S","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax MR50 9.0/Rh R","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax MR50 10.5/Rh R","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax Max MR50 9.0/RhS","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555},{"item_name":"TAYLORMADE DRV MWD-Drax Max MR50 10.5/RhS","item_code":"N/A","qty":1.0,"unit_price":7036172.0,"landed_unit_price":7520870.34831555}]'::jsonb, '[{"name":"Other fee","amount":13757875.0}]'::jsonb,
      'Bank of America (BOFAUS3N)', 'OLJ International U.S.A. Inc. (dba CA Golf Center)', '000466644188', 'Share of the same 12 Feb wire as 42158-1: USD 12,572.12 x 16,980 = IDR 213,474,597.60 (fee carried on 42158-1''s row; Invoice Total differs by a few hundred rupiah due to per-line rounding). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-01-27'::timestamptz, '2026-02-12'::timestamptz, v_user, v_batch
    );
  end if;
  -- SOG-15084 (Vin Sporting House Pte Ltd (VIN Distribution))
  if not exists (select 1 from public.payment_requests where ref_number = 'SOG-15084') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-08|288-9003-886 (SGD)' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Vin Sporting House Pte Ltd (VIN Distribution) — SOG-15084', 'Vin Sporting House Pte Ltd (VIN Distribution)', 'SOG-15084', '2026-04-16', 'Golfsolutions_PIK / CV Teknologi Keahlian Olahraga (attn: Benny Ng)', 'C.O.D, International wire (SGD)',
      5558700.00, 'IDR', 5558700.00, 0.00, '[{"item_name":"Brampton - Epoxy - Pro-Fix 5/15 Quick Cure 16.Oz(8+8)","item_code":"FBREP1516OZ88","qty":10.0,"unit_price":555870.0,"landed_unit_price":555870.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'Vin Sporting House Pte. Ltd.', '288-9003-886 (SGD)', 'BRIfast wire SGD 400.00, Ref 218703007348691. Remittance advice: Nominal Debet IDR 5,558,696.00 (exact rate 13,896.74 IDR/SGD), fee IDR 538,902.15, Total Debet IDR 6,097,598.15 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-16'::timestamptz, '2026-05-08'::timestamptz, v_user, v_batch
    );
  end if;
  -- SOG-15245 (Vin Sporting House Pte Ltd (VIN Distribution))
  if not exists (select 1 from public.payment_requests where ref_number = 'SOG-15245') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-08|0288-000330-011-022 (USD)' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Vin Sporting House Pte Ltd (VIN Distribution) — SOG-15245', 'Vin Sporting House Pte Ltd (VIN Distribution)', 'SOG-15245', '2026-04-27', 'Golfsolutions_PIK / CV Teknologi Keahlian Olahraga (attn: Benny Ng)', 'C.O.D, International wire (USD)',
      86940436.00, 'IDR', 86940436.00, 0.00, '[{"item_name":"Accra - SHOGUN Green 52 - M3","item_code":"SACDSHGGR52M3","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Green 52 - M4","item_code":"SACDSHGGR52M4","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Green 62 - M3","item_code":"SACDSHGGR62M3","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Green 62 - M4","item_code":"SACDSHGGR62M4","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Red 62 - M4","item_code":"SACDSHGRD62M4","qty":1.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Blue 42 - M0","item_code":"SACDSHGBL42M0","qty":1.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Blue 42 - M2","item_code":"SACDSHGBL42M2","qty":1.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Blue 42 - M4","item_code":"SACDSHGBL42M4","qty":1.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Golf Pride - CPx 60R","item_code":"GGPSSRBPX006R","qty":20.0,"unit_price":133266.0,"landed_unit_price":133266.0},{"item_name":"Golf Pride - Tour Velvet 360 60R - Black","item_code":"GGPSSRBTS006R","qty":50.0,"unit_price":85922.0,"landed_unit_price":85922.0},{"item_name":"Golf Pride Lite - Tour 25 Lite 60X - Black","item_code":"GGPSXSPTTBK6X","qty":20.0,"unit_price":150801.0,"landed_unit_price":150801.0},{"item_name":"Golf Pride - New Decade MCC Align Plus 4 MAX 60R","item_code":"GGPSSNDXPMX6R","qty":20.0,"unit_price":201653.0,"landed_unit_price":201653.0},{"item_name":"Golf Pride Putter - Reverse Taper Round - 58R Small 62G","item_code":"GGPZPRCRTRS8R","qty":2.0,"unit_price":301602.0,"landed_unit_price":301602.0},{"item_name":"Golf Pride Putter - Reverse Taper Pistol - 58R Small 56G","item_code":"GGPZPRCRTPS8R","qty":2.0,"unit_price":301602.0,"landed_unit_price":301602.0},{"item_name":"Golf Pride Putter - Reverse Taper Flat - 58R Medium 61G","item_code":"GGPZPRCRTFM8R","qty":1.0,"unit_price":301602.0,"landed_unit_price":301602.0},{"item_name":"Golf Pride Putter - Reverse Taper Flat - 58R Large 62G","item_code":"GGPZPRCRTFL8R","qty":1.0,"unit_price":301602.0,"landed_unit_price":301602.0},{"item_name":"Golf Pride Putter - Reverse Taper Flat - 58R Small 62G","item_code":"GGPZPRCRTFS8R","qty":1.0,"unit_price":301602.0,"landed_unit_price":301602.0},{"item_name":"Golf Pride Putter Grip - Pro Only Cord Green Star - 88cc","item_code":"GGPZPRBRCGN08","qty":1.0,"unit_price":259518.0,"landed_unit_price":259518.0},{"item_name":"Golf Pride Putter Grip - Pro Only Cord Red Star - 72cc","item_code":"GGPZPRBRCRD07","qty":1.0,"unit_price":259518.0,"landed_unit_price":259518.0},{"item_name":"Golf Pride Putter Grip - Pro Only Cord Blue Star - 81cc","item_code":"GGPZPRBRCBL08","qty":1.0,"unit_price":259518.0,"landed_unit_price":259518.0},{"item_name":"Golf Pride Putter Grip - Pro Only Blue Star","item_code":"GGPZPRBROBL8R","qty":1.0,"unit_price":205160.0,"landed_unit_price":205160.0},{"item_name":"Golf Pride Putter Grip - Pro Only Green Star","item_code":"GGPZPRBROGN8R","qty":1.0,"unit_price":205160.0,"landed_unit_price":205160.0},{"item_name":"Golf Pride Putter Grip - Pro Only Red Star","item_code":"GGPZPRBRORD8R","qty":1.0,"unit_price":205160.0,"landed_unit_price":205160.0},{"item_name":"Golf Pride - New Decade MCC 60R - Blue","item_code":"GGPSSNDMCBL6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC 60R - White","item_code":"GGPSSNDMCWH6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC 60R - Red","item_code":"GGPSSNDMCRD6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC 60R - Black","item_code":"GGPSSNDMCBK6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Teams - Black/Gold","item_code":"GGPSSNDMTBG6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Teams - Light Blue/White","item_code":"GGPSSNDMTLB6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Teams - Blue/White","item_code":"GGPSSNDMTBW6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Teams - Green/Gold","item_code":"GGPSSNDMTGG6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Plus 4 Teams - Black/Gold","item_code":"GGPSSNDPGBG6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Plus 4 Teams - Royal Blue/White","item_code":"GGPSSNDPGBW6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride - New Decade MCC Plus 4 Teams - Light Blue/White","item_code":"GGPSSNDPGLB6R","qty":20.0,"unit_price":159569.0,"landed_unit_price":159569.0},{"item_name":"Golf Pride U/Size - New Decade MCC Plus 4 58R - Gray","item_code":"GGPUSNDPFGR8R","qty":12.0,"unit_price":159569.0,"landed_unit_price":159569.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'Vin Sporting House Pte. Ltd.', '0288-000330-011-022 (USD)', 'Part of one BRIfast wire of USD 7,576.10 (Ref 218702007347691) covering SOG-15245+SOG-15288 exactly. Remittance advice: Nominal Debet IDR 132,846,913.50 (rate 17,534.42 IDR/USD), fee IDR 613,725 (included in THIS row''s Amount Paid), Total Debet IDR 133,460,638.50. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-27'::timestamptz, '2026-05-08'::timestamptz, v_user, v_batch
    );
  end if;
  -- SOG-15288 (Vin Sporting House Pte Ltd (VIN Distribution))
  if not exists (select 1 from public.payment_requests where ref_number = 'SOG-15288') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-08|0288-000330-011-022 (USD)' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Vin Sporting House Pte Ltd (VIN Distribution) — SOG-15288', 'Vin Sporting House Pte Ltd (VIN Distribution)', 'SOG-15288', '2026-04-30', 'Golfsolutions_PIK / CV Teknologi Keahlian Olahraga (attn: Benny Ng)', 'C.O.D, International wire (USD)',
      45906630.00, 'IDR', 45906630.00, 0.00, '[{"item_name":"Accra - SHOGUN Green 52 - M3","item_code":"SACDSHGGR52M3","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Green 52 - M4","item_code":"SACDSHGGR52M4","qty":3.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Green 62 - M3","item_code":"SACDSHGGR62M3","qty":3.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Green 62 - M4","item_code":"SACDSHGGR62M4","qty":3.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Red 62 - M4","item_code":"SACDSHGRD62M4","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Blue 42 - M0","item_code":"SACDSHGBL42M0","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0},{"item_name":"Accra - SHOGUN Blue 42 - M4","item_code":"SACDSHGBL42M4","qty":2.0,"unit_price":2700390.0,"landed_unit_price":2700390.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'Vin Sporting House Pte. Ltd.', '0288-000330-011-022 (USD)', 'Share of the same 8 May wire as SOG-15245: USD 2,618.00 at the wire rate (fee carried on SOG-15245''s row). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-30'::timestamptz, '2026-05-08'::timestamptz, v_user, v_batch
    );
  end if;
  -- CSRGD2606-10 (CSR Golf Distribution Sdn Bhd)
  if not exists (select 1 from public.payment_requests where ref_number = 'CSRGD2606-10') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-06-17|1410 3001 3015 369' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'CSR Golf Distribution Sdn Bhd — CSRGD2606-10', 'CSR Golf Distribution Sdn Bhd', 'CSRGD2606-10', '2026-06-15', 'Golf Solutions Indonesia (attn: Mr. Jacky Safriano)', 'International wire (MYR), T/T',
      283673456.00, 'IDR', 363683921.00, 80010465.00, '[{"item_name":"KBS TOUR LITE 95 #5I PRE.JV+","item_code":"2-G010955-B1","qty":15.0,"unit_price":375847.666666667,"landed_unit_price":375847.666666667},{"item_name":"KBS TOUR LITE 95 #6I PRE.JV+","item_code":"2-G010956-B1","qty":18.0,"unit_price":375847.666666667,"landed_unit_price":375847.666666667},{"item_name":"KBS TOUR LITE 95 #7I PRE.JV+","item_code":"2-G010957-B1","qty":11.0,"unit_price":375847.636363636,"landed_unit_price":375847.636363636},{"item_name":"KBS TOUR LITE 95 #8I PRE.JV+","item_code":"2-G010958-B1","qty":19.0,"unit_price":375847.684210526,"landed_unit_price":375847.684210526},{"item_name":"KBS TOUR LITE 95 #9I PRE.JV+","item_code":"2-G010959-B1","qty":2.0,"unit_price":375847.5,"landed_unit_price":375847.5},{"item_name":"KBS TOUR LITE 100 #5I PRE.JV+","item_code":"2-G010965-B1","qty":13.0,"unit_price":375847.692307692,"landed_unit_price":375847.692307692},{"item_name":"KBS TOUR LITE 100 #6I PRE.JV+","item_code":"2-G010966-B1","qty":14.0,"unit_price":375847.714285714,"landed_unit_price":375847.714285714},{"item_name":"KBS TOUR LITE 100 #7I PRE.JV+","item_code":"2-G010967-B1","qty":8.0,"unit_price":375847.625,"landed_unit_price":375847.625},{"item_name":"KBS TOUR LITE 100 #8I PRE.JV+","item_code":"2-G010968-B1","qty":15.0,"unit_price":375847.666666667,"landed_unit_price":375847.666666667},{"item_name":"KBS TOUR LITE 100 #9I PRE.JV+","item_code":"2-G010969-B1","qty":27.0,"unit_price":375847.666666667,"landed_unit_price":375847.666666667},{"item_name":"KBS TOUR LITE 105 #5I PRE.JV+","item_code":"2-G010975-B1","qty":2.0,"unit_price":375847.5,"landed_unit_price":375847.5},{"item_name":"KBS TOUR LITE 105 #6I PRE.JV+","item_code":"2-G010976-B1","qty":1.0,"unit_price":375848.0,"landed_unit_price":375848.0},{"item_name":"KBS TOUR LITE 105 #8I PRE.JV+","item_code":"2-G010978-B1","qty":2.0,"unit_price":375847.5,"landed_unit_price":375847.5},{"item_name":"KBS TOUR LITE 105 #9I PRE.JV+","item_code":"2-G010979-B1","qty":14.0,"unit_price":375847.714285714,"landed_unit_price":375847.714285714},{"item_name":"KBS S-TAPER LITE 95 #4I PRE.JV+","item_code":"2-G010854-B1","qty":4.0,"unit_price":576065.0,"landed_unit_price":576065.0},{"item_name":"KBS S-TAPER LITE 95 #5I PRE.JV+","item_code":"2-G010855-B1","qty":10.0,"unit_price":576065.1,"landed_unit_price":576065.1},{"item_name":"KBS S-TAPER LITE 95 #6I PRE.JV+","item_code":"2-G010856-B1","qty":11.0,"unit_price":576065.090909091,"landed_unit_price":576065.090909091},{"item_name":"KBS S-TAPER LITE 95 #7I PRE.JV+","item_code":"2-G010857-B1","qty":9.0,"unit_price":576065.111111111,"landed_unit_price":576065.111111111},{"item_name":"KBS S-TAPER LITE 95 #8I PRE.JV+","item_code":"2-G010858-B1","qty":6.0,"unit_price":576065.166666667,"landed_unit_price":576065.166666667},{"item_name":"KBS TOUR-V 100 #6I PRE.JV+","item_code":"2-G010476-B1","qty":6.0,"unit_price":407460.333333333,"landed_unit_price":407460.333333333},{"item_name":"KBS TOUR-V 100 #7I PRE.JV+","item_code":"2-G010477-B1","qty":6.0,"unit_price":407460.333333333,"landed_unit_price":407460.333333333},{"item_name":"KBS TOUR-V 100 #8I PRE.JV+","item_code":"2-G010478-B1","qty":6.0,"unit_price":407460.333333333,"landed_unit_price":407460.333333333},{"item_name":"KBS TOUR-V 100 #9I PRE.JV+","item_code":"2-G010479-B1","qty":13.0,"unit_price":407460.307692308,"landed_unit_price":407460.307692308},{"item_name":"KBS WEDGE 110 PRE.JV+","item_code":"2-G010316-B1","qty":15.0,"unit_price":379360.0,"landed_unit_price":379360.0},{"item_name":"KBS WEDGE 120 PRE.JV+","item_code":"2-G010318-B1","qty":11.0,"unit_price":379360.0,"landed_unit_price":379360.0},{"item_name":"KBS S-TAPER 110 #8I BK PRE.JV+","item_code":"2-G010718-C1B1","qty":1.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 95 #5I BK PRE.JV+","item_code":"2-G010955-C1B1","qty":2.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 95 #6I BK PRE.JV+","item_code":"2-G010956-C1B1","qty":1.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 95 #8I BK PRE.JV+","item_code":"2-G010958-C1B1","qty":2.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 95 #9I BK PRE.JV+","item_code":"2-G010959-C1B1","qty":31.0,"unit_price":533913.903225806,"landed_unit_price":533913.903225806},{"item_name":"KBS TOUR LITE 100 #5I BK PRE.JV+","item_code":"2-G010965-C1B1","qty":1.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 100 #6I BK PRE.JV+","item_code":"2-G010966-C1B1","qty":1.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 100 #7I BK PRE.JV+","item_code":"2-G010967-C1B1","qty":1.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 100 #8I BK PRE.JV+","item_code":"2-G010968-C1B1","qty":1.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS TOUR LITE 100 #9I BK PRE.JV+","item_code":"2-G010969-C1B1","qty":2.0,"unit_price":533914.0,"landed_unit_price":533914.0},{"item_name":"KBS S-TAPER LITE 95 #5I BK PRE.JV+","item_code":"2-G010855-C1B1","qty":3.0,"unit_price":660367.333333333,"landed_unit_price":660367.333333333},{"item_name":"KBS S-TAPER LITE 95 #6I BK PRE.JV+","item_code":"2-G010856-C1B1","qty":3.0,"unit_price":660367.333333333,"landed_unit_price":660367.333333333},{"item_name":"KBS S-TAPER LITE 95 #7I BK PRE.JV+","item_code":"2-G010857-C1B1","qty":3.0,"unit_price":660367.333333333,"landed_unit_price":660367.333333333},{"item_name":"KBS S-TAPER LITE 95 #8I BK PRE.JV+","item_code":"2-G010858-C1B1","qty":3.0,"unit_price":660367.333333333,"landed_unit_price":660367.333333333},{"item_name":"KBS S-TAPER LITE 105 #5I BK PRE.JV+","item_code":"2-G010875-C1B1","qty":4.0,"unit_price":660367.5,"landed_unit_price":660367.5},{"item_name":"KBS S-TAPER LITE 105 #6I BK PRE.JV+","item_code":"2-G010876-C1B1","qty":4.0,"unit_price":660367.5,"landed_unit_price":660367.5},{"item_name":"KBS S-TAPER LITE 105 #7I BK PRE.JV+","item_code":"2-G010877-C1B1","qty":5.0,"unit_price":660367.4,"landed_unit_price":660367.4},{"item_name":"KBS S-TAPER LITE 105 #8I BK PRE.JV+","item_code":"2-G010878-C1B1","qty":5.0,"unit_price":660367.4,"landed_unit_price":660367.4},{"item_name":"KBS S-TAPER LITE 105 #9I BK PRE.JV+","item_code":"2-G010879-C1B1","qty":9.0,"unit_price":660367.444444445,"landed_unit_price":660367.444444445},{"item_name":"KBS WEDGE 110 BK PRE.JV+","item_code":"2-G010316-C1B1","qty":10.0,"unit_price":505812.8,"landed_unit_price":505812.8},{"item_name":"KBS HI-REV2.0 115 BK PRE.JV+","item_code":"2-G010540-C1B1","qty":18.0,"unit_price":526888.444444445,"landed_unit_price":526888.444444445},{"item_name":"KBS MAX GRAPHITE IRON - 45 P","item_code":"CARBON","qty":13.0,"unit_price":572552.769230769,"landed_unit_price":572552.769230769},{"item_name":"KBS MAX GRAPHITE IRON - 55 P","item_code":"CARBON","qty":13.0,"unit_price":572552.769230769,"landed_unit_price":572552.769230769},{"item_name":"KBS TGI - 50 P","item_code":"CARBON","qty":8.0,"unit_price":576065.125,"landed_unit_price":576065.125},{"item_name":"KBS TGI - 70 P","item_code":"CARBON","qty":27.0,"unit_price":576065.111111111,"landed_unit_price":576065.111111111},{"item_name":"KBS TGI - 100 #6i","item_code":"CARBON","qty":1.0,"unit_price":667392.0,"landed_unit_price":667392.0},{"item_name":"KBS PGI - 50 P","item_code":"CARBON","qty":20.0,"unit_price":648073.15,"landed_unit_price":648073.15},{"item_name":"KBS PGI - 60 P","item_code":"CARBON","qty":20.0,"unit_price":648073.15,"landed_unit_price":648073.15},{"item_name":"KBS PGI - 70 P","item_code":"CARBON","qty":20.0,"unit_price":648073.15,"landed_unit_price":648073.15},{"item_name":"KBS PGI - 80 P","item_code":"CARBON","qty":20.0,"unit_price":648073.15,"landed_unit_price":648073.15},{"item_name":"KBS PGI - 90 P","item_code":"CARBON","qty":10.0,"unit_price":648073.1,"landed_unit_price":648073.1},{"item_name":"KBS MAXHL HYBRID - 50R1 P","item_code":"CARBON","qty":5.0,"unit_price":878148.2,"landed_unit_price":878148.2},{"item_name":"KBS MAXHL HYBRID - 60R P","item_code":"CARBON","qty":5.0,"unit_price":878148.2,"landed_unit_price":878148.2},{"item_name":"KBS MAXHL HYBRID - 70S P","item_code":"CARBON","qty":5.0,"unit_price":878148.2,"landed_unit_price":878148.2},{"item_name":"KBS GPS White Gloss 370","item_code":"CARBON","qty":2.0,"unit_price":1022164.5,"landed_unit_price":1022164.5},{"item_name":"KBS GPS Red Gloss 370","item_code":"CARBON","qty":1.0,"unit_price":1022164.0,"landed_unit_price":1022164.0},{"item_name":"KBS GPS Black Gloss 370","item_code":"CARBON","qty":2.0,"unit_price":1022164.5,"landed_unit_price":1022164.5},{"item_name":"KBS GPS Green Gloss 370","item_code":"CARBON","qty":1.0,"unit_price":1022164.0,"landed_unit_price":1022164.0},{"item_name":"KBS GPS Yellow Gloss 370","item_code":"CARBON","qty":1.0,"unit_price":1022164.0,"landed_unit_price":1022164.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad (MFBBMYKL)', 'CSR Golf Distribution Sdn. Bhd.', '1410 3001 3015 369', 'BRIfast wire MYR 62,992.02 (17 Jun 2026, Ref 218708007731691, UETR per MX message) to CSR''s Alliance Bank acct 1410 3001 3015 369, per standing instruction 010/06/CVTKO/2026. Remittance advice: Nominal Debet IDR 283,673,391.25 (exact rate 4,503.32 IDR/MYR), fee IDR 626,675, Total Debet IDR 284,300,066.25 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-15'::timestamptz, '2026-06-17'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV-0226-008 (Point Leo Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV-0226-008') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-03-11|0721400057' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Point Leo Pte Ltd — INV-0226-008', 'Point Leo Pte Ltd', 'INV-0226-008', '2026-02-25', 'CV. Teknologi Keahlian Olahraga Golf', 'International wire (USD), Due on Receipt',
      110718853.00, 'IDR', 116546163.00, 5827310.00, '[{"item_name":"MIURA HD RH PI402 CHROME IR #4","item_code":"N/A","qty":1.0,"unit_price":3110533.0,"landed_unit_price":3110533.0},{"item_name":"MIURA HD RH PI402 CHROME IR #5","item_code":"N/A","qty":3.0,"unit_price":3110532.66666667,"landed_unit_price":3110532.66666667},{"item_name":"MIURA HD RH PI402 CHROME IR #6","item_code":"N/A","qty":3.0,"unit_price":3110532.66666667,"landed_unit_price":3110532.66666667},{"item_name":"MIURA HD RH PI402 CHROME IR #7","item_code":"N/A","qty":3.0,"unit_price":3110532.66666667,"landed_unit_price":3110532.66666667},{"item_name":"MIURA HD RH PI402 CHROME IR #8","item_code":"N/A","qty":3.0,"unit_price":3110532.66666667,"landed_unit_price":3110532.66666667},{"item_name":"MIURA HD RH PI402 CHROME IR #9","item_code":"N/A","qty":3.0,"unit_price":3110532.66666667,"landed_unit_price":3110532.66666667},{"item_name":"MIURA HD RH PI402 CHROME IR #PW","item_code":"N/A","qty":3.0,"unit_price":3110532.66666667,"landed_unit_price":3110532.66666667},{"item_name":"MIURA HD RH PI402 CHROME IR #7 DEMO","item_code":"N/A","qty":3.0,"unit_price":2578680.0,"landed_unit_price":2578680.0},{"item_name":"MIURA HD RH TC202 QPQ BLK IR #5","item_code":"N/A","qty":2.0,"unit_price":3656891.0,"landed_unit_price":3656891.0},{"item_name":"MIURA HD RH TC202 QPQ BLK IR #6","item_code":"N/A","qty":2.0,"unit_price":3656891.0,"landed_unit_price":3656891.0},{"item_name":"MIURA HD RH TC202 QPQ BLK IR #7","item_code":"N/A","qty":2.0,"unit_price":3656891.0,"landed_unit_price":3656891.0},{"item_name":"MIURA HD RH TC202 QPQ BLK IR #8","item_code":"N/A","qty":2.0,"unit_price":3656891.0,"landed_unit_price":3656891.0},{"item_name":"MIURA HD RH TC202 QPQ BLK IR #9","item_code":"N/A","qty":2.0,"unit_price":3656891.0,"landed_unit_price":3656891.0},{"item_name":"MIURA HD RH TC202 QPQ BLK IR #PW","item_code":"N/A","qty":2.0,"unit_price":3656891.0,"landed_unit_price":3656891.0}]'::jsonb, null,
      'DBS Singapore Pte Ltd', 'Point Leo Pte Ltd', '0721400057', 'BRIfast wire USD 6,526.31 (11 Mar 2026, Ref 218702006860691) matching this invoice exactly, per standing instruction 002/03/CVTKO/2026. Remittance advice: Nominal Debet IDR 110,718,849.15 (exact rate 16,965 IDR/USD), fee IDR 593,775, Total Debet IDR 111,312,624.15 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-02-25'::timestamptz, '2026-03-11'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV-0426-001 (Point Leo Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV-0426-001') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-04-16|0721400057' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Point Leo Pte Ltd — INV-0426-001', 'Point Leo Pte Ltd', 'INV-0426-001', '2026-04-13', 'CV. Teknologi Keahlian Olahraga Golf', 'International wire (USD), Due on Receipt',
      378085476.00, 'IDR', 397984710.00, 19899234.00, '[{"item_name":"MIURA HD RH KM700 CHROME IR #5","item_code":"N/A","qty":10.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH KM700 CHROME IR #6","item_code":"N/A","qty":10.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH KM700 CHROME IR #7","item_code":"N/A","qty":10.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH KM700 CHROME IR #8","item_code":"N/A","qty":10.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH KM700 CHROME IR #9","item_code":"N/A","qty":10.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH KM700 CHROME IR #PW","item_code":"N/A","qty":10.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH KM700 QPQ IR #5","item_code":"N/A","qty":3.0,"unit_price":3739879.33333333,"landed_unit_price":3739879.33333333},{"item_name":"MIURA HD RH KM700 QPQ IR #6","item_code":"N/A","qty":3.0,"unit_price":3739879.33333333,"landed_unit_price":3739879.33333333},{"item_name":"MIURA HD RH KM700 QPQ IR #7","item_code":"N/A","qty":3.0,"unit_price":3739879.33333333,"landed_unit_price":3739879.33333333},{"item_name":"MIURA HD RH KM700 QPQ IR #8","item_code":"N/A","qty":3.0,"unit_price":3739879.33333333,"landed_unit_price":3739879.33333333},{"item_name":"MIURA HD RH KM700 QPQ IR #9","item_code":"N/A","qty":3.0,"unit_price":3739879.33333333,"landed_unit_price":3739879.33333333},{"item_name":"MIURA HD RH KM700 QPQ IR #PW","item_code":"N/A","qty":3.0,"unit_price":3739879.33333333,"landed_unit_price":3739879.33333333},{"item_name":"MIURA HEAD RH CB-302 CHROME #5","item_code":"N/A","qty":5.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HEAD RH CB-302 CHROME #6","item_code":"N/A","qty":5.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HEAD RH CB-302 CHROME #7","item_code":"N/A","qty":5.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HEAD RH CB-302 CHROME #8","item_code":"N/A","qty":5.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HEAD RH CB-302 CHROME #9","item_code":"N/A","qty":5.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HEAD RH CB-302 CHROME #PW","item_code":"N/A","qty":5.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH TC202 CHROME IR #5","item_code":"N/A","qty":1.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH TC202 CHROME IR #6","item_code":"N/A","qty":1.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH TC202 CHROME IR #7","item_code":"N/A","qty":1.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH TC202 CHROME IR #8","item_code":"N/A","qty":1.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH TC202 CHROME IR #9","item_code":"N/A","qty":1.0,"unit_price":3237163.0,"landed_unit_price":3237163.0},{"item_name":"MIURA HD RH TC202 CHROME IR #PW","item_code":"N/A","qty":1.0,"unit_price":3237163.0,"landed_unit_price":3237163.0}]'::jsonb, null,
      'DBS Singapore Pte Ltd', 'Point Leo Pte Ltd', '0721400057', 'BRIfast wire USD 21,791.64 (16 Apr 2026, Ref 218702007177691, UETR 545f07cc-90ca-42bb-bc80-6f273b642c51) matching this invoice exactly, per standing instruction 003/04/CVTKO/2026. Only the SWIFT MX message is on file - no IDR debit known, so Amount Paid is the ESTIMATED IDR value (rate 17,350, nearest real USD rate); update when the IDR remittance advice arrives. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-13'::timestamptz, '2026-04-16'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV/0526/0003 (Point Leo Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV/0526/0003') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-06-10|0721400057' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Point Leo Pte Ltd — INV/0526/0003', 'Point Leo Pte Ltd', 'INV/0526/0003', '2026-05-11', 'CV. Teknologi Keahlian Olahraga Golf', 'International wire (USD), Due on Receipt',
      70958237.00, 'IDR', 74692884.00, 3734647.00, '[{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #5","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667},{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #6","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667},{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #7","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667},{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #8","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667},{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #9","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667},{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #PW","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667},{"item_name":"MIURA HD RH BABY BLADE SATIN CHRM IR #3","item_code":"N/A","qty":3.0,"unit_price":3378963.66666667,"landed_unit_price":3378963.66666667}]'::jsonb, null,
      'DBS Singapore Pte Ltd', 'Point Leo Pte Ltd', '0721400057', 'Part of one BRIfast wire of USD 12,919.62 (10 Jun 2026, Ref 218702007670691) covering INV/0526/0003 + INV-0526-004 exactly (3,918.18 + 9,001.44), per standing instruction 008/06/CVTKO/2026. Remittance advice: Nominal Debet IDR 233,974,318.20 (exact rate 18,110 IDR/USD), fee IDR 633,850 (included in THIS row''s Amount Paid), Total Debet IDR 234,608,168.20. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-05-11'::timestamptz, '2026-06-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- INV-0526-004 (Point Leo Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'INV-0526-004') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-06-10|0721400057' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'Point Leo Pte Ltd — INV-0526-004', 'Point Leo Pte Ltd', 'INV-0526-004', '2026-05-29', 'CV. Teknologi Keahlian Olahraga Golf', 'International wire (USD), Due on Receipt',
      163016075.00, 'IDR', 171595872.00, 8579797.00, '[{"item_name":"MIURA HD RH IC-602 CHROME IR #5","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH IC-602 CHROME IR #6","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH IC-602 CHROME IR #7","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH IC-602 CHROME IR #8","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH IC-602 CHROME IR #9","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH IC-602 CHROME IR #PW","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH PI402 CHROME IR #5","item_code":"N/A","qty":6.0,"unit_price":3468427.16666667,"landed_unit_price":3468427.16666667},{"item_name":"MIURA HD RH PI402 CHROME IR #6","item_code":"N/A","qty":6.0,"unit_price":3468427.16666667,"landed_unit_price":3468427.16666667},{"item_name":"MIURA HD RH PI402 CHROME IR #7","item_code":"N/A","qty":6.0,"unit_price":3468427.16666667,"landed_unit_price":3468427.16666667},{"item_name":"MIURA HD RH PI402 CHROME IR #8","item_code":"N/A","qty":6.0,"unit_price":3468427.16666667,"landed_unit_price":3468427.16666667},{"item_name":"MIURA HD RH PI402 CHROME IR #9","item_code":"N/A","qty":6.0,"unit_price":3468427.16666667,"landed_unit_price":3468427.16666667},{"item_name":"MIURA HD RH PI402 CHROME IR #PW","item_code":"N/A","qty":6.0,"unit_price":3468427.16666667,"landed_unit_price":3468427.16666667},{"item_name":"MIURA HD RH FORGED CHRME YG WG 48","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH FORGED CHRME YG WG 52","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HEAD K GRIND 2.0 CHRME WG 54","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH FORGED CHRME YG WG 56","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0},{"item_name":"MIURA HD RH FORGED CHRME CG WG 56","item_code":"N/A","qty":1.0,"unit_price":3468427.0,"landed_unit_price":3468427.0}]'::jsonb, null,
      'DBS Singapore Pte Ltd', 'Point Leo Pte Ltd', '0721400057', 'Share of the same 10 Jun wire as INV/0526/0003: USD 9,001.44 x 18,110 (fee carried on INV/0526/0003''s row). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-05-29'::timestamptz, '2026-06-10'::timestamptz, v_user, v_batch
    );
  end if;
  -- PRO-01601 (WinGolf Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'PRO-01601') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-13|0017001208012022' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'WinGolf Pte Ltd — PRO-01601', 'WinGolf Pte Ltd', 'PRO-01601', '2026-03-27', 'Golf Solution PIK (attn: Mr. Jacky Safriano)', 'ADV (advance payment), International wire (USD)',
      48928131.00, 'IDR', 93641850.00, 44713719.00, '[{"item_name":"IRONS RH PING G740 MIDNIGHT STD #5-9,PW (6PCS) ALTA J CB BLUE R, GP360 TOUR VELVET LITE AQUA","item_code":"N/A","qty":1.0,"unit_price":16309377.0,"landed_unit_price":16309377.0},{"item_name":"IRONS RH PING G740 MIDNIGHT STD #5-9,PW (6PCS) ALTA J CB BLUE S, GP360 TOUR VELVET LITE WHITE","item_code":"N/A","qty":1.0,"unit_price":16309377.0,"landed_unit_price":16309377.0},{"item_name":"IRONS RH PING G740 MIDNIGHT HL STD #5-9,PW (6PCS) FUJIKURA SPEEDER NX GREY 40, IOMIC STICKY SL AQUA","item_code":"N/A","qty":1.0,"unit_price":16309377.0,"landed_unit_price":16309377.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'WinGolf Pte Ltd', '0017001208012022', 'Part of one BRIfast wire of USD 16,923.83 (13 May 2026, Ref 218702007390691) covering PRO-01601 + PRO-01621 + PRO-01629 + PRO-01649 exactly (2,774.49 + 7,524.00 + 674.00 + 5,951.34), per standing instruction dated 13 May 2026. Remittance advice: Nominal Debet IDR 298,451,742.05 (rate 17,635.61 IDR/USD), fee IDR 617,225 (included in THIS row''s Amount Paid), Total Debet IDR 299,068,967.05. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-03-27'::timestamptz, '2026-05-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- PRO-01621 (WinGolf Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'PRO-01621') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-13|0017001208012022' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'WinGolf Pte Ltd — PRO-01621', 'WinGolf Pte Ltd', 'PRO-01621', '2026-04-15', 'Golf Solution PIK (attn: Mr. Jacky Safriano)', 'ADV (advance payment), International wire (USD)',
      132685745.00, 'IDR', 253944000.00, 121258255.00, '[{"item_name":"WEDGE RH S259 CHROME 48S NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 50S NS PRO 850GH NEO S","item_code":"N/A","qty":3.0,"unit_price":2764286.33333333,"landed_unit_price":2764286.33333333},{"item_name":"WEDGE RH S259 CHROME 52S AWT 3.0 LITE S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 54S NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 56S NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 58S NS PRO 950GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 60S NS PRO 950GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 56H NS PRO 850GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 60H NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 58T AWT 3.0 LITE S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 62T NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 50W NS PRO 850GH NEO S","item_code":"N/A","qty":3.0,"unit_price":2764286.33333333,"landed_unit_price":2764286.33333333},{"item_name":"WEDGE RH S259 CHROME 52W NS PRO 850GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 54W NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 56W NS PRO 850GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 58W NS PRO 950GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 CHROME 60W NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 58E NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 60E NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 58B NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 CHROME 60B NS PRO 950GH NEO S","item_code":"N/A","qty":1.0,"unit_price":2764286.0,"landed_unit_price":2764286.0},{"item_name":"WEDGE RH S259 MIDNIGHT 48S NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 MIDNIGHT 50S NS PRO 850GH NEO S","item_code":"N/A","qty":3.0,"unit_price":2764286.33333333,"landed_unit_price":2764286.33333333},{"item_name":"WEDGE RH S259 MIDNIGHT 52S AWT 3.0 LITE S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 MIDNIGHT 54S NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 MIDNIGHT 56S NS PRO 850GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 MIDNIGHT 58S NS PRO 950GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5},{"item_name":"WEDGE RH S259 MIDNIGHT 60S NS PRO 950GH NEO S","item_code":"N/A","qty":2.0,"unit_price":2764286.5,"landed_unit_price":2764286.5}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'WinGolf Pte Ltd', '0017001208012022', 'Share of the same 13 May wire as PRO-01601: USD 7,524.00 at the wire rate (fee carried on PRO-01601''s row). | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-15'::timestamptz, '2026-05-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- PRO-01629 (WinGolf Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'PRO-01629') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-13|0017001208012022' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'WinGolf Pte Ltd — PRO-01629', 'WinGolf Pte Ltd', 'PRO-01629', '2026-04-16', 'Golf Solution PIK (attn: Mr. Jacky Safriano)', 'ADV (advance payment), International wire (USD)',
      11885990.00, 'IDR', 29714975.00, 17828985.00, '[{"item_name":"DEMO WEDGE RH PRODI G 243 54/S PRODI G S","item_code":"N/A","qty":1.0,"unit_price":1058100.0,"landed_unit_price":1058100.0},{"item_name":"DEMO WEDGE RH PRODI G 243 58/H PRODI G S","item_code":"N/A","qty":1.0,"unit_price":1058100.0,"landed_unit_price":1058100.0},{"item_name":"DEMO IRON RH PRODI G 243 #7-9PW PRODI G S","item_code":"N/A","qty":1.0,"unit_price":4232400.0,"landed_unit_price":4232400.0},{"item_name":"DEMO HYBRID RH PRODI G 243 28 PRODI G R","item_code":"N/A","qty":1.0,"unit_price":1375530.0,"landed_unit_price":1375530.0},{"item_name":"DEMO FAIRWAY WOOD RH PRODI G 243 22","item_code":"N/A","qty":1.0,"unit_price":1481340.0,"landed_unit_price":1481340.0},{"item_name":"DEMO DRIVER RH PRODI G 243 15 PRODI G S","item_code":"N/A","qty":1.0,"unit_price":2680520.0,"landed_unit_price":2680520.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'WinGolf Pte Ltd', '0017001208012022', 'Share of the same 13 May wire as PRO-01601: USD 674.00 at the wire rate. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-16'::timestamptz, '2026-05-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- PRO-01630 (WinGolf Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'PRO-01630') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-04-28|0017001208012022' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'WinGolf Pte Ltd — PRO-01630', 'WinGolf Pte Ltd', 'PRO-01630', '2026-04-16', 'Golf Solution PIK (attn: Mr. Jacky Safriano)', 'ADV (advance payment), International wire (USD)',
      30007174.00, 'IDR', 57428500.00, 27421326.00, '[{"item_name":"WEDGE RH PRODI G 243 54/S PRODI G S STD","item_code":"N/A","qty":1.0,"unit_price":1359893.0,"landed_unit_price":1359893.0},{"item_name":"WEDGE RH PRODI G 243 58/H PRODI G S STD","item_code":"N/A","qty":1.0,"unit_price":1359893.0,"landed_unit_price":1359893.0},{"item_name":"HYBRID RH PRODI G 243 28 PRODI G S 36.25","item_code":"N/A","qty":1.0,"unit_price":1767792.0,"landed_unit_price":1767792.0},{"item_name":"FAIRWAY WOOD RH PRODI G 243 22 PRODI G S","item_code":"N/A","qty":1.0,"unit_price":1903816.0,"landed_unit_price":1903816.0},{"item_name":"DRIVER RH PRODI G 243 15 PRODI G S 39.5","item_code":"N/A","qty":2.0,"unit_price":3444842.5,"landed_unit_price":3444842.5},{"item_name":"WEDGE RH PRODI G 243 54/S PRODI G R -0.5","item_code":"N/A","qty":1.0,"unit_price":1359893.0,"landed_unit_price":1359893.0},{"item_name":"WEDGE RH PRODI G 243 58/H PRODI G R -0.5","item_code":"N/A","qty":1.0,"unit_price":1359893.0,"landed_unit_price":1359893.0},{"item_name":"HYBRID RH PRODI G 243 28 PRODI G R -0.5","item_code":"N/A","qty":1.0,"unit_price":1767792.0,"landed_unit_price":1767792.0},{"item_name":"FAIRWAY WOOD RH PRODI G 243 22 PRODI G R","item_code":"N/A","qty":1.0,"unit_price":1903816.0,"landed_unit_price":1903816.0},{"item_name":"DRIVER RH PRODI G 243 15 PRODI G R -0.75","item_code":"N/A","qty":2.0,"unit_price":3444842.5,"landed_unit_price":3444842.5},{"item_name":"BAG HOOFER PRODI G 243 SMALL BLACK","item_code":"N/A","qty":1.0,"unit_price":1722508.0,"landed_unit_price":1722508.0},{"item_name":"BAG HOOFER PRODI G 243 LARGE BLACK","item_code":"N/A","qty":1.0,"unit_price":1722508.0,"landed_unit_price":1722508.0}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'WinGolf Pte Ltd', '0017001208012022', 'BRIfast wire USD 1,729.52 (28 Apr 2026, Ref 218702007263691) matching this invoice exactly. Remittance advice (''Wingolf Pte Ltd.pdf''): Nominal Debet IDR 30,007,172.00 (exact rate 17,350 IDR/USD), fee IDR 520,500, Total Debet IDR 30,527,672.00 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-16'::timestamptz, '2026-04-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- PRO-01649 (WinGolf Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'PRO-01649') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-13|0017001208012022' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'WinGolf Pte Ltd — PRO-01649', 'WinGolf Pte Ltd', 'PRO-01649', '2026-05-12', 'Golf Solution PIK (attn: Mr. Jacky Safriano)', 'ADV (advance payment), International wire (USD)',
      104951884.00, 'IDR', 200862650.00, 95910766.00, '[{"item_name":"FAIRWAY WOOD RH G440 3 MAX ALTA J CB BLUE R","item_code":"N/A","qty":1.0,"unit_price":4883661.0,"landed_unit_price":4883661.0},{"item_name":"FAIRWAY WOOD RH G440 3 MAX ALTA J CB BLUE SR","item_code":"N/A","qty":1.0,"unit_price":4883661.0,"landed_unit_price":4883661.0},{"item_name":"FAIRWAY WOOD RH G440 3 MAX ALTA J CB BLUE S","item_code":"N/A","qty":3.0,"unit_price":4883601.66666667,"landed_unit_price":4883601.66666667},{"item_name":"FAIRWAY WOOD RH G440 5 MAX ALTA J CB BLUE R","item_code":"N/A","qty":1.0,"unit_price":4883661.0,"landed_unit_price":4883661.0},{"item_name":"FAIRWAY WOOD RH G440 5 MAX ALTA J CB BLUE SR","item_code":"N/A","qty":1.0,"unit_price":4883661.0,"landed_unit_price":4883661.0},{"item_name":"FAIRWAY WOOD RH G440 5 MAX ALTA J CB BLUE S","item_code":"N/A","qty":3.0,"unit_price":4883601.66666667,"landed_unit_price":4883601.66666667},{"item_name":"FAIRWAY WOOD RH G440 7 MAX ALTA J CB BLUE R","item_code":"N/A","qty":1.0,"unit_price":4883661.0,"landed_unit_price":4883661.0},{"item_name":"FAIRWAY WOOD RH G440 7 MAX ALTA J CB BLUE S","item_code":"N/A","qty":2.0,"unit_price":4883572.5,"landed_unit_price":4883572.5},{"item_name":"HYBRID RH G440 #3 (20deg) ALTA J CB BLUE R STD","item_code":"N/A","qty":1.0,"unit_price":4146518.0,"landed_unit_price":4146518.0},{"item_name":"HYBRID RH G440 #3 (20deg) ALTA J CB BLUE SR","item_code":"N/A","qty":1.0,"unit_price":4146518.0,"landed_unit_price":4146518.0},{"item_name":"HYBRID RH G440 #3 (20deg) ALTA J CB BLUE S STD","item_code":"N/A","qty":3.0,"unit_price":4146458.66666667,"landed_unit_price":4146458.66666667},{"item_name":"HYBRID RH G440 #4 (23deg) ALTA J CB BLUE R STD","item_code":"N/A","qty":1.0,"unit_price":4146518.0,"landed_unit_price":4146518.0},{"item_name":"HYBRID RH G440 #4 (23deg) ALTA J CB BLUE SR","item_code":"N/A","qty":1.0,"unit_price":4146518.0,"landed_unit_price":4146518.0},{"item_name":"HYBRID RH G440 #4 (23deg) ALTA J CB BLUE S STD","item_code":"N/A","qty":3.0,"unit_price":4146458.66666667,"landed_unit_price":4146458.66666667}]'::jsonb, null,
      'DBS Bank Ltd. (Singapore)', 'WinGolf Pte Ltd', '0017001208012022', 'Share of the same 13 May wire as PRO-01601: USD 5,951.34 at the wire rate. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-05-12'::timestamptz, '2026-05-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- T800419D (OneGolf Pte Ltd (OneGolf Singapore))
  if not exists (select 1 from public.payment_requests where ref_number = 'T800419D') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-02-13|0721032970' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'OneGolf Pte Ltd (OneGolf Singapore) — T800419D', 'OneGolf Pte Ltd (OneGolf Singapore)', 'T800419D', '2026-02-12', 'Jacky (Golf Solutions)', 'Pay by End of Day, International wire (SGD)',
      175628852.00, 'IDR', 175628852.00, 0.00, '[{"item_name":"Autoflex driver shaft","item_code":"N/A","qty":1.0,"unit_price":8213352.0,"landed_unit_price":8213352.0},{"item_name":"Lab Golf DF3 custom Accra","item_code":"N/A","qty":2.0,"unit_price":10814247.0,"landed_unit_price":10814247.0},{"item_name":"Titleist SM11 wedge","item_code":"N/A","qty":37.0,"unit_price":3285341.0,"landed_unit_price":3285341.0},{"item_name":"Lab Golf DF2.1 custom","item_code":"N/A","qty":1.0,"unit_price":10266690.0,"landed_unit_price":10266690.0},{"item_name":"Lab Golf DF3 std","item_code":"N/A","qty":1.0,"unit_price":6707571.0,"landed_unit_price":6707571.0},{"item_name":"Lab Golf OZ1i std","item_code":"N/A","qty":1.0,"unit_price":7255128.0,"landed_unit_price":7255128.0}]'::jsonb, null,
      'DBS Bank (Singapore)', 'Onegolf Pte Ltd', '0721032970', 'BRIfast wire SGD 12,830.00 (13 Feb 2026, Ref 218703006637691) matching this invoice exactly. This wire was funded directly from an SGD account (''RESERVE CIF INTERNAL''): the advice shows Debet SGD 12,830.00 + fee SGD 45.05 = Total Debet SGD 12,875.05, with NO IDR amount - so Amount Paid in IDR is left blank; the invoice''s IDR columns are estimates at the 28 Apr SGD rate. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-02-12'::timestamptz, '2026-02-13'::timestamptz, v_user, v_batch
    );
  end if;
  -- T800555D (OneGolf Pte Ltd (OneGolf Singapore))
  if not exists (select 1 from public.payment_requests where ref_number = 'T800555D') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-06-08|0721032970' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'OneGolf Pte Ltd (OneGolf Singapore) — T800555D', 'OneGolf Pte Ltd (OneGolf Singapore)', 'T800555D', '2026-06-07', 'Jacky (Golf Solutions)', 'Pay by End of Day, International wire (SGD)',
      151038936.00, 'IDR', 151038936.00, 0.00, '[{"item_name":"Srixon ZXi5, NS Pro Neo 950 R (5-P)","item_code":"N/A","qty":2.0,"unit_price":12872637.0,"landed_unit_price":12872637.0},{"item_name":"Srixon ZXi5, NS Pro Neo 950 S (5-P)","item_code":"N/A","qty":1.0,"unit_price":12872637.0,"landed_unit_price":12872637.0},{"item_name":"Mizuno Hot Metal 925, NS Pro Neo 950 R (5-P)","item_code":"N/A","qty":1.0,"unit_price":6865406.0,"landed_unit_price":6865406.0},{"item_name":"Mizuno Hot Metal 925, NS Pro Neo 950 S (5-P)","item_code":"N/A","qty":1.0,"unit_price":6865406.0,"landed_unit_price":6865406.0},{"item_name":"LAB Golf Link 2.1 (33in)","item_code":"N/A","qty":1.0,"unit_price":7151465.0,"landed_unit_price":7151465.0},{"item_name":"LAB Golf Link 2.1 (34in)","item_code":"N/A","qty":2.0,"unit_price":7151465.0,"landed_unit_price":7151465.0},{"item_name":"LAB Golf Link 2.1 (35in)","item_code":"N/A","qty":1.0,"unit_price":7151465.0,"landed_unit_price":7151465.0},{"item_name":"MMT 80S shaft","item_code":"N/A","qty":15.0,"unit_price":572117.0,"landed_unit_price":572117.0},{"item_name":"MMT 70R shaft","item_code":"N/A","qty":10.0,"unit_price":572117.0,"landed_unit_price":572117.0},{"item_name":"Lab Golf OZ1i HS (33in)","item_code":"N/A","qty":1.0,"unit_price":6793892.0,"landed_unit_price":6793892.0},{"item_name":"Lab Golf OZ1i HS (34in)","item_code":"N/A","qty":1.0,"unit_price":6793892.0,"landed_unit_price":6793892.0},{"item_name":"Lab Golf OZ1 (34in)","item_code":"N/A","qty":1.0,"unit_price":6793892.0,"landed_unit_price":6793892.0},{"item_name":"Lab Golf DF3i (33in)","item_code":"N/A","qty":1.0,"unit_price":6793892.0,"landed_unit_price":6793892.0},{"item_name":"LAB Golf Link 2.2 (33in)","item_code":"N/A","qty":1.0,"unit_price":7151465.0,"landed_unit_price":7151465.0},{"item_name":"LAB Golf Link 2.2 (34in)","item_code":"N/A","qty":2.0,"unit_price":7151465.0,"landed_unit_price":7151465.0},{"item_name":"LAB Golf Link 2.2 (35in)","item_code":"N/A","qty":1.0,"unit_price":7151465.0,"landed_unit_price":7151465.0}]'::jsonb, null,
      'DBS Bank (Singapore)', 'Onegolf Pte Ltd', '0721032970', 'BRIfast wire SGD 10,230.00 (8 Jun 2026, Ref 218703007643691), per standing instruction 008/06/CVTKO/2026. Remittance advice: Nominal Debet IDR 146,318,973.90 (rate 14,302.93 IDR/SGD), fee IDR 655,260.63, Total Debet IDR 146,974,234.53 = Amount Paid. NOTE: invoice total is SGD 10,560.00 - the wire paid SGD 330.00 LESS than the invoice; confirm whether an item was credited/returned or a balance remains. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-07'::timestamptz, '2026-06-08'::timestamptz, v_user, v_batch
    );
  end if;
  -- EX260034 (MST Golf (S) Pte Ltd)
  if not exists (select 1 from public.payment_requests where ref_number = 'EX260034') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-04-28|2000649833' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'MST Golf (S) Pte Ltd — EX260034', 'MST Golf (S) Pte Ltd', 'EX260034', '2026-04-23', 'Golf Solutions PIK (attn: Benny Ng)', 'International wire (SGD), Credit Term CBD',
      54402918.00, 'IDR', 54402918.00, 0.00, '[{"item_name":"TAYLORMADE QI4D DS BLACK REAX MR 50 US (26) GP DRIVER","item_code":"GF1210101324105R","qty":2.0,"unit_price":8969186.0,"landed_unit_price":8969186.0},{"item_name":"TAYLORMADE QI4D MAX DS BLACK REAX MR 50 US (26) GP DRIVER","item_code":"GF1210101325105R","qty":2.0,"unit_price":8969186.0,"landed_unit_price":8969186.0},{"item_name":"TAYLORMADE P790 SATIN CHARCOAL MODUS105 BLK LE (25) 4-9P IRONS SET","item_code":"GF1280101355S","qty":1.0,"unit_price":18526174.0,"landed_unit_price":18526174.0}]'::jsonb, null,
      'CIMB Bank Berhad', 'MST Golf (Singapore) Pte Ltd', '2000649833', 'BRIfast wire SGD 3,974.23 (28 Apr 2026, Ref 218703007261691) matching this invoice exactly. Remittance advice: Nominal Debet IDR 54,402,916.53 (rate 13,689.03 IDR/SGD), fee IDR 530,818.56, Total Debet IDR 54,933,735.09 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-23'::timestamptz, '2026-04-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- 2026-0022 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0022') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0022', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0022', '2026-02-25', 'Golf Solutions (attn: Mr Jack)', 'Cash On Delivery',
      71466912.00, 'IDR', 71466912.00, 0.00, '[{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO TURQUOISE (with Head Cover)","item_code":"50056","qty":1.0,"unit_price":8482320.0,"landed_unit_price":8482320.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO PINK","item_code":"50056","qty":1.0,"unit_price":6960888.0,"landed_unit_price":6960888.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO YELLOW","item_code":"50056","qty":1.0,"unit_price":6960888.0,"landed_unit_price":6960888.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO BLACK (with Head Cover)","item_code":"50056","qty":1.0,"unit_price":8482320.0,"landed_unit_price":8482320.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO BLUE","item_code":"50056","qty":1.0,"unit_price":6960888.0,"landed_unit_price":6960888.0},{"item_name":"RODDIO GOLF BAG - PREMIUM STAND BAG - STICH LOGO TURQUOISE (with Head Cover)","item_code":"50056","qty":1.0,"unit_price":7701408.0,"landed_unit_price":7701408.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO PINK","item_code":"50057","qty":1.0,"unit_price":6072264.0,"landed_unit_price":6072264.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO YELLOW","item_code":"50057","qty":1.0,"unit_price":6072264.0,"landed_unit_price":6072264.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO BLACK (with Head Cover)","item_code":"50057","qty":1.0,"unit_price":7701408.0,"landed_unit_price":7701408.0},{"item_name":"RODDIO GOLF BAG - PREMIUM CART BAG - STICH LOGO BLUE","item_code":"50057","qty":1.0,"unit_price":6072264.0,"landed_unit_price":6072264.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-02-25'::timestamptz, null, null, v_batch
    );
  end if;
  -- 2026-0030 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0030') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-03-11|1221 100 1001 3251' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0030', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0030', '2026-03-05', 'Golf Solutions (attn: Mr Jack)', 'CBD',
      167103090.00, 'IDR', 167103090.00, 0.00, '[{"item_name":"RODDIO IRON HEAD 22 PC CUSTOM (STD / DLC)","item_code":"30523","qty":90.0,"unit_price":1758980.0,"landed_unit_price":1758980.0},{"item_name":"RODDIO IRON HEAD PARTS for DEMO (IRON ADAPTOR)","item_code":"70215","qty":30.0,"unit_price":293163.0,"landed_unit_price":293163.0},{"item_name":"RODDIO IRON HEAD 22 PC IRON DEMO (FOC, incl. name tags x10 + number tags x10)","item_code":"70208","qty":2.0,"unit_price":0.0,"landed_unit_price":0.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'BRIfast wire MYR 37,620.00 (11 Mar 2026, Ref 218708006866691) matching this invoice exactly, per standing instruction from PT Solusi Golf Indonesia. Remittance advice: Nominal Debet IDR 167,103,129.00 (rate 4,441.87 IDR/MYR), fee IDR 596,225, Total Debet IDR 167,699,354.00 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-03-05'::timestamptz, '2026-03-11'::timestamptz, v_user, v_batch
    );
  end if;
  -- 2026-0054 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0054') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-04-21|1221 100 1001 3251' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0054', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0054', '2026-04-15', 'Golf Solutions (attn: Mr Jack)', 'CBD',
      53857790.00, 'IDR', 53857790.00, 0.00, '[{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD DI 75S","item_code":"20013","qty":4.0,"unit_price":2002382.0,"landed_unit_price":2002382.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD DI 75X","item_code":"20013","qty":2.0,"unit_price":2002382.0,"landed_unit_price":2002382.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD DI 85S","item_code":"20013","qty":2.0,"unit_price":2002382.0,"landed_unit_price":2002382.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD DI 85X","item_code":"20013","qty":2.0,"unit_price":2002382.0,"landed_unit_price":2002382.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD HY 75S","item_code":"20015","qty":3.0,"unit_price":1746472.0,"landed_unit_price":1746472.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD UT 65R","item_code":"20167","qty":3.0,"unit_price":1746472.0,"landed_unit_price":1746472.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD UT 65S","item_code":"20167","qty":3.0,"unit_price":1746472.0,"landed_unit_price":1746472.0},{"item_name":"GRAPHITE DESIGN SHAFT HY TOUR AD UT 75S","item_code":"20167","qty":3.0,"unit_price":1746472.0,"landed_unit_price":1746472.0},{"item_name":"GRAPHITE DESIGN SHAFT FW TOUR AD F 65S","item_code":"20012","qty":2.0,"unit_price":2146051.0,"landed_unit_price":2146051.0},{"item_name":"GRAPHITE DESIGN SHAFT FW TOUR AD F 75S","item_code":"20012","qty":2.0,"unit_price":2146051.0,"landed_unit_price":2146051.0},{"item_name":"GRAPHITE DESIGN SHAFT FW TOUR AD F 85S","item_code":"20012","qty":2.0,"unit_price":2146051.0,"landed_unit_price":2146051.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'BRIfast wire MYR 11,996.00 (21 Apr 2026, Ref 218708007204691, per standing instruction 004/04/SGI/2026 ''AE BRI 21 APRIL 2026'') matching this invoice exactly. Only the SWIFT MX message is on file - no IDR debit known, so Amount Paid is the ESTIMATED IDR value (rate ~4,489.65, nearest real MYR rate); update when the IDR remittance advice arrives. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-15'::timestamptz, '2026-04-21'::timestamptz, v_user, v_batch
    );
  end if;
  -- 2026-0061 (AE Sports Sdn Bhd (Impact Golf))
  if not exists (select 1 from public.payment_requests where ref_number = '2026-0061') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-05-06|1221 100 1001 3251' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'AE Sports Sdn Bhd (Impact Golf) — 2026-0061', 'AE Sports Sdn Bhd (Impact Golf)', '2026-0061', '2026-04-27', 'Golf Solutions (attn: Mr Jack)', '(not stated)',
      133794293.00, 'IDR', 133794293.00, 0.00, '[{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT IRON 2025 1 SERIES SUN / STAR / MOON","item_code":"20391","qty":1.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO SHAFT FW F-3 / F-4 / F-5 / F-6 SUN / STAR / MOON","item_code":"20388","qty":4.0,"unit_price":2094218.0,"landed_unit_price":2094218.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":4.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":5.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":60.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":9.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":7.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":7.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":10.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":10.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":10.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"RODDIO FERRULE for IRON HONEYCOMB - 18MM","item_code":"40027","qty":3.0,"unit_price":81593.0,"landed_unit_price":81593.0},{"item_name":"GOLF PRIDE PUTTER GRIP - ZERO TAPER (RED/BLUE/BLACK) LARGE/MEDIUM","item_code":"10176","qty":2.0,"unit_price":194916.0,"landed_unit_price":194916.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP PUTTER STD","item_code":"10177","qty":1.0,"unit_price":326372.0,"landed_unit_price":326372.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":10.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":4.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":50.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":3.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":10.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":8.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":7.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":10.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO GRIP CADERO","item_code":"10160","qty":10.0,"unit_price":176785.0,"landed_unit_price":176785.0},{"item_name":"RODDIO IRON HEAD PC LT CUSTOM","item_code":"30524","qty":32.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO IRON HEAD PC LT CUSTOM","item_code":"30524","qty":8.0,"unit_price":1495870.0,"landed_unit_price":1495870.0},{"item_name":"RODDIO IRON HEAD PC LT CUSTOM","item_code":"30524","qty":8.0,"unit_price":1495870.0,"landed_unit_price":1495870.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'AE Sports Sdn Bhd', '1221 100 1001 3251', 'BRIfast wire MYR 29,516.00 (6 May 2026, Ref 218708007329691) matching this invoice exactly. Remittance advice: Nominal Debet IDR 133,794,237.15 (rate 4,532.94 IDR/MYR), fee IDR 612,325, Total Debet IDR 134,406,562.15 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-27'::timestamptz, '2026-05-06'::timestamptz, v_user, v_batch
    );
  end if;
  -- SG-COMM-260428 (SG Performance Sdn. Bhd.)
  if not exists (select 1 from public.payment_requests where ref_number = 'SG-COMM-260428') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-04-28|141030013012092' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'SG Performance Sdn. Bhd. — SG-COMM-260428', 'SG Performance Sdn. Bhd.', 'SG-COMM-260428', '2026-04-28', 'CV Teknologi Keahlian Olahraga (sender)', 'International wire (MYR)',
      31234511.00, 'IDR', 31234511.00, 0.00, '[{"item_name":"Sales commission / service fee (MYR 6,957.01) - no invoice issued","item_code":"N/A","qty":1.0,"unit_price":31234511.0,"landed_unit_price":31234511.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'SG Performance Sdn. Bhd.', '141030013012092', 'Commission wire MYR 6,957.01 (Ref 218708007259691), user-confirmed as service commission - no invoice. Remittance advice: Nominal Debet IDR 31,234,511.00 + fee IDR 520,500 = Total Debet IDR 31,755,011.00 = Amount Paid. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-04-28'::timestamptz, '2026-04-28'::timestamptz, v_user, v_batch
    );
  end if;
  -- SG-COMM-260617 (SG Performance Sdn. Bhd.)
  if not exists (select 1 from public.payment_requests where ref_number = 'SG-COMM-260617') then
    select id into v_batch from public.disbursement_batches where note = 'gsimport:2026-06-17|141030013012092' limit 1;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'SG Performance Sdn. Bhd. — SG-COMM-260617', 'SG Performance Sdn. Bhd.', 'SG-COMM-260617', '2026-06-17', 'PT Solusi Golf Indonesia (sender)', 'International wire (MYR)',
      75655821.00, 'IDR', 75655821.00, 0.00, '[{"item_name":"Sales commission / service fee (MYR 16,800.00) - no invoice issued","item_code":"N/A","qty":1.0,"unit_price":75655821.0,"landed_unit_price":75655821.0}]'::jsonb, null,
      'Alliance Bank Malaysia Berhad', 'SG Performance Sdn. Bhd.', '141030013012092', 'Commission wire MYR 16,800.00 (Ref 218708007732691), user-confirmed as service commission - no invoice. SWIFT MX only, no IDR advice - Amount Paid is the ESTIMATED IDR value at the same-day CSR wire rate; no fee included since the actual Total Debet is unknown. | Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-06-17'::timestamptz, '2026-06-17'::timestamptz, v_user, v_batch
    );
  end if;
  -- TNA/IN/0431/26 (PT. Tri Nara Adyasa (Golf Gift))
  if not exists (select 1 from public.payment_requests where ref_number = 'TNA/IN/0431/26') then
    v_batch := null;
    insert into public.payment_requests (
      requester_id, request_type, title, payee_name, ref_number, invoice_date, buyer, payment_terms,
      amount, currency, gross_subtotal, discount_total, items, charges,
      bank_name, bank_account_name, bank_account_number, description,
      status, reviewed_by, reviewed_at, paid_at, paid_by, batch_id
    ) values (
      v_user, 'supplier', 'PT. Tri Nara Adyasa (Golf Gift) — TNA/IN/0431/26', 'PT. Tri Nara Adyasa (Golf Gift)', 'TNA/IN/0431/26', '2026-08-21', 'PT. Solusi Golf Indonesia (attn: Mr. Benny NG)', 'Bank Transfer',
      76300000.00, 'IDR', 68738740.00, 0.00, '[{"item_name":"GTS ENHANCED DRIVER HEADS","item_code":"N/A","qty":6.0,"unit_price":2972973.0,"landed_unit_price":3299999.96944954},{"item_name":"GTS ENHANCED FAIRWAY HEADS","item_code":"N/A","qty":8.0,"unit_price":1576576.625,"landed_unit_price":1750000.02163991},{"item_name":"GTS ENHANCED DRIVER SHAFTS","item_code":"N/A","qty":12.0,"unit_price":1126126.16666667,"landed_unit_price":1250000.02206422},{"item_name":"GTS ENHANCED FAIRWAY SHAFT","item_code":"N/A","qty":22.0,"unit_price":1126126.13636364,"landed_unit_price":1249999.98842786}]'::jsonb, '[{"name":"Tax / PPN","amount":7561260.0}]'::jsonb,
      'BCA KCP Ampera Raya', 'PT. Tri Nara Adyasa', '5855-855833', 'Imported from GS Purchasing compilation.',
      'approved', v_user, '2026-08-21'::timestamptz, null, null, v_batch
    );
  end if;
end $$;

-- verify
select count(*) as imported_invoices from public.payment_requests where description like '%Imported from GS Purchasing compilation%';
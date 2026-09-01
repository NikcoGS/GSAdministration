-- ============================================================================
-- GS Purchasing import — PART 1 of 4  (26 invoices)
-- Run the parts in order. Each part is safe to re-run; existing rows are skipped.
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

  select id into v_user from public.profiles where email = 'nikco@golfsolutionsid.com' limit 1;
  if v_user is null then raise exception 'No profile found for nikco@golfsolutionsid.com - sign up in the app first.'; end if;

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
end $$;

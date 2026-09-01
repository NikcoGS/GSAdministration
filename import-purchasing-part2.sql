-- ============================================================================
-- GS Purchasing import — PART 2 of 4  (26 invoices)
-- Run the parts in order. Each part is safe to re-run; existing rows are skipped.
-- ============================================================================
do $$
declare v_user uuid; v_batch uuid;
begin
  select id into v_user from public.profiles where email = 'nikco@golfsolutionsid.com' limit 1;
  if v_user is null then raise exception 'No profile found for nikco@golfsolutionsid.com - sign up in the app first.'; end if;

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
end $$;

-- ============================================================================
-- GS Purchasing import — PART 3 of 4  (26 invoices)
-- Run the parts in order. Each part is safe to re-run; existing rows are skipped.
-- ============================================================================
do $$
declare v_user uuid; v_batch uuid;
begin
  select id into v_user from public.profiles where email = 'nikco@golfsolutionsid.com' limit 1;
  if v_user is null then raise exception 'No profile found for nikco@golfsolutionsid.com - sign up in the app first.'; end if;

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
end $$;

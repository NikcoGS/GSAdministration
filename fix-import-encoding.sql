-- Repair mojibake from the import: the em dash (U+2014) was stored as the
-- Mac-Roman reading of its UTF-8 bytes, i.e. U+201A U+00C4 U+00EE.
-- chr() keeps this script pure ASCII so it cannot be re-corrupted in transit.
update public.payment_requests
set title = replace(title, chr(8218) || chr(196) || chr(238), '-')
where title like '%' || chr(8218) || chr(196) || chr(238) || '%';

update public.payment_requests
set description = replace(description, chr(8218) || chr(196) || chr(238), '-')
where description like '%' || chr(8218) || chr(196) || chr(238) || '%';

-- tidy any doubled spaces left behind
update public.payment_requests set title = replace(title, '  ', ' ') where title like '%  %';

-- check: should return 0
select count(*) as still_mangled
from public.payment_requests
where title like '%' || chr(8218) || chr(196) || chr(238) || '%'
   or description like '%' || chr(8218) || chr(196) || chr(238) || '%';

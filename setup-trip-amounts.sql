-- ============================================================================
-- GS Operational System — trip claims split into mileage + additional fees
-- trip_value      = total_km x the rate for the vehicle (1,500 motorcycle /
--                   3,000 car per km, set in config.js)
-- additional_fees = parking, toll and similar out-of-pocket costs
-- amount          = trip_value + additional_fees (the total claimed)
-- Run ONCE in the Supabase SQL Editor. Safe to re-run.
-- ============================================================================

alter table public.trip_reimbursements add column if not exists trip_value      numeric(14,2);
alter table public.trip_reimbursements add column if not exists additional_fees numeric(14,2);

-- ============================================================================
-- DONE. Existing claims keep their single "amount"; new ones store the split.
-- ============================================================================

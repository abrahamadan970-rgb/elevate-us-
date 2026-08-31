/*
# Fix loan interest and transaction cost separation

## Problem
The previous migration (20260706105636) incorrectly added the M-Pesa transaction cost
INTO the interest_amount, then added it AGAIN when computing total_payable. This caused:
- Inflated interest (interest included the transaction cost)
- Double-counted transaction cost in total_payable

## Correct Logic
- Interest = Principal × Rate%  (strictly, NO transaction cost)
- Total Payable = Principal + Interest + Transaction Cost  (cost added once)
- Balance = Total Payable - Amount Repaid

## Changes
1. Replaces the calculate_loan_totals function with the correct formula.
2. Recalculates all existing loans with the corrected formula so historical data is fixed.
3. No schema changes, no RLS changes, no data loss.
*/

CREATE OR REPLACE FUNCTION calculate_loan_totals()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
  mpesa_cost_var decimal(10,2);
BEGIN
  -- Auto-calculate M-Pesa cost if not provided (2026 Safaricom rates)
  IF NEW.mpesa_cost IS NULL OR NEW.mpesa_cost = 0 THEN
    IF NEW.principal_amount <= 100 THEN
      mpesa_cost_var := 0;
    ELSIF NEW.principal_amount <= 500 THEN
      mpesa_cost_var := 7;
    ELSIF NEW.principal_amount <= 1000 THEN
      mpesa_cost_var := 13;
    ELSIF NEW.principal_amount <= 1500 THEN
      mpesa_cost_var := 23;
    ELSIF NEW.principal_amount <= 2500 THEN
      mpesa_cost_var := 33;
    ELSIF NEW.principal_amount <= 3500 THEN
      mpesa_cost_var := 53;
    ELSIF NEW.principal_amount <= 5000 THEN
      mpesa_cost_var := 57;
    ELSIF NEW.principal_amount <= 7500 THEN
      mpesa_cost_var := 78;
    ELSIF NEW.principal_amount <= 10000 THEN
      mpesa_cost_var := 90;
    ELSIF NEW.principal_amount <= 15000 THEN
      mpesa_cost_var := 100;
    ELSIF NEW.principal_amount <= 20000 THEN
      mpesa_cost_var := 105;
    ELSE
      mpesa_cost_var := 108;
    END IF;
    NEW.mpesa_cost := mpesa_cost_var;
  END IF;

  -- Interest = Principal × Rate% (transaction cost is NOT included in interest)
  NEW.interest_amount := NEW.principal_amount * NEW.interest_rate / 100;

  -- Total Payable = Principal + Interest + Transaction Cost (cost added once)
  NEW.total_payable := NEW.principal_amount + NEW.interest_amount + COALESCE(NEW.mpesa_cost, 0);

  -- Balance = Total Payable - Amount Repaid
  NEW.balance := NEW.total_payable - NEW.amount_repaid;

  RETURN NEW;
END;
$function$;

-- Recalculate all existing loans with the corrected formula
UPDATE loans SET
  interest_amount = principal_amount * interest_rate / 100,
  total_payable = principal_amount + (principal_amount * interest_rate / 100) + COALESCE(mpesa_cost, 0),
  balance = (principal_amount + (principal_amount * interest_rate / 100) + COALESCE(mpesa_cost, 0)) - amount_repaid;

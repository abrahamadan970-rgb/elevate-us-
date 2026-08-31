/*
  Fix total_payable to be: principal + transaction_cost + interest_amount
  interest_amount = (principal * rate%) + transaction_cost  (unchanged)
  total_payable  = principal + mpesa_cost + interest_amount  (transaction cost added separately)
*/
CREATE OR REPLACE FUNCTION public.calculate_loan_totals()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
  mpesa_cost_var decimal(10,2);
BEGIN
  -- Calculate M-Pesa / transaction cost based on amount
  IF NEW.principal_amount <= 100 THEN
    mpesa_cost_var := 0;
  ELSIF NEW.principal_amount <= 500 THEN
    mpesa_cost_var := 11;
  ELSIF NEW.principal_amount <= 1000 THEN
    mpesa_cost_var := 15;
  ELSIF NEW.principal_amount <= 1500 THEN
    mpesa_cost_var := 17;
  ELSIF NEW.principal_amount <= 2500 THEN
    mpesa_cost_var := 25;
  ELSIF NEW.principal_amount <= 3500 THEN
    mpesa_cost_var := 47;
  ELSIF NEW.principal_amount <= 5000 THEN
    mpesa_cost_var := 52;
  ELSIF NEW.principal_amount <= 10000 THEN
    mpesa_cost_var := 87;
  ELSIF NEW.principal_amount <= 20000 THEN
    mpesa_cost_var := 167;
  ELSIF NEW.principal_amount <= 35000 THEN
    mpesa_cost_var := 252;
  ELSIF NEW.principal_amount <= 50000 THEN
    mpesa_cost_var := 307;
  ELSIF NEW.principal_amount <= 100000 THEN
    mpesa_cost_var := 557;
  ELSE
    mpesa_cost_var := 0;
  END IF;

  NEW.mpesa_cost := COALESCE(NEW.mpesa_cost, mpesa_cost_var);

  -- Interest = (principal * rate%) + transaction cost
  NEW.interest_amount := (NEW.principal_amount * NEW.interest_rate / 100) + NEW.mpesa_cost;

  -- Total payable = principal + transaction cost + interest
  NEW.total_payable := NEW.principal_amount + NEW.mpesa_cost + NEW.interest_amount;

  NEW.balance := NEW.total_payable - NEW.amount_repaid;

  RETURN NEW;
END;
$function$;

-- Recalculate all existing loans with the corrected formula
UPDATE loans SET
  mpesa_cost = COALESCE(mpesa_cost, 0),
  interest_amount = (principal_amount * interest_rate / 100) + COALESCE(mpesa_cost, 0),
  total_payable = principal_amount + COALESCE(mpesa_cost, 0) + ((principal_amount * interest_rate / 100) + COALESCE(mpesa_cost, 0)),
  balance = (principal_amount + COALESCE(mpesa_cost, 0) + ((principal_amount * interest_rate / 100) + COALESCE(mpesa_cost, 0))) - amount_repaid;

/*
# Update loan interest calculation to include transaction cost

1. Changes
- Modifies the `calculate_loan_totals()` trigger function.
- Interest amount now = (principal * interest_rate / 100) + mpesa_cost
  (5% of principal PLUS the transaction/M-Pesa cost)
- total_payable = principal + interest_amount (mpesa_cost is already folded into interest_amount, not added separately)
- balance = total_payable - amount_repaid

2. Notes
- The M-Pesa cost tier calculation logic remains unchanged.
- If a loan already has mpesa_cost set (COALESCE), it is reused.
- For recording past loans, the front-end will pass mpesa_cost explicitly when desired.
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

  -- Total payable = principal + interest (interest already includes transaction cost)
  NEW.total_payable := NEW.principal_amount + NEW.interest_amount;

  NEW.balance := NEW.total_payable - NEW.amount_repaid;

  RETURN NEW;
END;
$function$;

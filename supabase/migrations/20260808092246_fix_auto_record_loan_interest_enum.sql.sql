CREATE OR REPLACE FUNCTION public.auto_record_loan_interest()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
repay_month int;
repay_year  int;
earned      numeric;
existing_id uuid;
BEGIN
-- Only act when status changes TO 'repaid'
IF NEW.status = 'repaid' AND (OLD.status IS DISTINCT FROM 'repaid') THEN
-- Use updated_at date as the repayment month/year
repay_month := EXTRACT(MONTH FROM NEW.updated_at);
repay_year  := EXTRACT(YEAR  FROM NEW.updated_at);
earned      := COALESCE(NEW.interest_amount, 0) + COALESCE(NEW.mpesa_cost, 0);

-- Check if a manual entry already exists for this month/year
SELECT id INTO existing_id
FROM monthly_interest
WHERE month = repay_month AND year = repay_year AND source_type = 'auto' AND loan_id = NEW.id;

IF existing_id IS NOT NULL THEN
-- Update existing auto entry for this specific loan
UPDATE monthly_interest
SET amount = earned, updated_at = now()
WHERE id = existing_id;
ELSE
-- Insert new auto entry
INSERT INTO monthly_interest (month, year, amount, source_type, loan_id, notes)
VALUES (
repay_month,
repay_year,
earned,
'auto',
NEW.id,
'Auto-recorded: loan repaid by member'
);
END IF;
END IF;
RETURN NEW;
END;
$function$;

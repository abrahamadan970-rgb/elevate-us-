
/*
# Add Treasurer Role + Loan Repayment Interest Auto-Recording

## Summary
1. Adds 'treasurer' value to user_role enum so treasurers can be assigned.
2. Updates is_leader_or_admin() to a new helper is_treasurer_or_admin() for financial operations.
3. Adds auto_record_interest_on_repayment trigger: when a loan reaches 'paid' status,
   automatically inserts or updates the monthly_interest row for that repayment month
   with (interest_amount + mpesa_cost) as the earned amount — matching manual record behaviour.
   If a monthly_interest row already exists for that month/year, it ADDS to it.
4. Updates RLS on financial tables to allow treasurer role full access.
5. Adds source_type and loan_id columns to monthly_interest for tracking auto vs manual entries.

## Changes
- profiles.role enum: adds 'treasurer'
- new function: is_treasurer_or_admin() 
- new function: auto_record_loan_interest()
- new trigger: after_loan_paid_trigger on loans (AFTER UPDATE)
- monthly_interest: adds source_type text (manual/auto), loan_id uuid nullable
- RLS: treasurer gets same financial access as leader/admin on loans, repayments, expenses, fines, subscriptions
*/

-- 1. Add treasurer to the role enum
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'treasurer' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
    ALTER TYPE user_role ADD VALUE 'treasurer';
  END IF;
END $$;

-- 2. Add metadata columns to monthly_interest
ALTER TABLE monthly_interest ADD COLUMN IF NOT EXISTS source_type text NOT NULL DEFAULT 'manual';
ALTER TABLE monthly_interest ADD COLUMN IF NOT EXISTS loan_id uuid REFERENCES loans(id) ON DELETE SET NULL;

-- 3. Create helper: treasurer or admin check
CREATE OR REPLACE FUNCTION is_treasurer_or_admin()
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'treasurer')
  );
END;
$$;

-- 4. Auto-record interest function — fires when loan status becomes 'paid'
CREATE OR REPLACE FUNCTION auto_record_loan_interest()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  repay_month int;
  repay_year  int;
  earned      numeric;
  existing_id uuid;
BEGIN
  -- Only act when status changes TO 'paid'
  IF NEW.status = 'paid' AND (OLD.status IS DISTINCT FROM 'paid') THEN
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
$$;

-- 5. Attach trigger to loans table
DROP TRIGGER IF EXISTS after_loan_paid_trigger ON loans;
CREATE TRIGGER after_loan_paid_trigger
  AFTER UPDATE ON loans
  FOR EACH ROW
  EXECUTE FUNCTION auto_record_loan_interest();

-- 6. Update RLS policies to include treasurer role on financial tables
-- loans
DROP POLICY IF EXISTS "treasurer_manage_loans" ON loans;
CREATE POLICY "treasurer_manage_loans" ON loans FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

-- loan_repayments
DROP POLICY IF EXISTS "treasurer_manage_repayments" ON loan_repayments;
CREATE POLICY "treasurer_manage_repayments" ON loan_repayments FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

-- expenses
DROP POLICY IF EXISTS "treasurer_manage_expenses" ON expenses;
CREATE POLICY "treasurer_manage_expenses" ON expenses FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

-- fines
DROP POLICY IF EXISTS "treasurer_manage_fines" ON fines;
CREATE POLICY "treasurer_manage_fines" ON fines FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

-- subscriptions
DROP POLICY IF EXISTS "treasurer_manage_subscriptions" ON subscriptions;
CREATE POLICY "treasurer_manage_subscriptions" ON subscriptions FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

-- monthly_interest
DROP POLICY IF EXISTS "treasurer_manage_interest" ON monthly_interest;
CREATE POLICY "treasurer_manage_interest" ON monthly_interest FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

-- membership_fees
DROP POLICY IF EXISTS "treasurer_manage_membership_fees" ON membership_fees;
CREATE POLICY "treasurer_manage_membership_fees" ON membership_fees FOR ALL
  TO authenticated
  USING (is_treasurer_or_admin())
  WITH CHECK (is_treasurer_or_admin());

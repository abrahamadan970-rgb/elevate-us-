/*
# Add repayment_type column to loan_repayments

1. Changes
- Adds `repayment_type` column to `loan_repayments` table.
- Values: 'full' (default, normal repayment) or 'interest' (interest-only payment where the loan principal is carried forward).
- Backfills existing rows to 'full'.

2. Notes
- This lets the app distinguish a normal repayment from an interest-only payment
  where the member pays only the interest + transaction cost and carries the
  principal forward as a new outstanding loan.
*/

ALTER TABLE loan_repayments
  ADD COLUMN IF NOT EXISTS repayment_type text NOT NULL DEFAULT 'full';

-- Backfill any existing rows
UPDATE loan_repayments SET repayment_type = 'full' WHERE repayment_type IS NULL OR repayment_type NOT IN ('full', 'interest');

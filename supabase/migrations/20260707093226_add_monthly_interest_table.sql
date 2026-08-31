/*
# Add monthly_interest table for tracking total interest per month

1. New Tables
- `monthly_interest`: stores the total interest figure for a given month/year.
  - `id` (uuid PK)
  - `month` (integer 1-12, NOT NULL)
  - `year` (integer, NOT NULL)
  - `amount` (decimal, NOT NULL) - the manually-entered total interest for that month
  - `notes` (text, nullable)
  - `created_at` / `updated_at` timestamps
  - UNIQUE constraint on (month, year) so each month has at most one entry.

2. Security
- Enable RLS on `monthly_interest`.
- Owner-scoped CRUD for authenticated users (the app has a sign-in screen).
  Note: the owner default uses auth.uid() but this table is association-wide
  shared data, so we scope to authenticated users broadly (any signed-in user
  can manage interest entries), consistent with the other admin tables.
*/

CREATE TABLE IF NOT EXISTS monthly_interest (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  month integer NOT NULL CHECK (month >= 1 AND month <= 12),
  year integer NOT NULL,
  amount decimal(14,2) NOT NULL DEFAULT 0,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT monthly_interest_month_year_key UNIQUE (month, year)
);

ALTER TABLE monthly_interest ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_monthly_interest" ON monthly_interest;
CREATE POLICY "select_monthly_interest"
ON monthly_interest FOR SELECT
TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_monthly_interest" ON monthly_interest;
CREATE POLICY "insert_monthly_interest"
ON monthly_interest FOR INSERT
TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_monthly_interest" ON monthly_interest;
CREATE POLICY "update_monthly_interest"
ON monthly_interest FOR UPDATE
TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_monthly_interest" ON monthly_interest;
CREATE POLICY "delete_monthly_interest"
ON monthly_interest FOR DELETE
TO authenticated USING (true);

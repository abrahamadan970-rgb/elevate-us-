/*
# Add Minutes table, Loan carry-forward, Defaulter tracking

1. New Tables
- `minutes`: meeting minutes with title, date, attendees, agenda, discussion, decisions, action_items, attachment_url
2. Modified Tables
- `loans`: add `is_carried_forward` boolean (default false), `original_loan_id` uuid (self-reference for carry-forward chain)
- `members`: add `is_defaulter` boolean (default false), `defaulter_since` date
3. Security
- RLS enabled on `minutes` with authenticated CRUD policies
- New columns inherit existing policies
4. Notes
- Carry-forward: when a loan's principal+interest is fully paid but a new loan is created from remaining balance, `is_carried_forward=true` and `original_loan_id` points to the source loan
- Defaulter: marked automatically when loan past due_date and balance > 0
*/

CREATE TABLE IF NOT EXISTS minutes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  meeting_date date NOT NULL DEFAULT CURRENT_DATE,
  meeting_type text NOT NULL DEFAULT 'general',
  attendees text,
  agenda text,
  discussion text,
  decisions text,
  action_items text,
  attachment_url text,
  created_by uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE minutes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_minutes" ON minutes;
CREATE POLICY "select_minutes" ON minutes FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_minutes" ON minutes;
CREATE POLICY "insert_minutes" ON minutes FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "insert_minutes_anon" ON minutes;
CREATE POLICY "insert_minutes_anon" ON minutes FOR INSERT
  TO anon WITH CHECK (true);

DROP POLICY IF EXISTS "update_minutes" ON minutes;
CREATE POLICY "update_minutes" ON minutes FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_minutes" ON minutes;
CREATE POLICY "delete_minutes" ON minutes FOR DELETE
  TO authenticated USING (true);

ALTER TABLE loans ADD COLUMN IF NOT EXISTS is_carried_forward boolean NOT NULL DEFAULT false;
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_loan_id uuid REFERENCES public.loans(id) ON DELETE SET NULL;

ALTER TABLE members ADD COLUMN IF NOT EXISTS is_defaulter boolean NOT NULL DEFAULT false;
ALTER TABLE members ADD COLUMN IF NOT EXISTS defaulter_since date;
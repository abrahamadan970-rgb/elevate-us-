/*
# Add membership_fees table

1. New Tables
- `membership_fees` — tracks annual membership renewal fees (100 KES per member per year)
  - `id` (uuid, primary key)
  - `member_id` (uuid, FK to members, cascade delete)
  - `amount` (decimal, not null)
  - `fee_year` (integer, not null) — the year the membership fee covers
  - `payment_date` (date, not null)
  - `payment_method` (text, default 'cash')
  - `receipt_number` (text, nullable)
  - `notes` (text, nullable)
  - `recorded_by` (uuid, FK to profiles, nullable)
  - `created_at` (timestamptz, default now())

2. Security
- Enable RLS on `membership_fees`.
- All authenticated users can read (leaders/admins manage).
- Leaders/admins can insert/update/delete (via is_leader_or_admin()).

3. Data
- Inserts 2 years of membership fees for all 7 active members:
  - Year 2025: 7 members × 100 = 700
  - Year 2026: 7 members × 100 = 700
  - Grand total: 1400

4. Indexes
- Index on member_id and fee_year for performance.
*/

CREATE TABLE IF NOT EXISTS membership_fees (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  amount decimal(12,2) NOT NULL,
  fee_year integer NOT NULL,
  payment_date date NOT NULL,
  payment_method text DEFAULT 'cash',
  receipt_number text,
  notes text,
  recorded_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE membership_fees ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "authenticated_read_membership_fees" ON membership_fees;
CREATE POLICY "authenticated_read_membership_fees" ON membership_fees FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_membership_fees" ON membership_fees;
CREATE POLICY "leader_manage_membership_fees" ON membership_fees
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

CREATE INDEX IF NOT EXISTS idx_membership_fees_member_id ON membership_fees(member_id);
CREATE INDEX IF NOT EXISTS idx_membership_fees_fee_year ON membership_fees(fee_year);

-- Insert 2 years of membership fees for all active members
INSERT INTO membership_fees (member_id, amount, fee_year, payment_date, payment_method, notes)
SELECT id, 100.00, y.fee_year,
  make_date(y.fee_year, 1, 10),
  'cash',
  'Annual membership renewal fee'
FROM members m
CROSS JOIN (VALUES (2025), (2026)) AS y(fee_year)
WHERE m.status = 'active';

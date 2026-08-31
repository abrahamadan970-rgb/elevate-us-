/*
# ElevateUS Association Management System - Initial Schema

This migration creates the complete database structure for the ElevateUS Association Management System.

## New Tables

1. **profiles** - Extended user data linked to auth.users with roles (admin, leader, member)
2. **members** - Association member details (name, phone, email, join date, status)
3. **subscriptions** - Monthly subscription payments per member with variable amounts
4. **loans** - Loan records with interest calculation and repayment tracking
5. **fines** - Member fines (lateness, absence, misconduct, etc.)
6. **expenses** - Association expenditures with categories
7. **events** - Association events and meetings (AGM, board meetings, etc.)
8. **leaders** - Leadership positions and role descriptions
9. **activity_log** - Real-time activity tracking for the feed
10. **settings** - System configuration (reserve percentage, etc.)
11. **constitution** - Association constitution content

## Security

- RLS enabled on all tables
- Policies restrict access based on user authentication and roles
- Admin/Leader roles have broader access, Members have limited access
- All tables use `TO authenticated` with appropriate ownership/membership checks

## Notes

1. The association started November 2024 with 4 members
2. First subscription was Ksh 200 in December 2024
3. Loan interest is 5% per month
4. Late payment penalty is 1% per day
5. Reserve is 25% of total income (adjustable)
6. Minimum balance after loan = Ksh 1500
7. Member must be active for 3+ months to qualify for loans
8. All monetary values stored as DECIMAL for precision
*/

-- Enable UUID extension if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enum types
CREATE TYPE user_role AS ENUM ('admin', 'leader', 'member');
CREATE TYPE member_status AS ENUM ('active', 'inactive', 'left');
CREATE TYPE loan_status AS ENUM ('pending', 'approved', 'disbursed', 'repaid', 'defaulted');
CREATE TYPE event_type AS ENUM ('agm', 'board_meeting', 'special_meeting', 'social', 'other');

-- Create profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL,
  full_name text NOT NULL,
  role user_role NOT NULL DEFAULT 'member',
  phone text,
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create members table
CREATE TABLE IF NOT EXISTS members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  full_name text NOT NULL,
  phone text,
  email text,
  join_date date NOT NULL DEFAULT CURRENT_DATE,
  status member_status NOT NULL DEFAULT 'active',
  leave_date date,
  leave_reason text,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  amount decimal(12,2) NOT NULL,
  payment_date date NOT NULL,
  payment_month integer NOT NULL,
  payment_year integer NOT NULL,
  payment_method text DEFAULT 'cash',
  receipt_number text,
  notes text,
  recorded_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Create loans table
CREATE TABLE IF NOT EXISTS loans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  principal_amount decimal(12,2) NOT NULL,
  interest_rate decimal(5,2) NOT NULL DEFAULT 5.00,
  interest_amount decimal(12,2) NOT NULL DEFAULT 0,
  mpesa_cost decimal(10,2) DEFAULT 0,
  total_payable decimal(12,2) NOT NULL DEFAULT 0,
  amount_repaid decimal(12,2) NOT NULL DEFAULT 0,
  balance decimal(12,2) NOT NULL DEFAULT 0,
  issue_date date NOT NULL DEFAULT CURRENT_DATE,
  due_date date NOT NULL,
  status loan_status NOT NULL DEFAULT 'pending',
  penalty_rate decimal(5,2) NOT NULL DEFAULT 1.00,
  penalty_amount decimal(12,2) NOT NULL DEFAULT 0,
  approved_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create loan repayments table
CREATE TABLE IF NOT EXISTS loan_repayments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
  amount decimal(12,2) NOT NULL,
  payment_date date NOT NULL DEFAULT CURRENT_DATE,
  payment_method text DEFAULT 'cash',
  notes text,
  recorded_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Create fines table
CREATE TABLE IF NOT EXISTS fines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  fine_type text NOT NULL,
  amount decimal(12,2) NOT NULL,
  reason text,
  issue_date date NOT NULL DEFAULT CURRENT_DATE,
  paid boolean NOT NULL DEFAULT false,
  paid_date date,
  recorded_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Create expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL,
  description text NOT NULL,
  amount decimal(12,2) NOT NULL,
  expense_date date NOT NULL DEFAULT CURRENT_DATE,
  receipt_url text,
  approved_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  recorded_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Create events table
CREATE TABLE IF NOT EXISTS events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  event_type event_type NOT NULL DEFAULT 'other',
  event_date date NOT NULL,
  event_time time,
  location text,
  is_recurring boolean DEFAULT false,
  recurrence_pattern text,
  created_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create leaders table
CREATE TABLE IF NOT EXISTS leaders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  position text NOT NULL UNIQUE,
  position_description text,
  member_id uuid REFERENCES members(id) ON DELETE SET NULL,
  start_date date NOT NULL DEFAULT CURRENT_DATE,
  end_date date,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create settings table
CREATE TABLE IF NOT EXISTS settings (
  id integer PRIMARY KEY DEFAULT 1,
  reserve_percentage decimal(5,2) NOT NULL DEFAULT 25.00,
  min_loan_balance decimal(12,2) NOT NULL DEFAULT 1500.00,
  default_interest_rate decimal(5,2) NOT NULL DEFAULT 5.00,
  default_penalty_rate decimal(5,2) NOT NULL DEFAULT 1.00,
  min_membership_months integer NOT NULL DEFAULT 3,
  association_name text NOT NULL DEFAULT 'ElevateUS',
  association_motto text NOT NULL DEFAULT 'Rise together, achieve more',
  association_email text,
  association_phone text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT single_settings_row CHECK (id = 1)
);

-- Create constitution table
CREATE TABLE IF NOT EXISTS constitution (
  id integer PRIMARY KEY DEFAULT 1,
  name text NOT NULL DEFAULT 'ElevateUS',
  motto text NOT NULL DEFAULT 'Rise together, achieve more',
  mission text,
  vision text,
  objectives text,
  membership_rules text,
  code_of_conduct text,
  financial_rules text,
  amendment_rules text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT single_constitution_row CHECK (id = 1)
);

-- Create activity_log table
CREATE TABLE IF NOT EXISTS activity_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id uuid,
  description text NOT NULL,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now()
);

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title text NOT NULL,
  message text NOT NULL,
  type text NOT NULL,
  is_read boolean NOT NULL DEFAULT false,
  link text,
  created_at timestamptz DEFAULT now()
);

-- Insert default settings
INSERT INTO settings (id, reserve_percentage, min_loan_balance, default_interest_rate, default_penalty_rate, min_membership_months)
VALUES (1, 25.00, 1500.00, 5.00, 1.00, 3)
ON CONFLICT (id) DO NOTHING;

-- Insert default constitution
INSERT INTO constitution (id, name, motto, mission, vision, objectives, membership_rules, code_of_conduct, financial_rules, amendment_rules)
VALUES (
  1,
  'ElevateUS',
  'Rise together, achieve more',
  'To empower members through financial support, shared resources, and collective growth for mutual prosperity.',
  'A thriving community of members achieving financial stability and personal growth together.',
  '1. Promote financial wellness among members
2. Provide affordable loans to members
3. Foster a culture of saving and investment
4. Support members during times of need
5. Create opportunities for personal and professional development',
  '1. Membership is open to individuals who share our values
2. New members must be recommended by existing members
3. A non-refundable registration fee is required
4. Members must commit to monthly subscriptions
5. Members who leave must settle all outstanding balances',
  '1. Attend all scheduled meetings
2. Pay subscriptions on time
3. Respect all members
4. Maintain confidentiality of association matters
5. Act with integrity and honesty',
  '1. Monthly subscriptions are due by the 10th of each month
2. Loans attract 5% interest per month
3. Late payments attract 1% penalty per day
4. 25% of income goes to reserve fund
5. Financial records are audited annually',
  '1. Amendments require 2/3 majority vote
2. Proposed amendments must be submitted 30 days before AGM
3. All members must be notified of proposed changes
4. Emergency amendments require unanimous consent of leaders'
)
ON CONFLICT (id) DO NOTHING;

-- Insert default leadership positions
INSERT INTO leaders (position, position_description) VALUES
('Chairperson', 'Leads all meetings, represents the association externally, ensures compliance with constitution, and provides overall leadership direction.'),
('Secretary', 'Maintains all records, handles correspondence, takes minutes at meetings, manages documentation and keeps the association organized.'),
('Treasurer', 'Manages all financial transactions, maintains accurate financial records, prepares financial reports, and ensures proper fund management.'),
('Organizing Secretary', 'Plans and coordinates events, manages member activities, organizes meetings, and ensures member engagement.'),
('Special Person', 'Provides additional support, handles special assignments, and serves as an advisor to the leadership team.')
ON CONFLICT (position) DO NOTHING;

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE loan_repayments ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaders ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE constitution ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create helper function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create helper function to check if user is leader or admin
CREATE OR REPLACE FUNCTION is_leader_or_admin()
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create helper function to get user role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS user_role AS $$
DECLARE
  user_role_var user_role;
BEGIN
  SELECT role INTO user_role_var FROM profiles WHERE id = auth.uid();
  RETURN COALESCE(user_role_var, 'member'::user_role);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Profiles policies
DROP POLICY IF EXISTS "users_read_own_profile" ON profiles;
CREATE POLICY "users_read_own_profile" ON profiles FOR SELECT
  TO authenticated USING (auth.uid() = id);

DROP POLICY IF EXISTS "users_update_own_profile" ON profiles;
CREATE POLICY "users_update_own_profile" ON profiles FOR UPDATE
  TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "admin_manage_all_profiles" ON profiles;
CREATE POLICY "admin_manage_all_profiles" ON profiles
  FOR ALL TO authenticated USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "insert_profile_on_signup" ON profiles;
CREATE POLICY "insert_profile_on_signup" ON profiles FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = id);

-- Members policies (all authenticated can read, admin/leader can manage)
DROP POLICY IF EXISTS "authenticated_read_members" ON members;
CREATE POLICY "authenticated_read_members" ON members FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_members" ON members;
CREATE POLICY "leader_manage_members" ON members
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Subscriptions policies
DROP POLICY IF EXISTS "authenticated_read_subscriptions" ON subscriptions;
CREATE POLICY "authenticated_read_subscriptions" ON subscriptions FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_subscriptions" ON subscriptions;
CREATE POLICY "leader_manage_subscriptions" ON subscriptions
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Loans policies
DROP POLICY IF EXISTS "authenticated_read_loans" ON loans;
CREATE POLICY "authenticated_read_loans" ON loans FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_loans" ON loans;
CREATE POLICY "leader_manage_loans" ON loans
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Loan repayments policies
DROP POLICY IF EXISTS "authenticated_read_repayments" ON loan_repayments;
CREATE POLICY "authenticated_read_repayments" ON loan_repayments FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_repayments" ON loan_repayments;
CREATE POLICY "leader_manage_repayments" ON loan_repayments
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Fines policies
DROP POLICY IF EXISTS "authenticated_read_fines" ON fines;
CREATE POLICY "authenticated_read_fines" ON fines FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_fines" ON fines;
CREATE POLICY "leader_manage_fines" ON fines
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Expenses policies
DROP POLICY IF EXISTS "authenticated_read_expenses" ON expenses;
CREATE POLICY "authenticated_read_expenses" ON expenses FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_expenses" ON expenses;
CREATE POLICY "leader_manage_expenses" ON expenses
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Events policies
DROP POLICY IF EXISTS "authenticated_read_events" ON events;
CREATE POLICY "authenticated_read_events" ON events FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "leader_manage_events" ON events;
CREATE POLICY "leader_manage_events" ON events
  FOR ALL TO authenticated USING (is_leader_or_admin()) WITH CHECK (is_leader_or_admin());

-- Leaders policies
DROP POLICY IF EXISTS "authenticated_read_leaders" ON leaders;
CREATE POLICY "authenticated_read_leaders" ON leaders FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "admin_manage_leaders" ON leaders;
CREATE POLICY "admin_manage_leaders" ON leaders
  FOR ALL TO authenticated USING (is_admin()) WITH CHECK (is_admin());

-- Settings policies
DROP POLICY IF EXISTS "authenticated_read_settings" ON settings;
CREATE POLICY "authenticated_read_settings" ON settings FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "admin_manage_settings" ON settings;
CREATE POLICY "admin_manage_settings" ON settings
  FOR ALL TO authenticated USING (is_admin()) WITH CHECK (is_admin());

-- Constitution policies
DROP POLICY IF EXISTS "authenticated_read_constitution" ON constitution;
CREATE POLICY "authenticated_read_constitution" ON constitution FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "admin_manage_constitution" ON constitution;
CREATE POLICY "admin_manage_constitution" ON constitution
  FOR ALL TO authenticated USING (is_admin()) WITH CHECK (is_admin());

-- Activity log policies
DROP POLICY IF EXISTS "authenticated_read_activity" ON activity_log;
CREATE POLICY "authenticated_read_activity" ON activity_log FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "authenticated_insert_activity" ON activity_log;
CREATE POLICY "authenticated_insert_activity" ON activity_log FOR INSERT
  TO authenticated WITH CHECK (true);

-- Notifications policies
DROP POLICY IF EXISTS "users_read_own_notifications" ON notifications;
CREATE POLICY "users_read_own_notifications" ON notifications FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_update_own_notifications" ON notifications;
CREATE POLICY "users_update_own_notifications" ON notifications FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "leader_create_notifications" ON notifications;
CREATE POLICY "leader_create_notifications" ON notifications FOR INSERT
  TO authenticated WITH CHECK (is_leader_or_admin());

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_members_status ON members(status);
CREATE INDEX IF NOT EXISTS idx_members_join_date ON members(join_date);
CREATE INDEX IF NOT EXISTS idx_subscriptions_member_id ON subscriptions(member_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_payment_date ON subscriptions(payment_date);
CREATE INDEX IF NOT EXISTS idx_subscriptions_month_year ON subscriptions(payment_year, payment_month);
CREATE INDEX IF NOT EXISTS idx_loans_member_id ON loans(member_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON loans(status);
CREATE INDEX IF NOT EXISTS idx_loans_due_date ON loans(due_date);
CREATE INDEX IF NOT EXISTS idx_loan_repayments_loan_id ON loan_repayments(loan_id);
CREATE INDEX IF NOT EXISTS idx_fines_member_id ON fines(member_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(expense_date);
CREATE INDEX IF NOT EXISTS idx_events_date ON events(event_date);
CREATE INDEX IF NOT EXISTS idx_activity_log_created_at ON activity_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_members_updated_at BEFORE UPDATE ON members
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_loans_updated_at BEFORE UPDATE ON loans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leaders_updated_at BEFORE UPDATE ON leaders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_settings_updated_at BEFORE UPDATE ON settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_constitution_updated_at BEFORE UPDATE ON constitution
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create function to calculate loan totals
CREATE OR REPLACE FUNCTION calculate_loan_totals()
RETURNS TRIGGER AS $$
DECLARE
  mpesa_cost_var decimal(10,2);
BEGIN
  -- Calculate M-Pesa cost based on amount
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
  NEW.interest_amount := NEW.principal_amount * NEW.interest_rate / 100;
  NEW.total_payable := NEW.principal_amount + NEW.interest_amount + NEW.mpesa_cost;
  NEW.balance := NEW.total_payable - NEW.amount_repaid;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_loan_totals_trigger BEFORE INSERT OR UPDATE ON loans
  FOR EACH ROW EXECUTE FUNCTION calculate_loan_totals();

-- Create function to log activity
CREATE OR REPLACE FUNCTION log_activity()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO activity_log (user_id, action, entity_type, entity_id, description)
  VALUES (
    auth.uid(),
    TG_OP,
    TG_TABLE_NAME,
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    CASE 
      WHEN TG_OP = 'INSERT' THEN 'Created new ' || TG_TABLE_NAME
      WHEN TG_OP = 'UPDATE' THEN 'Updated ' || TG_TABLE_NAME
      WHEN TG_OP = 'DELETE' THEN 'Deleted ' || TG_TABLE_NAME
    END
  );
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers for activity logging on key tables
CREATE TRIGGER log_members_activity AFTER INSERT OR UPDATE OR DELETE ON members
  FOR EACH ROW EXECUTE FUNCTION log_activity();

CREATE TRIGGER log_subscriptions_activity AFTER INSERT OR UPDATE OR DELETE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION log_activity();

CREATE TRIGGER log_loans_activity AFTER INSERT OR UPDATE OR DELETE ON loans
  FOR EACH ROW EXECUTE FUNCTION log_activity();

CREATE TRIGGER log_fines_activity AFTER INSERT OR UPDATE OR DELETE ON fines
  FOR EACH ROW EXECUTE FUNCTION log_activity();

CREATE TRIGGER log_expenses_activity AFTER INSERT OR UPDATE OR DELETE ON expenses
  FOR EACH ROW EXECUTE FUNCTION log_activity();
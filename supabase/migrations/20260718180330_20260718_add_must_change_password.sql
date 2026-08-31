
/*
# Auto-create member accounts with forced password change

## Summary
Adds `must_change_password` flag to profiles. When an admin creates a member,
an edge function creates the auth account with a default password and sets
this flag to true. On first login, the member is forced to change their
password before accessing the system.
*/

-- Add must_change_password column
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS must_change_password boolean NOT NULL DEFAULT false;

-- Admin can read all profiles (already has admin_manage_all_profiles)
-- Members can read own must_change_password (already via users_read_own_profile)

-- Allow users to update their own must_change_password flag (to clear it after changing password)
DROP POLICY IF EXISTS users_update_own_password_flag ON profiles;
CREATE POLICY users_update_own_password_flag ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

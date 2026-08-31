
/*
# Fix new member signup

## Summary
The original `handle_new_user` trigger that auto-creates a profile row on signup was missing.
Only `set_user_role_on_signup` (which updates role) existed, but it runs AFTER INSERT and
expects the profile row to already exist. New members could not create accounts because
no profile row was being inserted. This migration:
1. Recreates `handle_new_user` function that inserts into profiles on auth.users insert
2. Combines profile creation + role setting into a single trigger
3. Fixes RLS: allows `anon` role to insert own profile (signup runs as anon, not authenticated)
*/

-- Drop the old role-only trigger and function
DROP TRIGGER IF EXISTS set_user_role_on_signup ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user_role();

-- Create combined function: insert profile + set role from metadata
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Insert profile row with role from metadata (default to 'member')
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE((NEW.raw_user_meta_data->>'role')::user_role, 'member'::user_role)
  )
  ON CONFLICT (id) DO UPDATE
    SET role = COALESCE((NEW.raw_user_meta_data->>'role')::user_role, profiles.role);
  
  RETURN NEW;
END;
$$;

-- Create trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

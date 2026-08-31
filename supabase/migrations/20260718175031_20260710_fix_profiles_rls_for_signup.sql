
/*
# Fix profiles RLS for signup

## Summary
The `insert_profile_on_signup` policy required `authenticated` role, but new signups
fire as `anon` (the user has no session yet). This adds an anon INSERT policy so
new users can create their own profile row during signup.
*/

-- Drop the old policy that required authenticated
DROP POLICY IF EXISTS insert_profile_on_signup ON profiles;

-- Allow both anon (during signup) and authenticated to insert their own profile
CREATE POLICY insert_profile_on_signup ON profiles FOR INSERT
  TO anon, authenticated WITH CHECK (auth.uid() = id);

/*
# Clean up auth accounts — keep only admin

## What this does
1. Unlinks any members whose user_id points to a non-admin auth account (sets user_id to NULL).
   The members table rows themselves are NOT deleted — only the link to auth.users is cleared.
2. Deletes all non-admin profiles rows.
3. Deletes all non-admin auth.users rows (via cascading deletion of profiles, which references auth.users with ON DELETE CASCADE).

## What is preserved
- The admin account: natembeatallia@gmail.com (auth user id f4687327-0b63-47ba-828b-b4e0644e17f9)
- ALL rows in the members table — no member data is lost.
- The members table is simply unlinked from deleted auth accounts so members can sign up fresh.
*/

-- Step 1: Unlink members from auth accounts that will be deleted (keep admin link intact)
UPDATE members
SET user_id = NULL
WHERE user_id IS NOT NULL
  AND user_id != 'f4687327-0b63-47ba-828b-b4e0644e17f9';

-- Step 2: Delete non-admin profiles (this cascades to remove the auth.users rows via FK)
DELETE FROM profiles
WHERE id != 'f4687327-0b63-47ba-828b-b4e0644e17f9';

-- Step 3: Verify only admin remains
-- (auth.users rows are deleted by the CASCADE on profiles.id REFERENCES auth.users(id) ON DELETE CASCADE)

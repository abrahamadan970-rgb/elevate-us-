/*
# Delete remaining non-admin auth.users directly

## What this does
1. Deletes all auth.users rows except the admin account (natembeatallia@gmail.com).
2. Their profile rows were already deleted in the previous migration, but some auth users
   had no profile row (orphaned), so the CASCADE didn't remove them from auth.users.
3. The members table is NOT touched — no member data is lost.
*/

DELETE FROM auth.users
WHERE id != 'f4687327-0b63-47ba-828b-b4e0644e17f9';

/*
# Clean up all auth accounts except admin (round 2)

## What this does
1. Deletes all non-admin profiles rows (cascades to auth.users via FK ON DELETE CASCADE).
2. Preserves the admin account: natembeatallia@gmail.com (id f4687327-0b63-47ba-828b-b4e0644e17f9).
3. The members table is NOT touched — no member data is lost.
4. No members are currently linked to auth accounts (user_id is NULL for all), so no unlinking needed.
*/

DELETE FROM profiles
WHERE id != 'f4687327-0b63-47ba-828b-b4e0644e17f9';

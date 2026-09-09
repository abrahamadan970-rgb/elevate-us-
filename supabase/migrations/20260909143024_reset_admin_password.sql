/*
# Reset admin password to common default

Sets the admin account (natembeatallia@gmail.com) password to ElevateUS2026!
and flags must_change_password so the admin changes it on first login.
*/
UPDATE auth.users
SET encrypted_password = crypt('ElevateUS2026!', gen_salt('bf'))
WHERE email = 'natembeatallia@gmail.com';

UPDATE profiles
SET must_change_password = true
WHERE email = 'natembeatallia@gmail.com';

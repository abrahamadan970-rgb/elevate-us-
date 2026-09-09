/*
# Remove test signup account

Deletes the test auth account and profile created during signup verification.
No real member data is affected.
*/
DELETE FROM profiles WHERE email = 'test-signup-check3@example.com';

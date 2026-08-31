/*
# Fix missing auth.identities rows for member accounts

The 8 member accounts created via direct SQL INSERT into auth.users are missing
corresponding rows in auth.identities. Supabase's signInWithPassword checks
auth.identities for an "email" provider entry — without it, login silently fails
with an empty error object (rendered as "{}" in the UI).

This migration inserts the missing identity rows so password login works.
Safe to re-run: uses WHERE NOT EXISTS to avoid duplicates.
*/
DO $$
DECLARE
  u RECORD;
BEGIN
  FOR u IN
    SELECT id, email
    FROM auth.users
    WHERE id NOT IN (SELECT user_id FROM auth.identities WHERE provider = 'email')
  LOOP
    INSERT INTO auth.identities (user_id, provider, identity_data, provider_id, last_sign_in_at, created_at, updated_at)
    VALUES (
      u.id,
      'email',
      jsonb_build_object(
        'sub', u.id::text,
        'email', u.email,
        'email_verified', true
      ),
      u.id::text,
      NULL,
      now(),
      now()
    )
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Created email identity for %', u.email;
  END LOOP;
END $$;

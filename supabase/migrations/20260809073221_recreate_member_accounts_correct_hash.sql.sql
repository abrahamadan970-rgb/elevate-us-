/*
# Recreate member auth accounts with correct bcrypt $2a$10$ password hashes

## Problem
8 member accounts were created earlier with bcrypt cost factor $2a$06$. Supabase's
GoTrue auth server requires bcrypt cost $2a$10$. Password verification fails with
"Database error querying schema" and users cannot log in.

## Solution
1. Use pgcrypto's crypt('ElevateUS', gen_salt('bf', 10)) to generate correct
   bcrypt $2a$10$ password hashes.
2. Insert auth.users rows with all required fields (confirmed_at is a generated
   column and must NOT be included in the INSERT).
3. Insert auth.identities rows with provider='email'.
4. Insert public.profiles rows with must_change_password=true.

## Safety
- Uses gen_random_uuid() for new IDs.
- email_confirmed_at is set to now() so accounts are immediately usable.
- Only inserts 8 member accounts — the existing admin (Talia) is not affected.
- All 8 accounts get must_change_password=true in profiles.
*/
DO $$
DECLARE
  pw_hash text := crypt('ElevateUS', gen_salt('bf', 10));
  m RECORD;
  new_id uuid;
BEGIN
  FOR m IN
    SELECT full_name, email, role
    FROM (
      VALUES
      ('Anthony Cyril', 'cyrilanthony298@gmail.com', 'member'),
      ('Kenneth Okomba', 'kenethokomba@gmail.com', 'member'),
      ('Marcelinah Machiba', 'machicelina@gmail.com', 'member'),
      ('Okanga Cyril', 'okangacyril@gmail.com', 'member'),
      ('Simiyu Munialo', 'okellodanstar@gmail.com', 'member'),
      ('Daisy Phicencah Masika', 'phicencahdaisy@gmail.com', 'member'),
      ('Joshua Pnoibey Sambrir', 'pnoibeysambrir@gmail.com', 'member'),
      ('Dan Simiyu', 'simiyudan715@gmail.com', 'member')
    ) AS t(full_name, email, role)
  LOOP
    IF EXISTS (SELECT 1 FROM auth.users WHERE email = m.email) THEN
      RAISE NOTICE 'Skipping existing user: %', m.email;
      CONTINUE;
    END IF;

    new_id := gen_random_uuid();

    INSERT INTO auth.users (
      id,
      instance_id,
      aud,
      role,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at,
      is_sso_user,
      is_anonymous
    ) VALUES (
      new_id,
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      m.email,
      pw_hash,
      now(),
      jsonb_build_object('provider', 'email', 'providers', jsonb_build_array('email')),
      jsonb_build_object('full_name', m.full_name, 'role', m.role),
      now(),
      now(),
      false,
      false
    );

    INSERT INTO auth.identities (
      user_id,
      provider,
      identity_data,
      provider_id,
      last_sign_in_at,
      created_at,
      updated_at
    ) VALUES (
      new_id,
      'email',
      jsonb_build_object(
        'sub', new_id::text,
        'email', m.email,
        'email_verified', true
      ),
      new_id::text,
      NULL,
      now(),
      now()
    );

    INSERT INTO public.profiles (id, email, full_name, role, must_change_password)
    VALUES (new_id, m.email, m.full_name, m.role::user_role, true)
    ON CONFLICT (id) DO UPDATE SET
      email = EXCLUDED.email,
      full_name = EXCLUDED.full_name,
      role = EXCLUDED.role::user_role,
      must_change_password = true;

    RAISE NOTICE 'Created account for: %', m.email;
  END LOOP;
END $$;

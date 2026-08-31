/*
# Create auth accounts for all members

Creates auth.users entries for all members who have emails but don't yet have auth accounts.
Uses crypt() for password hashing (bcrypt), sets email_confirmed_at, and sets raw_user_meta_data.
The handle_new_user trigger will fire AFTER INSERT and create the corresponding profiles row.
Then sets must_change_password = true on all newly created profiles.

Password for all accounts: ElevateUS
All accounts will be forced to change password on first login.
*/
DO $$
DECLARE
  m RECORD;
  v_user_id uuid;
  v_hashed_pw text;
  v_role text;
BEGIN
  v_hashed_pw := crypt('ElevateUS', gen_salt('bf'));

  FOR m IN
    SELECT email, full_name, status
    FROM members
    WHERE email IS NOT NULL AND email != ''
    AND lower(email) NOT IN (SELECT lower(email) FROM auth.users WHERE email IS NOT NULL)
  LOOP
    v_role := 'member';

    v_user_id := extensions.uuid_generate_v4();

    INSERT INTO auth.users (
      id, instance_id, aud, role, email,
      encrypted_password, email_confirmed_at,
      raw_user_meta_data, raw_app_meta_data,
      created_at, updated_at, is_sso_user, is_anonymous
    ) VALUES (
      v_user_id,
      '00000000-0000-0000-0000-000000000000',
      'authenticated', 'authenticated', lower(m.email),
      v_hashed_pw, now(),
      jsonb_build_object('full_name', m.full_name, 'role', v_role),
      jsonb_build_object('provider', 'email', 'providers', ARRAY['email']),
      now(), now(), false, false
    );

    -- The handle_new_user trigger should have created the profile row.
    -- Update it with must_change_password = true and correct full_name.
    UPDATE public.profiles
    SET must_change_password = true, full_name = m.full_name, role = v_role::user_role
    WHERE id = v_user_id;

    RAISE NOTICE 'Created account for % (%), id: %', m.full_name, m.email, v_user_id;
  END LOOP;
END $$;

/*
# Add chairperson role and update signup trigger

1. Changes
- Adds 'chairperson' to the user_role enum type.
- Updates handle_new_user() trigger function to accept 'chairperson' as a valid role during signup.
2. Security
- No RLS policy changes. Existing policies remain intact.
3. Notes
- The role enum now has: admin, leader, member, treasurer, secretary, chairperson.
- chairperson is treated as a leadership role with full view access and limited edit access (similar to leader/secretary).
*/

ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'chairperson';

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_role text;
  v_full_name text;
BEGIN
  v_role := NEW.raw_user_meta_data->>'role';
  v_full_name := COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1));

  IF v_role IS NULL OR v_role NOT IN ('admin', 'leader', 'member', 'treasurer', 'secretary', 'chairperson') THEN
    v_role := 'member';
  END IF;

  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    v_full_name,
    v_role::user_role
  )
  ON CONFLICT (id) DO UPDATE
  SET
    role = v_role::user_role,
    full_name = v_full_name;

  RETURN NEW;
END;
$function$;

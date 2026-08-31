/*
# Fix signup trigger for robust role handling

1. Changes
- Rewrite `handle_new_user()` trigger function to safely handle invalid/empty role values
- If role metadata is missing or not a valid user_role enum, default to 'member'
2. Security
- No RLS changes; trigger remains SECURITY DEFINER
3. Notes
- Previous version did a direct cast `(NEW.raw_user_meta_data->>'role')::user_role` which would throw if the value was empty or not a valid enum, causing the entire signup to fail silently
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_role text;
  v_full_name text;
BEGIN
  v_role := NEW.raw_user_meta_data->>'role';
  v_full_name := COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1));

  -- Validate role against allowed enum values; default to 'member' if invalid
  IF v_role IS NULL OR v_role NOT IN ('admin', 'leader', 'member', 'treasurer') THEN
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

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
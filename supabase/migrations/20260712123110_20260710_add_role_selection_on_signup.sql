
/*
# Auto-set user role from signup metadata

## Summary
When a user signs up, they can choose a role (member, treasurer, leader).
The signup metadata includes `role` which this trigger copies to the profiles table.
Previously all new users defaulted to 'member'. Now the chosen role is respected.
*/

CREATE OR REPLACE FUNCTION handle_new_user_role()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- If role is provided in metadata and is valid, use it; otherwise default to 'member'
  IF NEW.raw_user_meta_data->>'role' IS NOT NULL THEN
    UPDATE profiles SET role = (NEW.raw_user_meta_data->>'role')::user_role
    WHERE id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$;

-- Trigger after the existing profile creation trigger
DROP TRIGGER IF EXISTS set_user_role_on_signup ON auth.users;
CREATE TRIGGER set_user_role_on_signup
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user_role();

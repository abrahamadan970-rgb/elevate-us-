/*
# Fix handle_new_user trigger and SECURITY DEFINER functions

## Problem
1. handle_new_user() has no search_path → GoTrue can't resolve user_role enum
   during admin.createUser → "Database error creating new user"
2. All SECURITY DEFINER functions have mutable search_path (security advisor warning)

## Solution
Recreate all functions with SET search_path = public.
- is_leader_or_admin updated to include 'secretary' role.
- log_activity is a trigger function with dependent triggers — use DROP ... CASCADE
  then recreate function and re-attach all triggers.

## Safety
- CASCADE only drops the triggers (not table data); we re-create them immediately.
- get_user_role returns user_role type — must DROP to add search_path.
*/
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
DECLARE
v_role text;
v_full_name text;
BEGIN
v_role := NEW.raw_user_meta_data->>'role';
v_full_name := COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1));

IF v_role IS NULL OR v_role NOT IN ('admin', 'leader', 'member', 'treasurer', 'secretary') THEN
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

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
SELECT EXISTS (
SELECT 1 FROM public.profiles
WHERE id = auth.uid() AND role = 'admin'
);
$$;

CREATE OR REPLACE FUNCTION public.is_leader_or_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
SELECT EXISTS (
SELECT 1 FROM public.profiles
WHERE id = auth.uid() AND role IN ('admin', 'leader', 'secretary')
);
$$;

DROP FUNCTION IF EXISTS public.get_user_role();
CREATE FUNCTION public.get_user_role()
RETURNS user_role
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $function$
DECLARE
user_role_var user_role;
BEGIN
SELECT role INTO user_role_var FROM public.profiles WHERE id = auth.uid();
RETURN COALESCE(user_role_var, 'member'::user_role);
END;
$function$;

-- log_activity: must CASCADE to drop dependent triggers, then recreate
DROP FUNCTION IF EXISTS public.log_activity() CASCADE;

CREATE FUNCTION public.log_activity()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
BEGIN
INSERT INTO public.activity_log (user_id, action, entity_type, entity_id, description)
VALUES (
auth.uid(),
TG_OP,
TG_TABLE_NAME,
CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
CASE 
WHEN TG_OP = 'INSERT' THEN 'Created new ' || TG_TABLE_NAME
WHEN TG_OP = 'UPDATE' THEN 'Updated ' || TG_TABLE_NAME
WHEN TG_OP = 'DELETE' THEN 'Deleted ' || TG_TABLE_NAME
END
);
RETURN COALESCE(NEW, OLD);
END;
$function$;

-- Re-attach activity log triggers
DROP TRIGGER IF EXISTS log_members_activity ON public.members;
CREATE TRIGGER log_members_activity AFTER INSERT OR UPDATE OR DELETE ON public.members
FOR EACH ROW EXECUTE FUNCTION public.log_activity();

DROP TRIGGER IF EXISTS log_subscriptions_activity ON public.subscriptions;
CREATE TRIGGER log_subscriptions_activity AFTER INSERT OR UPDATE OR DELETE ON public.subscriptions
FOR EACH ROW EXECUTE FUNCTION public.log_activity();

DROP TRIGGER IF EXISTS log_loans_activity ON public.loans;
CREATE TRIGGER log_loans_activity AFTER INSERT OR UPDATE OR DELETE ON public.loans
FOR EACH ROW EXECUTE FUNCTION public.log_activity();

DROP TRIGGER IF EXISTS log_fines_activity ON public.fines;
CREATE TRIGGER log_fines_activity AFTER INSERT OR UPDATE OR DELETE ON public.fines
FOR EACH ROW EXECUTE FUNCTION public.log_activity();

DROP TRIGGER IF EXISTS log_expenses_activity ON public.expenses;
CREATE TRIGGER log_expenses_activity AFTER INSERT OR UPDATE OR DELETE ON public.expenses
FOR EACH ROW EXECUTE FUNCTION public.log_activity();

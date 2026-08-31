/*
# Add secretary role to user_role enum

Adds 'secretary' to the user_role enum type. This must be committed in its own
migration before any function can reference the new value — Postgres requires
new enum values to be committed before use.
*/
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'secretary';

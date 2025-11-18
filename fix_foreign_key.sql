-- Fix: Remove the self-referencing foreign key constraint
-- This constraint is causing the signup to fail

-- First, check what constraints exist on the users table
SELECT conname, contype, pg_get_constraintdef(oid) AS definition
FROM pg_constraint 
WHERE conrelid = 'users'::regclass;

-- Drop the problematic self-referencing foreign key
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_id_fkey;

-- Verify the constraint is removed
SELECT conname, contype, pg_get_constraintdef(oid) AS definition
FROM pg_constraint 
WHERE conrelid = 'users'::regclass';

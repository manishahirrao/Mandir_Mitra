-- Fix for users table RLS policy to allow signup
-- This policy allows users to insert their own profile during signup

DROP POLICY IF EXISTS "Users can insert own profile" ON users;

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (
    auth.uid() = id OR 
    -- Allow insertion when creating profile for current auth user
    id = (
      SELECT id FROM auth.users 
      WHERE email = current_setting('request.jwt.claims', true)::json->>'email'
    )
  );

-- Alternative simpler approach - allow users to insert their own profile
CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

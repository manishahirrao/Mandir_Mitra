-- =====================================================
-- COMPLETE FIX: Users Table with Proper Permissions
-- Run this in Supabase SQL Editor
-- =====================================================

-- Step 1: Drop existing table and policies
DROP TABLE IF EXISTS users CASCADE;

-- Step 2: Create users table with proper auth reference
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone TEXT,
  profile_cloudinary_id TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  language TEXT DEFAULT 'english',
  preferred_temple TEXT,
  loyalty_points INTEGER DEFAULT 0,
  loyalty_tier TEXT DEFAULT 'bronze',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_loyalty_tier ON users(loyalty_tier);

-- Step 4: Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Step 5: Create RLS Policies (IMPORTANT: These allow users to insert their own profile)
CREATE POLICY "Users can view own profile" 
  ON users 
  FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" 
  ON users 
  FOR INSERT 
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
  ON users 
  FOR UPDATE 
  USING (auth.uid() = id);

-- Step 6: Create update trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Step 7: Add trigger
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
  BEFORE UPDATE ON users
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

-- Step 8: Verify setup
SELECT 
  'Users table created successfully!' as status,
  'RLS enabled: ' || (SELECT relrowsecurity FROM pg_class WHERE relname = 'users') as rls_status,
  'Policies count: ' || (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'users') as policies_count;

-- Step 9: Test insert (optional - comment out if you don't want to test)
-- This will only work if you're logged in as a user
-- INSERT INTO users (id, email, full_name, phone) 
-- VALUES (auth.uid(), 'test@example.com', 'Test User', '+1234567890');

SELECT 'Setup complete! Try signing up now.' as message;

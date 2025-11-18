-- Alternative: Use service role to bypass RLS during signup
-- This creates a function that can be called to insert user profiles

CREATE OR REPLACE FUNCTION create_user_profile(
  user_id UUID,
  user_email TEXT,
  user_full_name TEXT,
  user_phone TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER -- This bypasses RLS
AS $$
BEGIN
  INSERT INTO users (
    id, 
    email, 
    full_name, 
    phone, 
    is_verified, 
    is_active, 
    language, 
    loyalty_points, 
    loyalty_tier,
    created_at,
    updated_at
  ) VALUES (
    user_id,
    user_email,
    user_full_name,
    user_phone,
    false,
    true,
    'english',
    0,
    'bronze',
    NOW(),
    NOW()
  );
END;
$$;

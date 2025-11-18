# 🔧 Fix Supabase Auth Issue - Step by Step

## 🔴 The Problem

The `users` table in the database schema is **NOT properly linked** to Supabase's `auth.users` table. This causes signup/login to fail because:

1. The schema creates `users` table with its own UUID generation
2. The app tries to insert a user with the auth.users ID
3. There's a mismatch between the two IDs

## ✅ The Solution

The `users` table must **reference** the Supabase `auth.users` table.

## 📋 Step-by-Step Fix

### Step 1: Access Supabase Dashboard

1. Go to https://supabase.com/dashboard
2. Select your project: **widjqzuxwueorlufjnpj**
3. Click on **SQL Editor** in the left sidebar

### Step 2: Run the Fix Script

Copy and paste this SQL into the SQL Editor:

```sql
-- Drop the existing users table if it exists
DROP TABLE IF EXISTS users CASCADE;

-- Recreate users table with proper auth reference
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

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_loyalty_tier ON users(loyalty_tier);

-- Add updated_at trigger (if function exists)
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

3. Click **Run** button (or press Ctrl+Enter)
4. You should see: "Success. No rows returned"

### Step 3: Disable Email Confirmation (For Testing)

1. In Supabase Dashboard, go to **Authentication** → **Settings**
2. Scroll to **Email Auth** section
3. **Uncheck** "Confirm email"
4. Click **Save**

This allows users to sign up and login immediately without email verification.

### Step 4: Add Localhost to Allowed URLs (For Web)

1. Still in **Authentication** → **Settings**
2. Scroll to **URL Configuration**
3. Add to **Site URL**: `http://localhost:PORT` (replace PORT with your actual port, e.g., 54981)
4. Add to **Redirect URLs**: 
   - `http://localhost:*/**`
   - `http://127.0.0.1:*/**`
5. Click **Save**

### Step 5: Create Test User (Optional)

You can create a test user manually:

1. Go to **Authentication** → **Users**
2. Click **Add user** → **Create new user**
3. Fill in:
   - Email: `test@test.com`
   - Password: `123456`
   - Auto Confirm User: ✅ **Check this**
4. Click **Create user**

### Step 6: Test the App

1. Stop the Flutter app (press `q` in terminal)
2. Restart: `flutter run -d chrome`
3. Try to **Sign Up** with a new account
4. Or **Login** with test@test.com / 123456

## 🧪 Testing Checklist

- [ ] Run the SQL fix script in Supabase
- [ ] Disable email confirmation
- [ ] Add localhost URLs
- [ ] Create test user (optional)
- [ ] Restart Flutter app
- [ ] Try signup with new email
- [ ] Try login with test credentials
- [ ] Check if profile drawer shows user info

## 🐛 If Still Not Working

### Check Browser Console

1. Open Chrome DevTools (F12)
2. Go to **Console** tab
3. Look for errors like:
   - `400 Bad Request`
   - `403 Forbidden`
   - `CORS error`
   - `Invalid JWT`

### Check Supabase Logs

1. Go to Supabase Dashboard
2. Click **Logs** → **Auth Logs**
3. Look for failed signup/login attempts
4. Check the error messages

### Add Debug Logging

Add this to `auth_provider.dart` to see detailed errors:

```dart
Future<bool> signup(String fullName, String email, String phone, String password) async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🔐 Starting signup for: $email'); // DEBUG

    final response = await supabase.Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    print('✅ Signup response: ${response.user?.id}'); // DEBUG

    if (response.user != null) {
      print('📝 Creating user profile...'); // DEBUG
      
      await supabase.Supabase.instance.client.from('users').insert({
        'id': response.user!.id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'is_verified': false,
        'is_active': true,
        'language': 'english',
        'loyalty_points': 0,
        'loyalty_tier': 'bronze',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ User profile created!'); // DEBUG
      return true;
    }
    return false;
  } catch (e) {
    print('❌ Signup error: $e'); // DEBUG
    print('❌ Error type: ${e.runtimeType}'); // DEBUG
    _errorMessage = 'Signup failed: $e';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### Common Errors & Solutions

| Error | Solution |
|-------|----------|
| `relation "users" does not exist` | Run the SQL fix script |
| `duplicate key value violates unique constraint` | User already exists, try different email |
| `new row violates row-level security policy` | Check RLS policies are correct |
| `Invalid login credentials` | Wrong email/password or user doesn't exist |
| `Email not confirmed` | Disable email confirmation in settings |
| `CORS error` | Add localhost to allowed URLs |

## 📝 What Changed

### Before (Wrong):
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- ❌ Generates its own ID
  ...
);
```

### After (Correct):
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,  -- ✅ References auth.users
  ...
);
```

## 🎯 Expected Behavior After Fix

### Signup Flow:
1. User fills signup form
2. App calls `auth.signUp()` → Creates user in `auth.users`
3. App inserts profile in `users` table with same ID
4. User is automatically logged in (if email confirmation disabled)
5. User sees main navigation screen

### Login Flow:
1. User enters email/password
2. App calls `auth.signInWithPassword()`
3. Supabase validates credentials
4. App loads user profile from `users` table
5. User sees main navigation screen

## 🚀 Next Steps After Auth Works

1. Test all auth flows (signup, login, logout)
2. Test profile navigation (the new feature we added)
3. Enable email confirmation for production
4. Add proper error messages
5. Add loading states
6. Test on mobile devices

---

**Need Help?**
- Check Supabase docs: https://supabase.com/docs/guides/auth
- Check Flutter logs in terminal
- Check browser console for errors
- Check Supabase auth logs in dashboard

**Last Updated**: November 16, 2025

# Supabase Auth Troubleshooting Guide

## Current Status
- ✅ Supabase initialized successfully
- ✅ Auth provider implemented
- ✅ Login/Signup screens implemented
- ❓ Auth not working (needs investigation)

## Common Issues & Solutions

### 1. Database Tables Not Created

The app expects a `users` table in Supabase. Check if it exists:

**Required SQL to create users table:**

```sql
-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    language TEXT DEFAULT 'english',
    loyalty_points INTEGER DEFAULT 0,
    loyalty_tier TEXT DEFAULT 'bronze',
    preferred_temple TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view own profile"
    ON public.users
    FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.users
    FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Enable insert for authenticated users"
    ON public.users
    FOR INSERT
    WITH CHECK (auth.uid() = id);
```

### 2. Email Confirmation Required

By default, Supabase requires email confirmation. To disable for testing:

1. Go to Supabase Dashboard
2. Navigate to **Authentication** → **Settings**
3. Under **Email Auth**, disable "Confirm email"
4. Save changes

### 3. Auth Flow Type

The app uses PKCE flow which is recommended for web apps:

```dart
authOptions: const FlutterAuthClientOptions(
  authFlowType: AuthFlowType.pkce,
),
```

### 4. CORS Issues (Web Only)

For web apps, you may need to add your localhost to allowed URLs:

1. Go to Supabase Dashboard
2. Navigate to **Authentication** → **URL Configuration**
3. Add to **Site URL**: `http://localhost:PORT`
4. Add to **Redirect URLs**: `http://localhost:PORT/**`

### 5. Check Supabase Credentials

Verify in `man/lib/config/supabase_config.dart`:
- ✅ `supabaseUrl`: https://widjqzuxwueorlufjnpj.supabase.co
- ✅ `supabaseAnonKey`: (present)

### 6. Test Credentials

The login screen suggests test credentials:
- Email: `test@test.com`
- Password: `123456`

**You need to create this user in Supabase first!**

## How to Test Auth

### Option 1: Create Test User via Supabase Dashboard

1. Go to Supabase Dashboard
2. Navigate to **Authentication** → **Users**
3. Click "Add user"
4. Email: `test@test.com`
5. Password: `123456`
6. Auto-confirm user: ✅
7. Click "Create user"

### Option 2: Use Signup Flow

1. Open the app
2. Click "Sign Up"
3. Fill in the form
4. Submit
5. Check Supabase Dashboard for the new user

### Option 3: Disable Email Confirmation

If signup creates user but doesn't log in:

1. Supabase Dashboard → Authentication → Settings
2. Disable "Confirm email"
3. Try signup again

## Debugging Steps

### 1. Check Browser Console

Open Chrome DevTools (F12) and check for:
- Network errors (401, 403, 500)
- CORS errors
- Supabase API errors

### 2. Check Supabase Logs

1. Go to Supabase Dashboard
2. Navigate to **Logs** → **Auth Logs**
3. Look for failed login/signup attempts

### 3. Add Debug Logging

Add this to `auth_provider.dart` to see detailed errors:

```dart
Future<bool> login(String email, String password) async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🔐 Attempting login for: $email'); // DEBUG

    final response = await supabase.Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    print('✅ Login response: ${response.user?.id}'); // DEBUG

    if (response.user != null) {
      await _loadUserProfile(response.user!);
      return true;
    }
    return false;
  } catch (e) {
    print('❌ Login error: $e'); // DEBUG
    _errorMessage = 'Login failed: $e';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### 4. Test Supabase Connection

Add a test button to verify Supabase is working:

```dart
Future<void> testSupabaseConnection() async {
  try {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .limit(1);
    print('✅ Supabase connected: $response');
  } catch (e) {
    print('❌ Supabase error: $e');
  }
}
```

## Quick Fix Checklist

- [ ] Create `users` table in Supabase
- [ ] Add RLS policies
- [ ] Disable email confirmation (for testing)
- [ ] Create test user (test@test.com / 123456)
- [ ] Add localhost to allowed URLs (for web)
- [ ] Check browser console for errors
- [ ] Check Supabase auth logs
- [ ] Add debug logging to auth_provider.dart

## Expected Behavior

### Successful Login Flow:
1. User enters email/password
2. AuthProvider calls `signInWithPassword()`
3. Supabase returns user session
4. App loads user profile from `users` table
5. User is redirected to MainNavigation
6. Profile drawer shows user info

### Successful Signup Flow:
1. User enters details
2. AuthProvider calls `signUp()`
3. Supabase creates auth user
4. App creates profile in `users` table
5. User receives confirmation email (if enabled)
6. User is logged in (if email confirmation disabled)

## Next Steps

1. **Check Supabase Dashboard** - Verify tables exist
2. **Create test user** - Use dashboard to create test@test.com
3. **Test login** - Try logging in with test credentials
4. **Check console** - Look for specific error messages
5. **Add debug logs** - See exactly where it's failing

## Contact Support

If issues persist:
- Check Supabase status: https://status.supabase.com/
- Supabase Discord: https://discord.supabase.com/
- Supabase Docs: https://supabase.com/docs/guides/auth

---

**Last Updated**: November 16, 2025

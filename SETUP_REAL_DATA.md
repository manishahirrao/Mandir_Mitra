# 🔥 Setup Real Data with Supabase

## Overview

The app is now configured to use **REAL DATA** from Supabase instead of mock data. This means:

- ✅ Real user authentication (signup/login)
- ✅ Real user profiles from database
- ✅ Real rituals, temples, orders data
- ✅ Real wishlist, reviews, bookings
- ✅ All data synced with Supabase

## 🚀 Quick Setup (5 Steps)

### Step 1: Fix the Users Table

Run this SQL in Supabase Dashboard → SQL Editor:

```sql
-- Drop and recreate users table with proper auth reference
DROP TABLE IF EXISTS users CASCADE;

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

-- Create policies
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
```

### Step 2: Run the Full Schema

Run the complete schema from `supabase_main_schema.sql` in Supabase SQL Editor to create all tables:

- rituals
- temples
- orders
- bookings
- wishlist
- reviews
- notifications
- loyalty_points
- coupons
- etc.

### Step 3: Disable Email Confirmation (For Testing)

1. Supabase Dashboard → **Authentication** → **Settings**
2. Under **Email Auth**, uncheck "Confirm email"
3. Click **Save**

### Step 4: Add Sample Data

Run this SQL to add sample rituals and temples:

```sql
-- Insert sample temples
INSERT INTO temples (id, name, location, city, state, description, deity, is_popular, is_active, rating) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Kashi Vishwanath Temple', 'Varanasi, Uttar Pradesh', 'Varanasi', 'Uttar Pradesh', 'One of the most famous Hindu temples dedicated to Lord Shiva', 'Lord Shiva', true, true, 4.8),
('550e8400-e29b-41d4-a716-446655440002', 'Meenakshi Temple', 'Madurai, Tamil Nadu', 'Madurai', 'Tamil Nadu', 'Historic Hindu temple dedicated to Goddess Meenakshi', 'Goddess Meenakshi', true, true, 4.9),
('550e8400-e29b-41d4-a716-446655440003', 'Jagannath Temple', 'Puri, Odisha', 'Puri', 'Odisha', 'Famous temple dedicated to Lord Jagannath', 'Lord Jagannath', true, true, 4.7);

-- Insert sample rituals
INSERT INTO rituals (id, name, description, category, price, temple_id, deity, is_popular, is_active, rating) VALUES
('650e8400-e29b-41d4-a716-446655440001', 'Rudrabhishek Puja', 'Sacred ritual for Lord Shiva with milk, honey, and holy water', 'Puja', 1100.00, '550e8400-e29b-41d4-a716-446655440001', 'Lord Shiva', true, true, 4.8),
('650e8400-e29b-41d4-a716-446655440002', 'Lakshmi Puja', 'Worship of Goddess Lakshmi for prosperity and wealth', 'Puja', 800.00, '550e8400-e29b-41d4-a716-446655440002', 'Goddess Lakshmi', true, true, 4.7),
('650e8400-e29b-41d4-a716-446655440003', 'Ganesh Puja', 'Worship of Lord Ganesha for removing obstacles', 'Puja', 600.00, '550e8400-e29b-41d4-a716-446655440003', 'Lord Ganesha', true, true, 4.9),
('650e8400-e29b-41d4-a716-446655440004', 'Satyanarayan Puja', 'Puja for Lord Vishnu for peace and prosperity', 'Puja', 1500.00, '550e8400-e29b-41d4-a716-446655440001', 'Lord Vishnu', true, true, 4.6),
('650e8400-e29b-41d4-a716-446655440005', 'Durga Puja', 'Worship of Goddess Durga for strength and protection', 'Puja', 2000.00, '550e8400-e29b-41d4-a716-446655440002', 'Goddess Durga', true, true, 4.8);

-- Insert sample FAQs
INSERT INTO faqs (question, answer, category, order_index, is_active) VALUES
('How do I book a ritual?', 'Browse rituals, select one, choose a package, fill in details, and complete payment.', 'Booking', 1, true),
('Can I track my ritual?', 'Yes, you can track your ritual in real-time from the My Rituals section.', 'Tracking', 2, true),
('What payment methods are accepted?', 'We accept UPI, credit/debit cards, net banking, and digital wallets.', 'Payment', 3, true),
('How do I get my Aashirwad Box?', 'It will be delivered to your address within 3-5 business days after the ritual.', 'Delivery', 4, true),
('Can I cancel my booking?', 'Yes, you can cancel up to 24 hours before the scheduled time for a full refund.', 'Cancellation', 5, true);

-- Insert sample blogs
INSERT INTO blogs (title, slug, content, excerpt, author, category, is_published, is_featured, published_at) VALUES
('The Significance of Rudrabhishek', 'significance-of-rudrabhishek', 'Rudrabhishek is one of the most powerful rituals...', 'Learn about the ancient ritual of Rudrabhishek', 'Pandit Sharma', 'Rituals', true, true, NOW()),
('Understanding Temple Architecture', 'temple-architecture', 'Indian temple architecture is a fascinating subject...', 'Explore the beauty of temple design', 'Dr. Patel', 'Culture', true, false, NOW());
```

### Step 5: Create Your First User

**Option A: Via Signup Screen**
1. Run the app
2. Click "Sign Up"
3. Fill in your details
4. Submit
5. You'll be logged in automatically

**Option B: Via Supabase Dashboard**
1. Go to **Authentication** → **Users**
2. Click **Add user** → **Create new user**
3. Email: `your@email.com`
4. Password: `your_password`
5. Auto Confirm User: ✅
6. Click **Create user**

## 📱 App Flow with Real Data

### 1. First Launch
```
Splash Screen
    ↓
Check Auth Status
    ↓
Not Authenticated → Onboarding → Login/Signup
    ↓
Authenticated → Main Navigation
```

### 2. After Signup
```
User fills signup form
    ↓
Supabase creates auth user
    ↓
App creates profile in users table
    ↓
User is logged in
    ↓
UserProvider loads profile
    ↓
Main Navigation shows real user data
```

### 3. Profile Drawer
```
Shows real user data:
- Profile photo (if uploaded)
- Full name from database
- Email from database
- All menu items work with real data
```

## 🔄 Data Flow

### Authentication Flow
```
AuthProvider (manages auth state)
    ↓
UserProvider (loads user profile)
    ↓
UI Components (display user data)
```

### Data Providers
- **AuthProvider**: Handles login/signup/logout
- **UserProvider**: Manages user profile and preferences
- **RitualsProvider**: Loads rituals from Supabase
- **OrdersProvider**: Manages user orders
- **WishlistProvider**: Syncs wishlist with database
- **LoyaltyProvider**: Tracks loyalty points
- **NotificationProvider**: Manages notifications

## 🎯 What Changed

### Before (Mock Data)
```dart
UserProvider() {
  _loadMockUser(); // Hardcoded data
}
```

### After (Real Data)
```dart
UserProvider() {
  _initializeUser(); // Loads from Supabase
}

Future<void> loadUserProfile(String userId) async {
  final response = await SupabaseConfig.client
      .from('users')
      .select()
      .eq('id', userId)
      .single();
  // Use real data from database
}
```

## 🧪 Testing Real Data

### Test Signup
1. Open app
2. Go to Signup screen
3. Enter:
   - Name: Your Name
   - Email: test@example.com
   - Phone: +919876543210
   - Password: Test@123
4. Submit
5. Check Supabase Dashboard → Authentication → Users
6. You should see your new user

### Test Login
1. Open app
2. Go to Login screen
3. Enter your credentials
4. Submit
5. You should see Main Navigation
6. Open profile drawer
7. Your real name and email should appear

### Test Profile Navigation
1. Click profile icon (top-left)
2. Click "My Profile"
3. Your real data should be displayed
4. Try editing profile
5. Changes should save to Supabase

### Test Wishlist
1. Browse rituals
2. Add to wishlist
3. Check Supabase → wishlist table
4. Your wishlist entry should be there

## 🔍 Debugging Real Data

### Check if User is Loaded
Add this to any screen:
```dart
Consumer<UserProvider>(
  builder: (context, userProvider, child) {
    print('User: ${userProvider.user?.fullName}');
    print('Is Logged In: ${userProvider.isLoggedIn}');
    return Text(userProvider.user?.fullName ?? 'No user');
  },
)
```

### Check Supabase Connection
```dart
Future<void> testConnection() async {
  try {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .limit(1);
    print('✅ Connected: $response');
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

### Check Auth State
```dart
final user = Supabase.instance.client.auth.currentUser;
print('Current user: ${user?.email}');
```

## 📊 Database Tables Status

After running the schema, you should have:

- ✅ users (with auth reference)
- ✅ rituals
- ✅ temples
- ✅ orders
- ✅ bookings
- ✅ wishlist
- ✅ reviews
- ✅ notifications
- ✅ loyalty_points
- ✅ coupons
- ✅ tracking
- ✅ blogs
- ✅ faqs
- ✅ live_streams
- ✅ chadhava
- ✅ testimonials
- ✅ app_settings
- ✅ referrals

## 🚨 Common Issues

### Issue: "relation 'users' does not exist"
**Solution**: Run the schema SQL in Supabase

### Issue: "new row violates row-level security policy"
**Solution**: Check RLS policies are created correctly

### Issue: User data not showing
**Solution**: 
1. Check if user exists in Supabase
2. Check if UserProvider is loading data
3. Add debug prints to see what's happening

### Issue: Login fails
**Solution**:
1. Check email confirmation is disabled
2. Check user exists in auth.users
3. Check password is correct

## 🎉 Success Checklist

- [ ] Schema created in Supabase
- [ ] Users table has auth reference
- [ ] Email confirmation disabled
- [ ] Sample data inserted
- [ ] Test user created
- [ ] App shows real user data in profile drawer
- [ ] Signup creates real user in database
- [ ] Login loads real user data
- [ ] Wishlist syncs with database
- [ ] All navigation works with real data

## 🔐 Security Notes

For production:
1. ✅ Enable email confirmation
2. ✅ Add proper RLS policies
3. ✅ Validate all user inputs
4. ✅ Use environment variables for secrets
5. ✅ Enable rate limiting
6. ✅ Add proper error handling
7. ✅ Implement proper session management

---

**Status**: ✅ App now uses REAL DATA from Supabase
**Last Updated**: November 16, 2025

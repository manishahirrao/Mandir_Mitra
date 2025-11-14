# Supabase Migration Guide - Mandir Mitra

## Overview

This guide covers migrating from Firebase to Supabase for the Mandir Mitra Flutter app.

## 🚀 Quick Start

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Create new organization (if needed)
4. Create new project:
   - Name: "Mandir Mitra"
   - Database Password: (save securely)
   - Region: Choose closest to your users
5. Wait for project to be ready (~2 minutes)

### 2. Get Credentials

From your Supabase project dashboard:
1. Go to Settings → API
2. Copy:
   - Project URL
   - `anon` public key

### 3. Update Config

Edit `lib/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_PROJECT_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

## 📊 Database Schema

### Create Tables

Run these SQL commands in Supabase SQL Editor:

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  profile_image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Users can read their own data
CREATE POLICY "Users can read own data" ON users
  FOR SELECT USING (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Rituals table
CREATE TABLE rituals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category TEXT NOT NULL,
  deity TEXT,
  duration TEXT,
  image_url TEXT,
  images TEXT[],
  benefits TEXT[],
  includes TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable public read for rituals
ALTER TABLE rituals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read rituals" ON rituals
  FOR SELECT USING (true);

-- Orders table
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  ritual_id UUID REFERENCES rituals(id) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  total_amount DECIMAL(10,2) NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'pending',
  booking_date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read own orders" ON orders
  FOR SELECT USING (auth.uid() = user_id);

-- Wishlist table
CREATE TABLE wishlist (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  ritual_id UUID REFERENCES rituals(id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, ritual_id)
);

ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own wishlist" ON wishlist
  USING (auth.uid() = user_id);

-- Reviews table
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  ritual_id UUID REFERENCES rituals(id) NOT NULL,
  order_id UUID REFERENCES orders(id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  images TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read reviews" ON reviews
  FOR SELECT USING (true);
CREATE POLICY "Users can create own reviews" ON reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Notifications table
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

-- Loyalty Points table
CREATE TABLE loyalty_points (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  tier TEXT NOT NULL DEFAULT 'bronze',
  lifetime_points INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

ALTER TABLE loyalty_points ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read own loyalty points" ON loyalty_points
  FOR SELECT USING (auth.uid() = user_id);

-- Coupons table
CREATE TABLE coupons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL,
  discount_type TEXT NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  min_order_amount DECIMAL(10,2),
  max_discount DECIMAL(10,2),
  valid_from TIMESTAMP WITH TIME ZONE NOT NULL,
  valid_until TIMESTAMP WITH TIME ZONE NOT NULL,
  usage_limit INTEGER,
  used_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read active coupons" ON coupons
  FOR SELECT USING (is_active = TRUE);

-- Bookings table
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  ritual_id UUID REFERENCES rituals(id) NOT NULL,
  booking_date DATE NOT NULL,
  time_slot TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  participants JSONB,
  special_requests TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own bookings" ON bookings
  USING (auth.uid() = user_id);

-- Tracking table
CREATE TABLE tracking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES orders(id) NOT NULL,
  status TEXT NOT NULL,
  location TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE tracking ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read tracking for own orders" ON tracking
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = tracking.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Blogs table
CREATE TABLE blogs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  excerpt TEXT,
  image_url TEXT,
  author TEXT NOT NULL,
  category TEXT NOT NULL,
  tags TEXT[],
  published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE blogs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read blogs" ON blogs
  FOR SELECT USING (true);

-- FAQs table
CREATE TABLE faqs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  category TEXT NOT NULL,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read FAQs" ON faqs
  FOR SELECT USING (true);

-- Temples table
CREATE TABLE temples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  deity TEXT,
  timings TEXT,
  contact TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE temples ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read temples" ON temples
  FOR SELECT USING (true);
```

## 🗄️ Storage Buckets

Create these storage buckets in Supabase Storage:

1. **profile-images**
   - Public: Yes
   - File size limit: 5MB
   - Allowed MIME types: image/*

2. **ritual-images**
   - Public: Yes
   - File size limit: 10MB
   - Allowed MIME types: image/*

3. **review-images**
   - Public: Yes
   - File size limit: 5MB
   - Allowed MIME types: image/*

4. **invoices**
   - Public: No
   - File size limit: 2MB
   - Allowed MIME types: application/pdf

### Storage Policies

```sql
-- Profile images: Users can upload their own
CREATE POLICY "Users can upload own profile images" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'profile-images' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Ritual images: Public read
CREATE POLICY "Anyone can read ritual images" ON storage.objects
  FOR SELECT USING (bucket_id = 'ritual-images');

-- Review images: Users can upload
CREATE POLICY "Users can upload review images" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'review-images' AND
    auth.uid() IS NOT NULL
  );

-- Invoices: Users can read own invoices
CREATE POLICY "Users can read own invoices" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'invoices' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

## 📱 Flutter Integration

### 1. Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  supabase_flutter: ^2.0.0
  flutter_localizations:
    sdk: flutter
```

### 2. Initialize Supabase

Already done in `main.dart`:

```dart
await SupabaseConfig.initialize();
```

### 3. Update Auth Provider

Replace Firebase auth calls with Supabase:

```dart
// Sign up
final response = await SupabaseAuthService().signUp(
  email: email,
  password: password,
  fullName: fullName,
  phone: phone,
);

// Sign in
final response = await SupabaseAuthService().signIn(
  email: email,
  password: password,
);

// Sign out
await SupabaseAuthService().signOut();
```

### 4. Update Data Providers

Replace Firestore calls with Supabase:

```dart
// Fetch rituals
final response = await SupabaseConfig.client
    .from(SupabaseConfig.ritualsTable)
    .select()
    .order('created_at', ascending: false);

// Add to wishlist
await SupabaseConfig.client
    .from(SupabaseConfig.wishlistTable)
    .insert({
      'user_id': userId,
      'ritual_id': ritualId,
    });

// Fetch user orders
final response = await SupabaseConfig.client
    .from(SupabaseConfig.ordersTable)
    .select('*, rituals(*)')
    .eq('user_id', userId)
    .order('created_at', ascending: false);
```

## 🔐 Authentication

### Email/Password Auth

```dart
// Sign up
final response = await Supabase.instance.client.auth.signUp(
  email: email,
  password: password,
);

// Sign in
final response = await Supabase.instance.client.auth.signInWithPassword(
  email: email,
  password: password,
);
```

### Phone Auth (OTP)

```dart
// Send OTP
await Supabase.instance.client.auth.signInWithOtp(
  phone: '+91$phone',
);

// Verify OTP
final response = await Supabase.instance.client.auth.verifyOTP(
  phone: '+91$phone',
  token: otp,
  type: OtpType.sms,
);
```

### Password Reset

```dart
// Send reset email
await Supabase.instance.client.auth.resetPasswordForEmail(email);

// Update password
await Supabase.instance.client.auth.updateUser(
  UserAttributes(password: newPassword),
);
```

## 🔄 Real-time Subscriptions

Subscribe to real-time changes:

```dart
// Listen to order updates
final subscription = Supabase.instance.client
    .from('orders')
    .stream(primaryKey: ['id'])
    .eq('user_id', userId)
    .listen((data) {
      // Update UI with new data
    });

// Cancel subscription
subscription.cancel();
```

## 📤 File Upload

```dart
// Upload profile image
final file = File(imagePath);
final bytes = await file.readAsBytes();
final fileName = '${userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';

await Supabase.instance.client.storage
    .from('profile-images')
    .uploadBinary(fileName, bytes);

// Get public URL
final url = Supabase.instance.client.storage
    .from('profile-images')
    .getPublicUrl(fileName);
```

## 🧪 Testing

### Test Authentication

```dart
// Test sign up
final response = await SupabaseAuthService().signUp(
  email: 'test@example.com',
  password: 'Test@123',
  fullName: 'Test User',
  phone: '+919876543210',
);

assert(response.user != null);
```

### Test Database Operations

```dart
// Test insert
final response = await Supabase.instance.client
    .from('rituals')
    .insert({
      'name': 'Test Ritual',
      'price': 500.00,
      'category': 'puja',
    })
    .select()
    .single();

assert(response['id'] != null);
```

## 🚨 Error Handling

```dart
try {
  final response = await Supabase.instance.client
      .from('rituals')
      .select();
} on PostgrestException catch (e) {
  // Handle database errors
  print('Database error: ${e.message}');
} on AuthException catch (e) {
  // Handle auth errors
  print('Auth error: ${e.message}');
} catch (e) {
  // Handle other errors
  print('Error: $e');
}
```

## 📊 Migration Checklist

- [ ] Create Supabase project
- [ ] Set up database schema
- [ ] Create storage buckets
- [ ] Configure RLS policies
- [ ] Update config with credentials
- [ ] Test authentication
- [ ] Test database operations
- [ ] Test file uploads
- [ ] Migrate existing data (if any)
- [ ] Update all providers
- [ ] Test all features
- [ ] Deploy to production

## 🔗 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

**Status**: Ready for implementation
**Last Updated**: November 14, 2024

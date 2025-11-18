# Backend Setup Guide - Mandir Mitra

Complete guide to set up Supabase + Cloudinary + Razorpay backend.

---

## 🚀 Quick Setup (30 minutes)

### Step 1: Supabase Setup (10 min)

1. **Create Supabase Project**
   - Go to [supabase.com](https://supabase.com)
   - Click "New Project"
   - Name: `mandir-mitra`
   - Database Password: (save securely)
   - Region: `ap-south-1` (Mumbai - closest to India)
   - Wait 2 minutes for setup

2. **Get Credentials**
   - Go to Settings → API
   - Copy:
     - Project URL: `https://xxxxx.supabase.co`
     - `anon` public key: `eyJhbGc...`

3. **Update Config**
   ```dart
   // lib/config/supabase_config.dart
   static const String supabaseUrl = 'YOUR_PROJECT_URL';
   static const String supabaseAnonKey = 'YOUR_ANON_KEY';
   ```

4. **Run Database Schema**
   - Go to SQL Editor in Supabase
   - Copy SQL from `supabase_schema.sql` (below)
   - Click "Run"

---

### Step 2: Cloudinary Setup (5 min)

1. **Create Account**
   - Go to [cloudinary.com](https://cloudinary.com)
   - Sign up (free tier: 25GB storage, 25GB bandwidth)

2. **Get Credentials**
   - Dashboard → Account Details
   - Copy:
     - Cloud Name: `dxxxxx`
     - API Key: `123456789`
     - API Secret: `abcdef...`

3. **Create Upload Preset**
   - Settings → Upload → Upload Presets
   - Click "Add upload preset"
   - Name: `mandir_mitra_unsigned`
   - Signing Mode: `Unsigned`
   - Folder: `mandir-mitra`
   - Save

4. **Add to Flutter**
   ```dart
   // lib/config/cloudinary_config.dart
   class CloudinaryConfig {
     static const String cloudName = 'YOUR_CLOUD_NAME';
     static const String uploadPreset = 'mandir_mitra_unsigned';
     static const String apiKey = 'YOUR_API_KEY';
   }
   ```

---

### Step 3: Razorpay Setup (10 min)

1. **Create Account**
   - Go to [razorpay.com](https://razorpay.com)
   - Sign up with business details
   - Complete KYC (required for live mode)

2. **Get Test Keys**
   - Dashboard → Settings → API Keys
   - Generate Test Keys
   - Copy:
     - Key ID: `rzp_test_xxxxx`
     - Key Secret: `xxxxx`

3. **Add to Flutter**
   ```dart
   // lib/config/razorpay_config.dart
   class RazorpayConfig {
     static const String keyId = 'rzp_test_xxxxx';
     static const String keySecret = 'xxxxx'; // Keep secure!
   }
   ```

4. **Add Dependencies**
   ```yaml
   # pubspec.yaml
   dependencies:
     razorpay_flutter: ^1.3.6
     cloudinary_public: ^0.21.0
   ```

---

### Step 4: Enable Phone Auth (5 min)

1. **Supabase Phone Auth**
   - Go to Authentication → Providers
   - Enable "Phone"
   - Choose provider: Twilio (recommended)

2. **Twilio Setup** (for OTP)
   - Go to [twilio.com](https://twilio.com)
   - Sign up (free trial: $15 credit)
   - Get:
     - Account SID
     - Auth Token
     - Phone Number
   - Add to Supabase → Phone Auth settings

---

## 📊 Database Schema

Create this in Supabase SQL Editor:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE,
  full_name TEXT NOT NULL,
  phone TEXT,
  profile_image_url TEXT, -- Cloudinary URL
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can read own data" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own data" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Rituals table (updated weekly by admin)
CREATE TABLE public.rituals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category TEXT NOT NULL,
  deity TEXT,
  duration TEXT,
  image_url TEXT, -- Cloudinary URL
  images TEXT[], -- Array of Cloudinary URLs
  video_url TEXT, -- Cloudinary video URL
  benefits TEXT[],
  includes TEXT[],
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.rituals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active rituals" ON public.rituals
  FOR SELECT USING (is_active = TRUE);

-- Orders table
CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) NOT NULL,
  ritual_id UUID REFERENCES public.rituals(id) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  total_amount DECIMAL(10,2) NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'pending',
  razorpay_order_id TEXT,
  razorpay_payment_id TEXT,
  razorpay_signature TEXT,
  booking_date DATE NOT NULL,
  participants JSONB,
  special_requests TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own orders" ON public.orders
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders" ON public.orders
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Wishlist table
CREATE TABLE public.wishlist (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) NOT NULL,
  ritual_id UUID REFERENCES public.rituals(id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, ritual_id)
);

ALTER TABLE public.wishlist ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own wishlist" ON public.wishlist
  USING (auth.uid() = user_id);

-- Reviews table
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) NOT NULL,
  ritual_id UUID REFERENCES public.rituals(id) NOT NULL,
  order_id UUID REFERENCES public.orders(id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  images TEXT[], -- Cloudinary URLs
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read reviews" ON public.reviews
  FOR SELECT USING (true);

CREATE POLICY "Users can create own reviews" ON public.reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Notifications table
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own notifications" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- Loyalty Points table
CREATE TABLE public.loyalty_points (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) NOT NULL UNIQUE,
  points INTEGER NOT NULL DEFAULT 0,
  tier TEXT NOT NULL DEFAULT 'bronze',
  lifetime_points INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.loyalty_points ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own loyalty points" ON public.loyalty_points
  FOR SELECT USING (auth.uid() = user_id);

-- Coupons table
CREATE TABLE public.coupons (
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

ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active coupons" ON public.coupons
  FOR SELECT USING (is_active = TRUE AND NOW() BETWEEN valid_from AND valid_until);

-- Temples table
CREATE TABLE public.temples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  description TEXT,
  image_url TEXT, -- Cloudinary URL
  images TEXT[], -- Cloudinary URLs
  deity TEXT,
  timings TEXT,
  contact TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.temples ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active temples" ON public.temples
  FOR SELECT USING (is_active = TRUE);

-- Blogs table
CREATE TABLE public.blogs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  excerpt TEXT,
  image_url TEXT, -- Cloudinary URL
  author TEXT NOT NULL,
  category TEXT NOT NULL,
  tags TEXT[],
  is_published BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.blogs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read published blogs" ON public.blogs
  FOR SELECT USING (is_published = TRUE);

-- FAQs table
CREATE TABLE public.faqs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  category TEXT NOT NULL,
  order_index INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.faqs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active FAQs" ON public.faqs
  FOR SELECT USING (is_active = TRUE);

-- Live Streams table
CREATE TABLE public.live_streams (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  ritual_id UUID REFERENCES public.rituals(id),
  temple_id UUID REFERENCES public.temples(id),
  stream_url TEXT, -- Cloudinary or Agora URL
  thumbnail_url TEXT, -- Cloudinary URL
  status TEXT NOT NULL DEFAULT 'scheduled',
  scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
  started_at TIMESTAMP WITH TIME ZONE,
  ended_at TIMESTAMP WITH TIME ZONE,
  viewer_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.live_streams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read live streams" ON public.live_streams
  FOR SELECT USING (true);

-- Admin users table (for admin panel)
CREATE TABLE public.admin_users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'admin',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can read admin users" ON public.admin_users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE id = auth.uid() AND is_active = TRUE
    )
  );

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, phone)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'phone', '')
  );
  
  -- Create loyalty points entry
  INSERT INTO public.loyalty_points (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add updated_at triggers
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.rituals
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.loyalty_points
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
```

---

## 🔧 Cloudinary Integration

### Upload Image Helper

```dart
// lib/services/cloudinary_service.dart
import 'package:cloudinary_public/cloudinary_public.dart';
import '../config/cloudinary_config.dart';

class CloudinaryService {
  static final _cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
    cache: false,
  );

  // Upload single image
  static Future<String> uploadImage(
    String filePath, {
    String folder = 'rituals',
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: 'mandir-mitra/$folder',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload multiple images
  static Future<List<String>> uploadMultipleImages(
    List<String> filePaths, {
    String folder = 'rituals',
  }) async {
    final urls = <String>[];
    for (final path in filePaths) {
      final url = await uploadImage(path, folder: folder);
      urls.add(url);
    }
    return urls;
  }

  // Upload video
  static Future<String> uploadVideo(String filePath) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: 'mandir-mitra/videos',
          resourceType: CloudinaryResourceType.Video,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  // Get optimized image URL
  static String getOptimizedUrl(
    String url, {
    int? width,
    int? height,
    String quality = 'auto',
  }) {
    // Cloudinary transformation
    final transformations = <String>[];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_auto');

    return url.replaceFirst(
      '/upload/',
      '/upload/${transformations.join(',')}/');
  }
}
```

---

## 💳 Razorpay Integration

### Payment Service

```dart
// lib/services/razorpay_service.dart
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config/razorpay_config.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  Future<void> openCheckout({
    required String orderId,
    required double amount,
    required String name,
    required String email,
    required String phone,
    String? description,
  }) async {
    final options = {
      'key': RazorpayConfig.keyId,
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': 'Mandir Mitra',
      'order_id': orderId,
      'description': description ?? 'Ritual Booking',
      'prefill': {
        'contact': phone,
        'email': email,
        'name': name,
      },
      'theme': {
        'color': '#FF6B35',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      throw Exception('Failed to open Razorpay: $e');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
```

---

## 🔐 Edge Functions

### Create Payment Order

```typescript
// supabase/functions/create-payment-order/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Razorpay from "https://esm.sh/razorpay@2.9.2"

const razorpay = new Razorpay({
  key_id: Deno.env.get('RAZORPAY_KEY_ID')!,
  key_secret: Deno.env.get('RAZORPAY_KEY_SECRET')!,
})

serve(async (req) => {
  try {
    const { amount, currency = 'INR', receipt } = await req.json()

    const order = await razorpay.orders.create({
      amount: amount * 100, // Convert to paise
      currency,
      receipt,
    })

    return new Response(
      JSON.stringify({ orderId: order.id }),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    )
  }
})
```

### Verify Payment

```typescript
// supabase/functions/verify-payment/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { createHmac } from "https://deno.land/std@0.168.0/node/crypto.ts"

serve(async (req) => {
  try {
    const {
      razorpay_order_id,
      razorpay_payment_id,
      razorpay_signature,
      order_id,
    } = await req.json()

    // Verify signature
    const text = `${razorpay_order_id}|${razorpay_payment_id}`
    const secret = Deno.env.get('RAZORPAY_KEY_SECRET')!
    const generated_signature = createHmac('sha256', secret)
      .update(text)
      .digest('hex')

    if (generated_signature !== razorpay_signature) {
      throw new Error('Invalid signature')
    }

    // Update order in database
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    await supabase
      .from('orders')
      .update({
        payment_status: 'completed',
        razorpay_order_id,
        razorpay_payment_id,
        razorpay_signature,
        status: 'confirmed',
      })
      .eq('id', order_id)

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    )
  }
})
```

---

## 📱 Weekly Ritual Updates

### Admin Panel Features

The admin panel (already created) allows:

1. **Add New Rituals**
   - Upload images to Cloudinary
   - Set price, category, deity
   - Add benefits and includes

2. **Update Existing Rituals**
   - Edit details
   - Update images
   - Change pricing

3. **Manage Availability**
   - Mark rituals as active/inactive
   - Feature rituals on homepage

4. **Bulk Operations**
   - Import rituals from CSV
   - Bulk price updates
   - Bulk image uploads

### Admin Access

```sql
-- Create admin user
INSERT INTO public.admin_users (id, email, full_name, role)
VALUES (
  'YOUR_USER_ID',
  'admin@mandirmitra.com',
  'Admin User',
  'super_admin'
);
```

---

## ✅ Testing Checklist

### Supabase
- [ ] Database schema created
- [ ] RLS policies working
- [ ] Auth signup/login works
- [ ] Phone OTP works
- [ ] Real-time subscriptions work

### Cloudinary
- [ ] Image upload works
- [ ] Multiple images upload
- [ ] Video upload works
- [ ] Optimized URLs generated

### Razorpay
- [ ] Test payment works
- [ ] Payment verification works
- [ ] Order creation works
- [ ] Webhook handling works

### Admin Panel
- [ ] Admin login works
- [ ] Add ritual works
- [ ] Update ritual works
- [ ] Image upload to Cloudinary works

---

## 🚀 Go Live Checklist

### Supabase
- [ ] Move to production plan
- [ ] Set up database backups
- [ ] Configure custom domain
- [ ] Enable email templates

### Cloudinary
- [ ] Upgrade to paid plan (if needed)
- [ ] Set up auto-backup
- [ ] Configure CDN

### Razorpay
- [ ] Complete KYC
- [ ] Get live API keys
- [ ] Set up webhooks
- [ ] Configure settlement account

### Security
- [ ] Enable 2FA for admin
- [ ] Set up rate limiting
- [ ] Configure CORS
- [ ] Add API key rotation

---

## 📞 Support

- **Supabase**: [docs.supabase.com](https://docs.supabase.com)
- **Cloudinary**: [cloudinary.com/documentation](https://cloudinary.com/documentation)
- **Razorpay**: [razorpay.com/docs](https://razorpay.com/docs)

---

**Setup Time**: ~30 minutes
**Cost**: Free tier for development
**Production Cost**: ~$50-100/month for 1000 users

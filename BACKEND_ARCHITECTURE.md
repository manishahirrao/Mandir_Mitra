# Backend Architecture for Mandir Mitra

## Overview
Production-ready backend architecture using Supabase, Cloudinary, and Razorpay.

---

## 🎯 Final Tech Stack

### **Core Technologies**

```
Database: PostgreSQL (Supabase)
Authentication: Supabase Auth (Email, Phone OTP)
Storage: Cloudinary (Images, Videos, PDFs)
Payment: Razorpay (Indian market optimized)
Real-time: Supabase Realtime (Live streaming, notifications)
Functions: Supabase Edge Functions (Deno/TypeScript)
Admin Panel: Flutter Web (Weekly ritual updates)
```

### **Why This Stack?**

✅ **Supabase** - PostgreSQL database, auth, real-time subscriptions
✅ **Cloudinary** - Optimized image/video delivery, transformations, CDN
✅ **Razorpay** - Best for Indian payments (UPI, cards, wallets, EMI)
✅ **Weekly Updates** - Admin panel for ritual management
✅ **Scalable** - Handles growth from 100 to 100K users
✅ **Cost-Effective** - Free tiers + pay-as-you-grow

---

## 🏗️ Architecture Overview

```
┌─────────────────┐
│  Flutter App    │
│  (User Side)    │
└────────┬────────┘
         │
         ├──────────────┐
         │              │
    ┌────▼─────┐   ┌───▼──────┐
    │ Supabase │   │Cloudinary│
    │          │   │          │
    │ • Auth   │   │ • Images │
    │ • DB     │   │ • Videos │
    │ • RT     │   │ • CDN    │
    └────┬─────┘   └──────────┘
         │
    ┌────▼─────────┐
    │ Edge Functions│
    │              │
    │ • Payments   │
    │ • Webhooks   │
    │ • Emails     │
    └────┬─────────┘
         │
    ┌────▼─────┐
    │ Razorpay │
    │ Payments │
    └──────────┘

┌─────────────────┐
│  Admin Panel    │
│  (Flutter Web)  │
│                 │
│ • Add Rituals   │
│ • Update Weekly │
│ • Manage Orders │
└─────────────────┘
```

---

## 📊 Database Schema (PostgreSQL)

### **Core Tables**

**User
s** - User profiles and authentication
**Rituals** - Ritual catalog (updated weekly by admin)
**Orders** - Booking and payment records
**Wishlist** - User saved rituals
**Reviews** - User ratings and feedback
**Notifications** - Push notifications
**Loyalty Points** - Rewards system
**Coupons** - Discount codes
**Temples** - Temple information
**Blogs** - Content management
**FAQs** - Help content
**Live Streams** - Live ritual streaming
**Admin Users** - Admin panel access

### **Key Features**

1. **Row Level Security (RLS)** - Users only see their own data
2. **Real-time Subscriptions** - Live updates for orders, notifications
3. **Automatic Timestamps** - created_at, updated_at auto-managed
4. **Foreign Keys** - Data integrity maintained
5. **Indexes** - Fast queries on common filters

---

## 🖼️ Cloudinary Integration

### **Why Cloudinary?**

✅ **Automatic Optimization** - Images auto-compressed
✅ **CDN Delivery** - Fast loading worldwide
✅ **Transformations** - Resize, crop, format on-the-fly
✅ **Video Support** - Live stream recordings
✅ **Free Tier** - 25GB storage, 25GB bandwidth
✅ **Easy Upload** - Direct from Flutter app

### **Folder Structure**

```
mandir-mitra/
├── rituals/          # Ritual images
├── profiles/         # User profile pictures
├── reviews/          # Review images
├── temples/          # Temple images
├── blogs/            # Blog images
└── videos/           # Live stream recordings
```

### **Image Transformations**

```dart
// Thumbnail (300x300)
CloudinaryService.getThumbnailUrl(imageUrl)

// Medium (800x600)
CloudinaryService.getOptimizedUrl(imageUrl, width: 800, height: 600)

// Large (1200x900)
CloudinaryService.getOptimizedUrl(imageUrl, width: 1200, height: 900)
```

---

## 💳 Razorpay Integration

### **Why Razorpay?**

✅ **Indian Market** - UPI, cards, wallets, EMI
✅ **Easy Integration** - Flutter package available
✅ **Low Fees** - 2% per transaction
✅ **Instant Settlement** - T+1 or T+2 days
✅ **Payment Links** - Share via WhatsApp
✅ **Subscriptions** - Recurring payments

### **Payment Flow**

```
1. User clicks "Book Ritual"
2. App creates order in Supabase
3. Edge Function creates Razorpay order
4. Razorpay checkout opens
5. User completes payment
6. Webhook verifies payment
7. Order status updated to "confirmed"
8. User receives confirmation
```

### **Supported Payment Methods**

- Credit/Debit Cards (Visa, Mastercard, Rupay)
- Net Banking (all major banks)
- UPI (Google Pay, PhonePe, Paytm)
- Wallets (Paytm, Mobikwik, Freecharge)
- EMI (3, 6, 9, 12 months)

---

## 🔄 Weekly Ritual Updates

### **Admin Workflow**

1. **Login to Admin Panel** (Flutter web)
2. **Add/Update Rituals**
   - Upload images to Cloudinary
   - Set pricing and details
   - Mark as featured
3. **Publish Changes**
   - Changes reflect immediately
   - No app update needed

### **User Experience**

- New rituals appear on home screen
- Featured rituals in carousel
- Real-time updates via Supabase
- Cached for offline viewing

### **Automation Options**

```sql
-- Schedule ritual activation
CREATE OR REPLACE FUNCTION activate_scheduled_rituals()
RETURNS void AS $$
BEGIN
  UPDATE rituals
  SET is_active = TRUE
  WHERE scheduled_date <= NOW()
  AND is_active = FALSE;
END;
$$ LANGUAGE plpgsql;

-- Run daily via pg_cron
SELECT cron.schedule('activate-rituals', '0 0 * * *', 'SELECT activate_scheduled_rituals()');
```

---

## 🔐 Security

### **Authentication**

- Email/password with verification
- Phone OTP (via Twilio)
- JWT tokens (auto-managed by Supabase)
- Session management
- Password reset flow

### **Authorization**

- Row Level Security (RLS) on all tables
- Users can only access their own data
- Admin role for admin panel
- API rate limiting

### **Data Protection**

- HTTPS only
- Encrypted at rest (Supabase)
- Secure payment handling (Razorpay PCI-DSS)
- No sensitive data in client

---

## 📊 Scalability

### **Database**

- PostgreSQL handles millions of rows
- Indexes on common queries
- Connection pooling
- Read replicas (if needed)

### **Storage**

- Cloudinary CDN (global)
- Automatic image optimization
- Lazy loading in app
- Progressive image loading

### **API**

- Supabase auto-scales
- Edge Functions (serverless)
- Rate limiting per user
- Caching strategy

---

## 🚀 Deployment

### **Development**

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run admin panel
cd admin_panel
flutter run -d chrome
```

### **Production**

```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build Admin Panel (Web)
cd admin_panel
flutter build web --release
```

---

## 📈 Monitoring

### **Supabase Dashboard**

- Database usage
- API requests
- Active users
- Error logs

### **Cloudinary Dashboard**

- Storage usage
- Bandwidth usage
- Transformations
- Popular images

### **Razorpay Dashboard**

- Transaction volume
- Success rate
- Settlement status
- Refunds

---

## 💰 Cost Breakdown

### **Free Tier (Development)**

- Supabase: 500MB DB, 1GB storage, 2GB bandwidth
- Cloudinary: 25GB storage, 25GB bandwidth
- Razorpay: Unlimited test transactions
- **Total: $0/month**

### **Production (1K users, 100 orders/month)**

- Supabase Pro: $25/month
- Cloudinary: Free tier sufficient
- Razorpay: 2% × ₹50,000 = ₹1,000
- **Total: ~$40/month**

### **Production (10K users, 1000 orders/month)**

- Supabase Pro: $25/month
- Cloudinary Plus: $89/month
- Razorpay: 2% × ₹5,00,000 = ₹10,000
- **Total: ~$250/month**

---

## 🎯 Implementation Priority

### **Phase 1: Core Backend** (Week 1)
- ✅ Supabase setup
- ✅ Database schema
- ✅ Authentication
- ✅ Basic CRUD operations

### **Phase 2: Storage & Payments** (Week 2)
- ✅ Cloudinary integration
- ✅ Image upload
- ✅ Razorpay integration
- ✅ Payment flow

### **Phase 3: Admin Panel** (Week 3)
- ✅ Admin authentication
- ✅ Ritual management
- ✅ Order management
- ✅ Analytics

### **Phase 4: Advanced Features** (Week 4)
- ✅ Real-time notifications
- ✅ Live streaming
- ✅ Loyalty system
- ✅ Reviews & ratings

---

## 📚 Resources

- **Supabase Docs**: [docs.supabase.com](https://docs.supabase.com)
- **Cloudinary Docs**: [cloudinary.com/documentation](https://cloudinary.com/documentation)
- **Razorpay Docs**: [razorpay.com/docs](https://razorpay.com/docs)
- **Flutter Supabase**: [pub.dev/packages/supabase_flutter](https://pub.dev/packages/supabase_flutter)
- **Razorpay Flutter**: [pub.dev/packages/razorpay_flutter](https://pub.dev/packages/razorpay_flutter)

---

**Status**: Ready for Implementation
**Estimated Setup Time**: 2-3 hours
**Difficulty**: Medium
**Last Updated**: November 15, 2024

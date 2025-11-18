# Backend Implementation Steps

Quick guide to implement Supabase + Cloudinary + Razorpay backend.

---

## 🚀 Implementation Order (2-3 hours)

### Phase 1: Setup Accounts (30 min)

**Step 1: Supabase** (10 min)
1. Go to [supabase.com](https://supabase.com) → Sign up
2. Create project: `mandir-mitra`
3. Region: `ap-south-1` (Mumbai)
4. Copy URL and anon key
5. Update `lib/config/supabase_config.dart`

**Step 2: Cloudinary** (10 min)
1. Go to [cloudinary.com](https://cloudinary.com) → Sign up
2. Copy cloud name, API key
3. Create upload preset: `mandir_mitra_unsigned` (unsigned)
4. Update `lib/config/cloudinary_config.dart`

**Step 3: Razorpay** (10 min)
1. Go to [razorpay.com](https://razorpay.com) → Sign up
2. Get test keys (Dashboard → Settings → API Keys)
3. Update `lib/config/razorpay_config.dart`

---

### Phase 2: Database Setup (30 min)

**Step 4: Run SQL Schema**
1. Open Supabase → SQL Editor
2. Copy entire SQL from `BACKEND_SETUP_GUIDE.md`
3. Click "Run"
4. Verify tables created (should see 15+ tables)

**Step 5: Enable Phone Auth**
1. Supabase → Authentication → Providers
2. Enable "Phone"
3. Choose Twilio (or skip for now, use email only)

---

### Phase 3: Flutter Integration (1 hour)

**Step 6: Install Dependencies**
```bash
flutter pub add razorpay_flutter cloudinary_public
flutter pub get
```

**Step 7: Update Payment Provider**

Edit `lib/services/payment_provider.dart`:

```dart
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config/supabase_config.dart';
import 'razorpay_service.dart';

class PaymentProvider extends ChangeNotifier {
  final _razorpayService = RazorpayService();
  
  Future<void> initiatePayment({
    required String orderId,
    required double amount,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) async {
    // Create Razorpay order via Edge Function
    final response = await SupabaseConfig.client.functions.invoke(
      'create-payment-order',
      body: {
        'amount': amount,
        'receipt': orderId,
      },
    );
    
    final razorpayOrderId = response.data['orderId'];
    
    // Open Razorpay checkout
    _razorpayService.onSuccess = (response) async {
      await _verifyPayment(
        orderId: orderId,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: response.paymentId!,
        razorpaySignature: response.signature!,
      );
    };
    
    _razorpayService.onFailure = (response) {
      // Handle failure
    };
    
    await _razorpayService.openCheckout(
      orderId: razorpayOrderId,
      amount: amount,
      name: userName,
      email: userEmail,
      phone: userPhone,
    );
  }
  
  Future<void> _verifyPayment({
    required String orderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    await SupabaseConfig.client.functions.invoke(
      'verify-payment',
      body: {
        'order_id': orderId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      },
    );
  }
}
```

**Step 8: Update Rituals Provider**

Edit `lib/services/rituals_provider.dart`:

```dart
import '../config/supabase_config.dart';
import '../models/ritual.dart';

class RitualsProvider extends ChangeNotifier {
  List<Ritual> _rituals = [];
  
  Future<void> fetchRituals() async {
    final response = await SupabaseConfig.client
        .from(SupabaseConfig.ritualsTable)
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false);
    
    _rituals = (response as List)
        .map((json) => Ritual.fromJson(json))
        .toList();
    
    notifyListeners();
  }
  
  Future<void> fetchFeaturedRituals() async {
    final response = await SupabaseConfig.client
        .from(SupabaseConfig.ritualsTable)
        .select()
        .eq('is_active', true)
        .eq('is_featured', true)
        .limit(5);
    
    // Process response
  }
}
```

---

### Phase 4: Edge Functions (30 min)

**Step 9: Create Edge Functions**

1. Install Supabase CLI:
```bash
npm install -g supabase
```

2. Login:
```bash
supabase login
```

3. Link project:
```bash
supabase link --project-ref YOUR_PROJECT_REF
```

4. Create functions:
```bash
supabase functions new create-payment-order
supabase functions new verify-payment
```

5. Copy code from `BACKEND_SETUP_GUIDE.md`

6. Deploy:
```bash
supabase functions deploy create-payment-order
supabase functions deploy verify-payment
```

7. Set secrets:
```bash
supabase secrets set RAZORPAY_KEY_ID=rzp_test_xxxxx
supabase secrets set RAZORPAY_KEY_SECRET=xxxxx
```

---

### Phase 5: Admin Panel Integration (30 min)

**Step 10: Update Admin Panel**

The admin panel is already created. Just update:

1. `admin_panel/lib/services/admin_auth_service.dart` - Use Supabase auth
2. Add Cloudinary upload in ritual management
3. Test adding a ritual with images

---

## ✅ Testing Checklist

### Test Authentication
- [ ] Sign up with email works
- [ ] Login works
- [ ] Password reset works
- [ ] Phone OTP works (if enabled)

### Test Rituals
- [ ] Fetch rituals from Supabase
- [ ] Display ritual images from Cloudinary
- [ ] Filter rituals works
- [ ] Search rituals works

### Test Payments
- [ ] Create order works
- [ ] Razorpay checkout opens
- [ ] Test payment succeeds
- [ ] Order status updates
- [ ] Payment verification works

### Test Admin Panel
- [ ] Admin login works
- [ ] Add ritual works
- [ ] Upload images to Cloudinary works
- [ ] Update ritual works
- [ ] Mark ritual as featured works

---

## 🔧 Troubleshooting

### Supabase Connection Issues
```dart
// Check if Supabase is initialized
print(SupabaseConfig.client.auth.currentUser);
```

### Cloudinary Upload Fails
- Check cloud name is correct
- Verify upload preset is "unsigned"
- Check folder permissions

### Razorpay Not Opening
- Verify key ID is correct
- Check amount is in correct format (paise)
- Ensure Razorpay is initialized

### Edge Functions Not Working
- Check function is deployed
- Verify secrets are set
- Check function logs: `supabase functions logs`

---

## 📱 Weekly Ritual Updates Workflow

### For Admin:

1. **Login to Admin Panel**
   - Open admin panel (Flutter web)
   - Login with admin credentials

2. **Add New Ritual**
   - Click "Add Ritual"
   - Fill details (name, price, category, deity)
   - Upload images (auto-uploads to Cloudinary)
   - Add benefits and includes
   - Mark as featured (optional)
   - Click "Save"

3. **Update Existing Ritual**
   - Search for ritual
   - Click "Edit"
   - Update details/images
   - Click "Update"

4. **Bulk Operations**
   - Import CSV with ritual data
   - Bulk update prices
   - Bulk activate/deactivate

### For Users:

- New rituals appear automatically on home screen
- Featured rituals show in carousel
- Real-time updates (no app restart needed)

---

## 💰 Cost Estimate

### Development (Free Tier)
- Supabase: Free (500MB DB, 1GB storage, 2GB bandwidth)
- Cloudinary: Free (25GB storage, 25GB bandwidth)
- Razorpay: Free (test mode)
- **Total: $0/month**

### Production (1000 users)
- Supabase Pro: $25/month (8GB DB, 100GB storage)
- Cloudinary: $89/month (or stay on free tier)
- Razorpay: 2% per transaction
- **Total: ~$50-100/month**

### Production (10,000 users)
- Supabase Pro: $25/month
- Cloudinary Plus: $89/month
- Razorpay: 2% per transaction
- **Total: ~$150-200/month**

---

## 🚀 Next Steps

1. **Complete Setup** (follow Phase 1-5 above)
2. **Test Everything** (use checklist)
3. **Add Sample Data** (10-20 rituals via admin panel)
4. **Test User Flow** (signup → browse → book → pay)
5. **Go Live** (switch to production keys)

---

## 📞 Need Help?

- Supabase: [discord.supabase.com](https://discord.supabase.com)
- Cloudinary: [support.cloudinary.com](https://support.cloudinary.com)
- Razorpay: [razorpay.com/support](https://razorpay.com/support)

---

**Estimated Time**: 2-3 hours
**Difficulty**: Medium
**Prerequisites**: Flutter, basic SQL knowledge

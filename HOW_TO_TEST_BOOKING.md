# How to Test the Booking Flow

## ✅ Setup Complete!

The booking functionality is now fully integrated. Here's how to test it:

## Step-by-Step Testing Guide

### 1. Navigate to a Ritual
- Open the app
- Go to **Services** screen (bottom navigation)
- Tap on any ritual card

### 2. View Ritual Details
- You'll see the Ritual Detail screen with:
  - Image gallery at top
  - Ritual information
  - Package selector (Shared/Family/Personal)
  - Tabs: Details, Process, Aashirwad Box, Reviews
  - Bottom bar with price and **"Book Now"** button

### 3. Select a Package
- Tap on one of the package options:
  - **Shared Package** - ₹1,100
  - **Family Package** - ₹5,100 (default)
  - **Personal Package** - ₹11,000
- The price in the bottom bar will update

### 4. Click "Book Now"
- Tap the **"Book Now"** button at the bottom
- You'll be navigated to the **Booking Screen**

## What You'll See in Booking Screen

### Ritual Summary Card
- Shows the ritual image, name, temple, and selected package

### Booking Form
1. **Date & Time Selection**
   - Tap "Select Date" to choose a date (1-90 days from now)
   - Select a time slot:
     * 6:00 AM - 12:00 PM
     * 12:00 PM - 6:00 PM
     * 6:00 PM - 9:00 PM

2. **Number of Participants**
   - Use +/- buttons to adjust (minimum 1)
   - Price updates automatically

3. **Priest Preference**
   - Dropdown with options:
     * Any Available (default)
     * Pandit Rajesh Sharma
     * Pandit Suresh Mishra
     * Pandit Anil Chatterjee

4. **Special Requests**
   - Optional text field (200 characters max)
   - Add any specific requirements

5. **Aashirwad Box**
   - Toggle switch to include/exclude (₹500)
   - If enabled, select add-ons:
     * Extra Prasad (₹200)
     * Rudraksha Mala (₹500)
     * Sacred Thread Set (₹150)
     * Kumkum & Vibhuti (₹100)

6. **Delivery Address**
   - Appears when Aashirwad Box is enabled
   - Select from saved addresses:
     * Home - Bangalore
     * Work - Bangalore
     * + Add New Address

7. **Price Breakdown Card**
   - Shows itemized costs:
     * Base Price
     * Aashirwad Box (if selected)
     * Add-ons (if any)
     * GST (18%)
     * **Total Amount** (in gold color)

8. **Terms Checkbox**
   - Must accept cancellation policy to proceed

9. **Proceed to Payment Button**
   - Disabled until terms are accepted
   - Validates all required fields
   - Shows error if date/time not selected

## Current Status

### ✅ Working Features
- Navigation from Ritual Detail to Booking
- All form fields functional
- Real-time price calculation
- Form validation
- Dynamic UI updates
- Package selection integration
- Address selection from UserProvider

### ⏳ Next Steps (Payment Flow)
The booking screen is complete. When you tap "Proceed to Payment":
- Currently navigates to PaymentScreen (not yet created)
- Will show payment methods (UPI, Card, Net Banking, Wallet)
- Will process mock payment
- Will show success/failure screens

## Testing Tips

1. **Try Different Packages**
   - Go back and select different packages
   - Notice price changes in booking screen

2. **Test Participants Counter**
   - Add multiple participants
   - Watch price multiply

3. **Toggle Aashirwad Box**
   - Turn it on/off
   - See address field appear/disappear
   - Notice price changes

4. **Add Multiple Add-ons**
   - Select various add-on items
   - See price breakdown update

5. **Test Validation**
   - Try to proceed without selecting date
   - Try without accepting terms
   - See validation messages

## Quick Test Scenario

1. Open app → Services → Tap any ritual
2. Select "Family Package" (₹5,100)
3. Tap "Book Now"
4. Select tomorrow's date
5. Choose "12:00 PM - 6:00 PM" slot
6. Set 2 participants (price becomes ₹10,200)
7. Keep Aashirwad Box enabled
8. Add "Rudraksha Mala" (₹500)
9. Select "Home" address
10. Accept terms
11. Tap "Proceed to Payment"

**Expected Total**: ₹10,200 (base) + ₹500 (box) + ₹500 (rudraksha) = ₹11,200 + ₹2,016 (GST) = **₹13,216**

## Providers Added

The following providers are now available in the app:
- ✅ BookingProvider - Manages booking state
- ✅ PaymentProvider - Handles payment processing

Both are initialized in `main.dart` and ready to use throughout the app.

## Files Modified

1. **lib/screens/ritual_detail_screen.dart**
   - Added `_handleBookNow()` method
   - Added navigation to BookingScreen
   - Styled "Book Now" button

2. **lib/main.dart**
   - Added BookingProvider
   - Added PaymentProvider

## Next Development

To complete the booking flow, create:
1. Payment Screen (payment method selection)
2. Payment Success Screen (confirmation)
3. Payment Failed Screen (error handling)

All the infrastructure is ready - models, providers, and booking screen are complete!

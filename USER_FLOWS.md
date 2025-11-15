# Mandir Mitra - User Flows

## Overview
This document outlines the primary user journeys through the Mandir Mitra application, detailing each step from entry to completion.

---

## Flow 1: Booking a Public Ritual

### Journey Map
```
Home → Services → Ritual Detail → Package Selection → Booking → Payment → Confirmation
```

### Detailed Steps

#### 1. Entry Point
**User lands on Home screen**
- Sees greeting header with personalized message
- Views quick stats card
- Scrolls through hero banner carousel
- Sees service categories grid

#### 2. Navigation to Services
**Two paths available:**

**Path A: From Service Grid**
- Taps "Public Rituals" card from service categories grid
- Directly navigates to Services screen

**Path B: From Bottom Navigation**
- Taps "Rituals" icon in bottom navigation bar
- Opens Services screen

#### 3. Browse Rituals
**On Services Screen:**
- Views featured ritual banner at top
- Scrolls through filter chips (All, Everyday, Life Benefit, Dosh Nivaran, Special Occasions)
- Browses ritual cards in grid layout
- Each card shows:
  - Ritual image
  - Name
  - Starting price
  - Rating
  - Quick info

#### 4. View Ritual Details
**Taps ritual card → Detail page opens:**
- **Header Section:**
  - Image gallery (swipeable)
  - Ritual name
  - Temple location
  - Rating & reviews
  - Wishlist button
  
- **Information Tabs:**
  - Overview
  - What's Included
  - Benefits
  - Reviews

- **Scrolls through:**
  - Detailed description
  - Package options
  - Deity preferences
  - Date & time selection
  - Aashirwad Box details

#### 5. Package Selection
**User selects package:**
- **Shared Ritual** (₹51-151)
  - Group participation
  - Shared blessings
  - Video recording
  
- **Family Ritual** (₹501-1001)
  - Family name included
  - Personalized prayers
  - Video + photos
  
- **Personal Ritual** (₹1501-5001)
  - Exclusive ritual
  - Custom prayers
  - Live streaming option
  - Complete documentation

#### 6. Customization
**User customizes booking:**
- Selects preferred deity (if applicable)
- Chooses date from calendar
- Selects time slot
- Reviews Aashirwad Box contents:
  - Prasad
  - Sacred items
  - Blessed materials
  - Delivery details

#### 7. Booking Initiation
**Taps "Book Now" button:**
- **If not logged in:**
  - Redirected to Login/Signup screen
  - Completes authentication
  - Returns to booking flow
  
- **If logged in:**
  - Proceeds directly to payment

#### 8. Payment
**Payment screen displays:**
- Booking summary
- Selected package details
- Date & time
- Total amount
- Payment options:
  - UPI
  - Cards
  - Net Banking
  - Wallets

**User confirms payment:**
- Enters payment details
- Completes transaction
- Receives payment confirmation

#### 9. Success & Confirmation
**Success screen shows:**
- ✅ Booking confirmed message
- Unique booking ID
- Countdown timer to ritual
- Ritual details summary
- "View My Rituals" button

**Notifications sent:**
- Email confirmation with details
- SMS with booking ID
- Push notification

**User can:**
- View booking in "My Rituals" tab
- Track ritual status
- Receive updates
- Access video/photos after completion

---

## Flow 2: Creating Custom Personal Ritual

### Journey Map
```
Home/Personal Tab → Create Custom → Multi-Step Form → Submit → Admin Review → Proposal → Payment → Confirmation
```

### Detailed Steps

#### 1. Entry Point
**Two paths available:**

**Path A: From Home Screen**
- Scrolls to Personal Ritual section
- Taps "Create Custom Ritual" card

**Path B: From Personal Ritual Tab**
- Taps "Personal" in bottom navigation
- Sees "Create Custom Ritual" FAB (Floating Action Button)
- Taps FAB

#### 2. Multi-Step Form Opens

**Step 1: Basic Information**
- Ritual name/purpose
- Occasion (Birthday, Wedding, Housewarming, etc.)
- Number of participants
- Preferred language
- Special requirements (textarea)

**Step 2: Ritual Preferences**
- Deity selection (multiple choice)
- Ritual type:
  - Puja
  - Havan
  - Abhishek
  - Custom combination
- Specific mantras/prayers
- Duration preference

**Step 3: Timing**
- Preferred date (calendar picker)
- Preferred time slot
- Flexibility options:
  - Exact date required
  - Flexible within week
  - Flexible within month
- Muhurat consultation needed? (Yes/No)

**Step 4: Aashirwad Box Customization**
- Standard items (pre-selected)
- Additional items:
  - Sacred threads
  - Rudraksha
  - Gemstones
  - Special prasad
  - Custom items (text input)
- Delivery preferences

**Step 5: Package Selection**
- Basic (₹2001-5000)
- Premium (₹5001-10000)
- Luxury (₹10001+)
- Custom budget (input field)

**Step 6: Review**
- Summary of all selections
- Edit buttons for each section
- Terms & conditions checkbox
- Submit button

#### 3. Submission
**User taps "Submit Request":**
- Loading indicator
- Success modal appears:
  - ✅ "Request Submitted Successfully"
  - "We'll contact you within 24 hours"
  - Inquiry reference number
  - "Track Status" button

#### 4. Dashboard Update
**Inquiry appears in user's dashboard:**
- Status: "Pending Review"
- Reference number
- Submitted date
- View details option

#### 5. Admin Review & Response
**Backend process:**
- Admin reviews request
- Creates custom proposal
- Sets pricing
- Adds recommendations

**User receives notification:**
- Push notification: "Your custom ritual proposal is ready"
- Email with proposal details
- SMS alert

#### 6. Proposal Review
**User opens notification:**
- Views detailed proposal:
  - Ritual plan
  - Timeline
  - Pricing breakdown
  - What's included
  - Terms
  
**User actions:**
- Accept proposal
- Request modifications
- Decline

#### 7. Confirmation & Payment
**If user accepts:**
- Proceeds to payment screen
- Reviews final details
- Completes payment
- Receives booking confirmation

**Status updates:**
- Dashboard shows: "Confirmed"
- Countdown to ritual date
- Contact details for coordination

---

## Flow 3: Offering Chadhava

### Journey Map
```
Chadhava Tab → Browse → Detail → Customize → Payment → Confirmation → Video Delivery
```

### Detailed Steps

#### 1. Entry Point
**User taps Chadhava tab:**
- Bottom navigation "Chadavas" icon
- Opens Chadhava screen

#### 2. Browse Offerings
**Chadhava screen displays:**
- Header: "Offer Chadhava"
- Search bar
- Category filter (horizontal scroll):
  - All
  - Daily Deity
  - Ekadashi
  - Gauseva
  - Success & Growth
  - Health & Healing

**Featured banner:**
- Multi-temple package
- "Panch Devi-Devta 5 Temple Chadhava"
- Special occasion highlight

**Grid of offerings:**
- Deity image
- Deity name
- Service type
- Starting price
- "OFFER" button

#### 3. View Chadhava Details
**User taps chadhava card:**
- Detail page opens showing:

**Header:**
- Deity image
- Chadhava name
- Temple location
- Special occasion badge (if applicable)

**Information sections:**
- About this chadhava
- Significance
- Included offerings (chips with checkmarks)
- Next available date

**Offering type selector:**
- Visual grid (4 columns)
- Icons: 🌸 Flowers, 🍯 Honey, 🕯️ Diya, 🥥 Coconut
- Each shows:
  - Icon
  - Name
  - Price or "Included"
  - Selection indicator

#### 4. Customization
**User customizes offering:**

**Select offerings:**
- Taps items to add/remove
- Default items pre-selected
- Additional items show price
- Running total updates

**Set quantity:**
- Uses +/- buttons
- Minimum: 1
- Price multiplies accordingly

**Add personal message:**
- Optional textarea (200 char limit)
- Placeholder: "Add your prayer or wish..."
- Message will be offered with chadhava

#### 5. Package Selection (Multi-Temple)
**If multi-temple package:**
- Shows temple checklist
- Each temple card displays:
  - Temple name
  - Deity
  - Individual price
  - Selection checkbox
- Can select/deselect temples
- Total price updates dynamically

#### 6. Confirmation
**User taps "BOOK NOW":**
- Reviews summary:
  - Selected offerings
  - Quantity
  - Personal message
  - Total amount
  - Video delivery timeline

**Proceeds to payment:**
- Payment screen
- Completes transaction

#### 7. Success & Confirmation
**Success screen shows:**
- ✅ "Your offering will be made on [date]"
- Booking reference
- Expected video delivery: 24-48 hours
- "Track Status" button

**Notifications:**
- Email confirmation
- SMS with reference
- Push notification

#### 8. Video Delivery
**Within 24-48 hours:**
- Video recorded at temple
- Uploaded to user's account
- Push notification: "Your chadhava video is ready"

**User accesses video:**
- Opens notification
- Views video in app
- Can download
- Can share
- Receives prasad delivery (if applicable)

---

## Flow 4: Exploring Temple-Specific Service

### Journey Map
```
Temple Tab → Browse → Temple Detail → Explore Services → Select Service → Booking
```

### Detailed Steps

#### 1. Entry Point
**User taps Temple tab:**
- Bottom navigation "Temples" icon
- Opens Temples screen

#### 2. Browse Temples
**Temples screen displays:**
- Header: "Sacred Temples"
- Search bar with filter
- Featured temple spotlight (hero section)
- Category filter:
  - All Temples
  - Shaktipeeths
  - Jyotirlingas
  - Char Dham
  - Popular

**Temple grid (2 columns):**
- Temple image
- Temple name
- Location
- Rating & reviews
- "View Services" button
- Compare toggle

#### 3. View Temple Details
**User taps temple card:**
- Temple detail page opens

**Header section:**
- Image carousel (swipeable)
- Temple name (large, elegant font)
- Location with map icon
- Rating & review count
- Favorite icon (heart)
- Share button
- Presiding deity card

**Quick actions bar:**
- 🙏 Offer Chadhava
- 📹 Live Darshan
- 📜 About
- 🗺️ Visit Guide

#### 4. Explore Information
**User scrolls through:**

**Temple information:**
- History & significance (collapsible)
- Presiding deity
- Temple timings
- Festivals celebrated
- Dress code & rules

**Location section:**
- Address
- How to reach
- Nearby attractions

#### 5. Explore Services
**User taps services tabs:**

**Tab 1: Chadhava**
- Temple-specific offerings
- Traditional items
- Prices
- "Offer Now" buttons

**Tab 2: Pujas**
- Available rituals
- Each shows:
  - Puja name
  - Duration
  - Benefits
  - Next available slot
  - Package options
  - "Book Now" button

**Tab 3: Live Darshan**
- If available:
  - Live stream schedule
  - "Get Notification" toggle
- If not available:
  - "Coming Soon" message
  - "Request Feature" option

**Tab 4: Aartis**
- Morning/afternoon/evening times
- Sponsor option
- Prices
- "SPONSOR" buttons
- Video gallery of past aartis

#### 6. Select Service
**User taps specific service:**
- Chadhava → Opens chadhava detail (Flow 3)
- Puja → Opens puja booking flow (Flow 1)
- Aarti → Opens sponsorship flow

#### 7. Standard Booking Flow
**Follows respective flow:**
- Chadhava: Flow 3 steps
- Puja: Flow 1 steps
- Maintains temple context throughout

#### 8. Return to Temple
**After booking or browsing:**
- Back button returns to temple detail
- Can explore more services
- Can compare with other temples
- Can add to favorites

---

## Cross-Flow Features

### Authentication Check
**Triggered at booking/payment:**
- Checks if user is logged in
- If not:
  - Shows login/signup modal
  - Saves booking context
  - After auth, returns to booking
- If yes:
  - Proceeds directly

### Payment Integration
**Common across all flows:**
- Booking summary
- Payment options
- Secure transaction
- Confirmation
- Receipt generation

### Notifications
**Sent at key points:**
- Booking confirmation
- Ritual/service updates
- Video/photo ready
- Prasad delivery
- Review requests

### My Rituals Dashboard
**Accessible from:**
- Bottom navigation
- Profile menu
- Post-booking success screen

**Shows:**
- Upcoming rituals
- Past rituals
- Custom requests
- Chadhava offerings
- Temple services
- Status tracking

---

## Navigation Patterns

### Bottom Navigation (Always Accessible)
1. **Temples** - Temple exploration
2. **Rituals** - Public rituals
3. **Home** - Main dashboard (center, elevated)
4. **Chadavas** - Offerings
5. **Personal** - Custom rituals

### Back Navigation
- Hardware back button
- App bar back arrow
- Gesture navigation
- Maintains context

### Deep Linking
- Notifications → Specific screens
- Emails → Direct booking
- SMS → Status tracking
- Share links → Ritual details

---

## Error Handling

### Network Issues
- Offline banner appears
- Cached content shown
- Queue for later sync
- Retry options

### Payment Failures
- Clear error message
- Retry payment option
- Alternative payment methods
- Support contact

### Booking Conflicts
- Date/time unavailable
- Alternative suggestions
- Notification to user
- Rebooking option

---

## Success Metrics

### Flow Completion Rates
- Track each step
- Identify drop-off points
- Optimize bottlenecks

### User Satisfaction
- Post-booking surveys
- Rating prompts
- Feedback collection
- Review requests

### Engagement
- Return visits
- Multiple bookings
- Feature usage
- Time spent

---

## Summary

### Flow 1: Public Ritual Booking
**Steps**: 9 | **Avg Time**: 3-5 minutes | **Complexity**: Medium

### Flow 2: Custom Ritual Creation
**Steps**: 8 | **Avg Time**: 5-10 minutes | **Complexity**: High

### Flow 3: Chadhava Offering
**Steps**: 8 | **Avg Time**: 2-4 minutes | **Complexity**: Low

### Flow 4: Temple Service Exploration
**Steps**: 8 | **Avg Time**: 4-6 minutes | **Complexity**: Medium

---

**All flows are designed to be intuitive, efficient, and provide clear feedback at each step, ensuring a smooth user experience throughout the Mandir Mitra application.**

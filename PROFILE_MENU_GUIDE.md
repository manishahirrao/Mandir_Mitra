# Profile Menu Navigation Guide

## Quick Reference

### How to Access
1. Tap the **profile icon** in the top-left corner of the app bar
2. The drawer menu will slide open from the left

## Menu Items & Destinations

| Menu Item | Icon | Destination | Description |
|-----------|------|-------------|-------------|
| **My Profile** | 👤 | ProfileScreen | View and edit your profile information |
| **My Rituals** | 📅 | MyRitualsScreen | View your booked rituals and history |
| **Wishlist** | ❤️ | WishlistScreen | Manage your saved rituals |
| **Loyalty & Rewards** | 🎁 | LoyaltyScreen | View points, tier, and redeem rewards |
| **Settings** | ⚙️ | SettingsScreen | Configure app preferences |
| **Help & Support** | ❓ | HelpSupportScreen | Get help and contact support |
| **About** | ℹ️ | AboutScreen | Learn about Mandir Mitra |
| **Logout** | 🚪 | Confirmation Dialog | Sign out of your account |

## Detailed Features

### 1. My Profile
- Personal information
- Contact details
- Profile picture
- Account settings

### 2. My Rituals
- Upcoming rituals
- Past rituals
- Ritual history
- Booking details
- Track rituals

### 3. Wishlist
**Features:**
- Grid/List view toggle
- Sort options:
  - Recently Added
  - Price: Low to High
  - Price: High to Low
  - Name (A-Z)
- Search functionality
- Select mode for bulk actions
- Share wishlist
- Remove items
- Swipe to delete

**Actions:**
- Add/Remove from wishlist
- Share selected items
- Clear entire wishlist
- Navigate to ritual details

### 4. Loyalty & Rewards
**Features:**
- Points balance display
- Tier status (Bronze/Silver/Gold/Platinum)
- Progress to next tier
- Points history

**Ways to Earn:**
- Book a ritual: +50 points
- Complete first ritual: +100 bonus
- Write a review: +20 points
- Upload photos: +10 points
- Refer a friend: +200 points
- Share on social: +5 points
- Daily app open: +2 points
- Complete profile: +50 points

**Redeem Options:**
- Discount coupons
- Free rituals
- Premium features
- Special offers

**Quick Actions:**
- Refer & Earn
- Achievements
- Points History

### 5. Settings
**Categories:**
- Account Settings
  - Edit profile
  - Change password
  - Privacy settings
  
- Notifications
  - Push notifications
  - Email notifications
  - SMS alerts
  
- Preferences
  - Language selection
  - Theme (Light mode)
  - Default location
  
- Privacy & Security
  - Data management
  - Account privacy
  - Security settings

### 6. Help & Support (NEW)
**Quick Actions:**
- FAQs - Find quick answers
- Live Chat - Chat with support (Coming Soon)

**Contact Options:**
- 📞 Call Us: +91 1800-123-4567
- 📧 Email: support@mandirmitra.com
- 🕐 Support Hours: 24/7 Available

**Popular Questions:**
- How do I book a ritual?
- Can I track my ritual?
- What payment methods are accepted?
- How do I get my Aashirwad Box?

**Support Resources:**
- 📖 User Guide
- 🎥 Video Tutorials
- 💬 Send Feedback
- 🐛 Report an Issue

### 7. About
**Sections:**
- Our Story
- Our Values
  - Authenticity
  - Trust
  - Tradition
  - Innovation
- Our Team
- Temple Partnerships
- Our Commitment
- Contact CTA

### 8. Logout
- Shows confirmation dialog
- Requires user confirmation
- Clears session data
- Returns to login screen

## Navigation Patterns

### Standard Navigation
```
Profile Icon → Drawer → Menu Item → Screen
                ↓
            Close Drawer
                ↓
            Navigate to Screen
```

### With Sub-Navigation
```
Profile Icon → Drawer → Help & Support → HelpSupportScreen
                                            ↓
                                        FAQs Button
                                            ↓
                                        FAQScreen
```

### Back Navigation
- All screens have back button in app bar
- Android back button works correctly
- Drawer closes when navigating

## Visual Hierarchy

```
┌─────────────────────────────────┐
│  Profile Drawer                 │
├─────────────────────────────────┤
│  [Profile Header]               │
│  👤 Guest User                  │
│  guest@mandirmitra.com          │
├─────────────────────────────────┤
│  👤 My Profile                  │
│  📅 My Rituals                  │
│  ❤️ Wishlist                    │
│  🎁 Loyalty & Rewards           │
├─────────────────────────────────┤
│  ⚙️ Settings                    │
│  ❓ Help & Support              │
│  ℹ️ About                       │
├─────────────────────────────────┤
│  🚪 Logout                      │
└─────────────────────────────────┘
```

## Implementation Details

### Files Involved
- `main_navigation.dart` - Main drawer implementation
- `navigation_helper.dart` - Navigation methods
- Individual screen files for each destination

### State Management
- Uses Provider for state management
- Drawer closes automatically on navigation
- Maintains navigation stack properly

### Error Handling
- All navigation methods are null-safe
- Proper error handling for failed navigation
- Fallback screens for missing data

## Testing Guide

### Manual Testing Steps
1. ✅ Open app and tap profile icon
2. ✅ Verify drawer opens smoothly
3. ✅ Tap each menu item
4. ✅ Verify correct screen opens
5. ✅ Test back navigation
6. ✅ Verify drawer closes on navigation
7. ✅ Test logout confirmation
8. ✅ Test all sub-navigations

### Expected Behavior
- Drawer opens with smooth animation
- Menu items respond to taps immediately
- Drawer closes when navigating
- Back button returns to previous screen
- No crashes or errors
- Smooth transitions between screens

## Troubleshooting

### Common Issues
1. **Drawer doesn't open**
   - Check if profile icon is tappable
   - Verify Scaffold has drawer property

2. **Navigation doesn't work**
   - Check NavigationHelper methods
   - Verify screen imports
   - Check route definitions

3. **Back button doesn't work**
   - Verify AppBar has back button
   - Check navigation stack

### Debug Tips
- Use Flutter DevTools to inspect navigation
- Check console for navigation errors
- Verify all screens are properly imported

---

**Status**: ✅ All Navigation Working
**Last Updated**: November 16, 2025

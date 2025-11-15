# Design System Migration Status

## Current Status: PARTIALLY IMPLEMENTED

### ✅ What's Complete
1. **Design System Core** - Fully implemented in `lib/utils/app_theme.dart`
2. **Global Theme** - Applied in `lib/main.dart` (Material theme uses our colors)
3. **Documentation** - Complete guides available
4. **Testing** - Build successful, no errors
5. **Dependencies** - Google Fonts installed

### ⚠️ What's Pending
**Direct usage of AppTheme constants in individual files**

Most files are currently:
- Using Material theme colors indirectly
- Using hardcoded values for spacing
- Using custom TextStyles instead of AppTheme typography
- Not using helper methods

---

## Migration Needed

### Priority 1: Core UI Files (High Impact)

#### 1. Home Screen (`lib/screens/home_screen.dart`)
**Current**: Basic implementation
**Needs**:
```dart
// Add import
import '../utils/app_theme.dart';

// Replace hardcoded values
Container(
  color: AppTheme.templeCream,  // Instead of Colors.grey[50]
  padding: EdgeInsets.all(AppTheme.cardPadding),  // Instead of 16
)

// Use typography
Text('Title', style: AppTheme.h1)  // Instead of custom TextStyle
```

#### 2. Services Screen (`lib/screens/services_screen.dart`)
**Current**: Uses some theme colors
**Needs**:
- Import AppTheme
- Use AppTheme.bodyBase for text
- Use AppTheme.spaceStandard for spacing
- Use AppTheme.cardDecoration() for cards

#### 3. Ritual Cards (`lib/widgets/services/ritual_card.dart`)
**Current**: Custom styling
**Needs**:
```dart
Container(
  decoration: AppTheme.cardDecoration(),
  child: Column(
    children: [
      Text('Title', style: AppTheme.h3),
      SizedBox(height: AppTheme.spaceStandard),
      Text('Price', style: AppTheme.priceText),
    ],
  ),
)
```

#### 4. Navigation (`lib/screens/main_navigation.dart`)
**Current**: Uses some colors
**Needs**:
- Use AppTheme.divineGold for active tab
- Use AppTheme.sacredGrey for inactive tabs
- Use AppTheme typography for labels

---

### Priority 2: Feature Screens (Medium Impact)

#### Temple Screen
**Status**: ✅ Already uses AppTheme (newly created)
**Action**: None needed

#### Chadhava Screen  
**Status**: ✅ Already uses AppTheme (newly created)
**Action**: None needed

#### Profile Screen
**Needs**: Typography and spacing migration

#### My Rituals Screen
**Needs**: Card styling and typography

#### Booking Screen
**Needs**: Form styling and button gradients

---

### Priority 3: Components (Lower Impact)

#### Form Inputs
**Needs**: Use AppTheme input decoration theme

#### Buttons
**Needs**: Use AppTheme.gradientButtonDecoration()

#### Status Badges
**Needs**: Use AppTheme.statusBadgeDecoration()

#### Cards
**Needs**: Use AppTheme.cardDecoration()

---

## How to Migrate (Step by Step)

### Step 1: Add Import
```dart
import '../utils/app_theme.dart';
```

### Step 2: Replace Colors
```dart
// Before
Container(color: Color(0xFFFAF9F6))

// After
Container(color: AppTheme.templeCream)
```

### Step 3: Replace Spacing
```dart
// Before
EdgeInsets.all(16)
SizedBox(height: 24)

// After
EdgeInsets.all(AppTheme.cardPadding)
SizedBox(height: AppTheme.spaceLoose)
```

### Step 4: Replace Typography
```dart
// Before
Text(
  'Title',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)

// After
Text('Title', style: AppTheme.h2)
```

### Step 5: Use Helper Methods
```dart
// Before
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(...)],
  ),
)

// After
Container(
  decoration: AppTheme.cardDecoration(),
)
```

---

## Migration Checklist

### Core Files
- [ ] `lib/screens/home_screen.dart`
- [ ] `lib/screens/services_screen.dart`
- [ ] `lib/screens/main_navigation.dart`
- [ ] `lib/widgets/services/ritual_card.dart`
- [ ] `lib/widgets/home/featured_rituals_carousel.dart`
- [ ] `lib/widgets/home/categories_grid.dart`

### Feature Screens
- [x] `lib/screens/temples_screen.dart` (New, already uses AppTheme)
- [x] `lib/screens/chadhava_screen.dart` (New, already uses AppTheme)
- [ ] `lib/screens/profile_screen.dart`
- [ ] `lib/screens/my_rituals_screen.dart`
- [ ] `lib/screens/booking_screen.dart`
- [ ] `lib/screens/ritual_detail_screen.dart`

### Components
- [ ] `lib/widgets/common/empty_state.dart`
- [ ] `lib/widgets/common/loading_skeleton.dart`
- [ ] `lib/widgets/custom_app_bar.dart`
- [ ] Form inputs across all screens
- [ ] Button styles across all screens

---

## Benefits of Migration

### Before Migration
```dart
// Inconsistent
Container(color: Color(0xFFFFFFFF))
Container(color: Colors.white)
Container(color: Color(0xFFFAF9F6))

// Hard to maintain
Text(style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
Text(style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600))

// Magic numbers
EdgeInsets.all(16)
EdgeInsets.all(20)
SizedBox(height: 24)
```

### After Migration
```dart
// Consistent
Container(color: AppTheme.sacredWhite)
Container(color: AppTheme.templeCream)

// Easy to maintain
Text(style: AppTheme.h1)
Text(style: AppTheme.h2)

// Semantic constants
EdgeInsets.all(AppTheme.cardPadding)
SizedBox(height: AppTheme.spaceLoose)
```

---

## Recommendation

### Option 1: Gradual Migration (Recommended)
✅ **Pros**: 
- Less risky
- Can test incrementally
- Doesn't break existing functionality

📋 **Approach**:
1. Migrate new features first (already done for Temple & Chadhava)
2. Migrate high-traffic screens (Home, Services)
3. Migrate remaining screens gradually
4. Update components last

### Option 2: Complete Migration
⚠️ **Pros**:
- Immediate consistency
- All files use design system

⚠️ **Cons**:
- More time-consuming
- Higher risk of breaking changes
- Requires extensive testing

---

## Next Steps

### Immediate (Recommended)
1. ✅ Design system is ready
2. ✅ Documentation is complete
3. ⏭️ **Start using in new features** (already doing this)
4. ⏭️ **Gradually migrate existing files**

### For New Development
✅ **Always use AppTheme** in new files:
```dart
import '../utils/app_theme.dart';

// Use design system from the start
Container(
  decoration: AppTheme.cardDecoration(),
  padding: EdgeInsets.all(AppTheme.cardPadding),
  child: Text('Title', style: AppTheme.h2),
)
```

---

## Summary

### Current State
- ✅ Design system: **COMPLETE**
- ✅ Global theme: **APPLIED**
- ⚠️ File migration: **IN PROGRESS**
- ✅ New files: **USING DESIGN SYSTEM**

### What This Means
1. **Design system is ready** - You can start using it immediately
2. **New features use it** - Temple & Chadhava screens already implemented with design system
3. **Old files need migration** - Existing files should be gradually updated
4. **App still works** - No breaking changes, everything compiles

### Action Required
**For new development**: ✅ Use AppTheme (already doing this)
**For existing files**: ⏭️ Migrate gradually when updating features

---

**Status**: Design system is **READY and OPERATIONAL**. Migration to existing files is **OPTIONAL but RECOMMENDED** for consistency.

Would you like me to migrate specific files now? I can start with the high-priority ones (Home, Services, Navigation).

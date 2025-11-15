# Design System Quick Reference

Quick reference guide for common design system usage in Mandir Mitra app.

---

## 🎨 Colors

### Most Used Colors
```dart
// Backgrounds
AppTheme.templeCream        // Screen background
AppTheme.sacredWhite        // Card background

// Brand Colors
AppTheme.primaryBlue        // Primary actions
AppTheme.divineGold         // Secondary actions

// Status
AppTheme.successGreen       // Success
AppTheme.errorRed           // Error
AppTheme.warningAmber       // Warning

// Text
AppTheme.textPrimary        // Main text
AppTheme.textSecondary      // Secondary text
```

---

## 📝 Typography

### Common Text Styles
```dart
Text('Page Title', style: AppTheme.h1)
Text('Section Title', style: AppTheme.h2)
Text('Card Title', style: AppTheme.h3)
Text('Body text', style: AppTheme.bodyBase)
Text('Small text', style: AppTheme.bodySmall)
Text('Caption', style: AppTheme.caption)
Text('₹999', style: AppTheme.priceText)
```

### Button Text
```dart
Text('BOOK NOW', style: AppTheme.buttonText)
```

---

## 📏 Spacing

### Quick Spacing
```dart
SizedBox(height: AppTheme.spaceTight)      // 8px
SizedBox(height: AppTheme.spaceStandard)   // 16px
SizedBox(height: AppTheme.spaceLoose)      // 24px
SizedBox(height: AppTheme.sectionSpacing)  // 32px

// Padding
EdgeInsets.all(AppTheme.cardPadding)       // 16px
```

---

## 🔲 Border Radius

```dart
BorderRadius.circular(AppTheme.radiusSM)   // 8px - Buttons
BorderRadius.circular(AppTheme.radiusMD)   // 12px - Cards
BorderRadius.circular(AppTheme.radiusLG)   // 16px - Large cards
```

---

## 🎭 Shadows

```dart
// Card
boxShadow: AppTheme.cardShadow

// Elevated
boxShadow: AppTheme.elevatedShadow

// Hover
boxShadow: AppTheme.hoverShadow

// Gold CTA
boxShadow: AppTheme.divineGoldShadow
```

---

## 🌈 Gradients

```dart
// Primary CTA
decoration: BoxDecoration(
  gradient: AppTheme.divineGoldGradient,
)

// Blue gradient
decoration: BoxDecoration(
  gradient: AppTheme.sacredGradient,
)
```

---

## 🎬 Animations

```dart
// Animated Container
AnimatedContainer(
  duration: AppTheme.normalAnimation,
  curve: AppTheme.easeOut,
  // ...
)

// Button Press
duration: AppTheme.buttonPressDuration  // 150ms

// Card Hover
duration: AppTheme.cardHoverDuration    // 250ms
```

---

## 🛠️ Helper Methods

### Card
```dart
Container(
  decoration: AppTheme.cardDecoration(),
  padding: EdgeInsets.all(AppTheme.cardPadding),
  child: // content
)
```

### Gradient Button
```dart
Container(
  decoration: AppTheme.gradientButtonDecoration(),
  child: // button content
)
```

### Status Badge
```dart
Container(
  decoration: AppTheme.statusBadgeDecoration('completed'),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  child: Text(
    'Completed',
    style: AppTheme.caption.copyWith(
      color: AppTheme.getStatusColor('completed'),
    ),
  ),
)
```

### Responsive Padding
```dart
Padding(
  padding: AppTheme.getResponsivePadding(context),
  child: // content
)
```

---

## 📱 Common Patterns

### Standard Card
```dart
Container(
  decoration: AppTheme.cardDecoration(),
  padding: EdgeInsets.all(AppTheme.cardPadding),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Title', style: AppTheme.h3),
      SizedBox(height: AppTheme.spaceStandard),
      Text('Content', style: AppTheme.bodyBase),
    ],
  ),
)
```

### Primary Button
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryBlue,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  ),
  child: Text('BUTTON', style: AppTheme.buttonText),
)
```

### Gradient CTA Button
```dart
Container(
  decoration: AppTheme.gradientButtonDecoration(),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Center(
          child: Text(
            'BOOK NOW',
            style: AppTheme.buttonText.copyWith(color: Colors.white),
          ),
        ),
      ),
    ),
  ),
)
```

### Input Field
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Enter text',
    filled: true,
    fillColor: AppTheme.sacredWhite,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
    ),
  ),
)
```

### Section Header
```dart
Padding(
  padding: EdgeInsets.all(AppTheme.spaceStandard),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Section Title', style: AppTheme.h2),
      SizedBox(height: AppTheme.spaceTight),
      Text('Description', style: AppTheme.bodySmall),
    ],
  ),
)
```

### Price Display
```dart
Row(
  children: [
    Text('₹', style: AppTheme.priceText),
    Text('999', style: AppTheme.priceLarge),
  ],
)
```

### Status Chip
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: AppTheme.statusBadgeDecoration('pending'),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.schedule,
        size: 14,
        color: AppTheme.getStatusColor('pending'),
      ),
      SizedBox(width: 4),
      Text(
        'Pending',
        style: AppTheme.caption.copyWith(
          color: AppTheme.getStatusColor('pending'),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
)
```

---

## 🎯 Status Values

Use these string values with status helpers:
- `'completed'` - Green
- `'pending'` - Amber
- `'upcoming'` - Amber
- `'cancelled'` - Red
- `'live'` - Red (pulsing)

---

## 📐 Grid Layouts

### 2-Column Grid (Mobile)
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: AppTheme.spaceStandard,
    mainAxisSpacing: AppTheme.spaceStandard,
  ),
  // ...
)
```

### Responsive Grid
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: MediaQuery.of(context).size.width > 720 ? 4 : 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: AppTheme.spaceStandard,
    mainAxisSpacing: AppTheme.spaceStandard,
  ),
  // ...
)
```

---

## 🔍 Search Bar
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search...',
    prefixIcon: Icon(Icons.search),
    filled: true,
    fillColor: AppTheme.sacredWhite,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      borderSide: BorderSide(color: AppTheme.borderGrey),
    ),
  ),
)
```

---

## 💡 Tips

1. **Always use theme constants** instead of hardcoded values
2. **Use responsive helpers** for adaptive layouts
3. **Apply consistent spacing** using the spacing system
4. **Use semantic colors** for better maintainability
5. **Add animations** for better UX
6. **Test on multiple screen sizes**

---

**Quick Access**: Import with `import '../utils/app_theme.dart';`

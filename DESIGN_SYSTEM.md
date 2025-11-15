# Mandir Mitra Design System

## Overview
This document outlines the complete design system for the Mandir Mitra app, including color usage, typography, spacing, animations, and implementation guidelines.

---

## 🎨 Color System

### Primary Colors
```dart
AppTheme.primaryBlue      // #004C99 - Main brand color
AppTheme.sacredBlue       // #004C99 - Alias for primaryBlue
AppTheme.divineGold       // #D4AF37 - Secondary brand color
AppTheme.goldenAccent     // #D4AF37 - Alias for divineGold
```

### Background Colors
```dart
AppTheme.templeCream      // #FAF9F6 - Primary screen background
AppTheme.sacredWhite      // #FFFFFF - Card backgrounds
AppTheme.cardBackground   // #FFFFFF - Card surfaces
```

### Accent Colors
```dart
AppTheme.holyRed          // #D32F2F - Important notifications
AppTheme.saffronYellow    // #FF9933 - Spiritual accent
AppTheme.templeBrown      // #5D4037 - Earth tones
AppTheme.earthTones       // #6B5A3E - Natural elements
AppTheme.gangajalBlue     // #00A3E0 - Water elements
```

### Semantic Colors
```dart
AppTheme.errorRed         // #D32F2F - Errors
AppTheme.successGreen     // #2E7D32 - Success states
AppTheme.warningAmber     // #F57C00 - Warnings
```

### Neutral Colors
```dart
AppTheme.sacredGrey       // #333333 - Dark text
AppTheme.textPrimary      // #212121 - Primary text
AppTheme.textSecondary    // #757575 - Secondary text
AppTheme.borderGrey       // #E0E0E0 - Borders
AppTheme.dividerGrey      // #BDBDBD - Dividers
```

---

## 🌈 Color Usage Strategy

### Primary Screens (Home, Browse)
- **Background**: `AppTheme.templeCream` (#FAF9F6)
- **Cards**: `AppTheme.sacredWhite` with subtle shadows
- **Primary CTAs**: `AppTheme.divineGoldGradient`
- **Secondary buttons**: `AppTheme.primaryBlue`
- **Accent elements**: `AppTheme.holyRed` for important notifications

### Ritual/Puja Cards
- **Background**: White
- **Border**: 1px solid cream
- **Hover**: Lift effect with divine gold shadow
- **Active/Selected**: Divine gold border

### Form Elements
- **Input fields**: White background, grey border
- **Focus state**: Primary blue border with glow
- **Error state**: Error red with light background
- **Success state**: Success green with light background

### Navigation
- **Bottom tabs background**: White
- **Active tab**: Divine gold icon + text
- **Inactive tabs**: Sacred grey

### Status Indicators
- **Completed**: `AppTheme.successGreen`
- **Pending/Upcoming**: `AppTheme.warningAmber`
- **Cancelled**: `AppTheme.errorRed`
- **Live Now**: Pulsing `AppTheme.holyRed` dot

---

## 📐 Typography System

### Font Families
- **Headings**: Playfair Display (serif, elegant)
- **Subheadings**: Montserrat (sans-serif, modern)
- **Body Text**: Inter (sans-serif, readable)
- **Sacred Text**: Noto Sans Devanagari (for mantras)

### Heading Styles

#### H1 - Page Titles
```dart
AppTheme.h1              // Mobile: 32px, Bold
AppTheme.h1Desktop       // Desktop: 48px, Bold
```
**Usage**: Main page titles, hero sections

#### H2 - Section Titles
```dart
AppTheme.h2              // Mobile: 24px, Semibold
AppTheme.h2Desktop       // Desktop: 36px, Semibold
```
**Usage**: Major section headings

#### H3 - Subsection Titles
```dart
AppTheme.h3              // Mobile: 20px, Semibold
AppTheme.h3Desktop       // Desktop: 28px, Semibold
```
**Usage**: Card titles, subsection headings

#### H4 - Component Titles
```dart
AppTheme.h4              // Mobile: 18px, Medium
AppTheme.h4Desktop       // Desktop: 24px, Medium
```
**Usage**: Component headings, list titles

### Body Text Styles

```dart
AppTheme.bodyLarge       // 18px, Regular - Emphasized content
AppTheme.bodyBase        // 16px, Regular - Standard body text
AppTheme.bodySmall       // 14px, Regular - Secondary content
AppTheme.caption         // 12px, Regular - Captions, labels
```

### Special Text Styles

```dart
AppTheme.buttonText      // 14px, Semibold, Uppercase, 0.05em spacing
AppTheme.priceText       // 18px, Bold - Standard prices
AppTheme.priceLarge      // 20px, Bold - Featured prices
AppTheme.sacredText      // 16px, Noto Sans Devanagari
AppTheme.mantraText      // 18px, Noto Sans Devanagari, Sacred Blue
```

### Responsive Typography

```dart
// Use responsive helpers for adaptive text sizes
AppTheme.getResponsiveH1(context)
AppTheme.getResponsiveH2(context)
```

---

## 📏 Spacing System

### Standard Spacing
```dart
AppTheme.spaceTight      // 8px - Tight spacing
AppTheme.spaceStandard   // 16px - Standard element gap
AppTheme.spaceLoose      // 24px - Loose spacing
AppTheme.sectionSpacing  // 32px - Section vertical spacing
AppTheme.cardPadding     // 16px - Card internal padding
```

### Legacy Spacing (for compatibility)
```dart
AppTheme.spaceXS         // 4px
AppTheme.spaceSM         // 8px
AppTheme.spaceMD         // 16px
AppTheme.spaceLG         // 24px
AppTheme.spaceXL         // 32px
AppTheme.spaceXXL        // 48px
```

### Component Spacing Guidelines
- **Card padding**: 16px
- **Section spacing**: 32px vertical
- **Element gap**: 16px standard, 8px tight, 24px loose
- **Screen padding**: Use `AppTheme.getResponsivePadding(context)`

---

## 🔲 Border Radius

```dart
AppTheme.radiusXS        // 4px - Small elements
AppTheme.radiusSM        // 8px - Buttons, inputs
AppTheme.radiusMD        // 12px - Cards (standard)
AppTheme.radiusLG        // 16px - Large cards
AppTheme.radiusXL        // 20px - Hero sections
AppTheme.radiusFull      // 999px - Circular elements
```

---

## 📱 Responsive Layout

### Container Widths
```dart
AppTheme.mobileMaxWidth   // 100% with 16px padding
AppTheme.tabletMaxWidth   // 720px
AppTheme.desktopMaxWidth  // 1200px
```

### Grid System
- **Mobile**: 2 columns (cards)
- **Tablet**: 3-4 columns
- **Desktop**: 4-6 columns

### Breakpoints
- **Mobile**: < 720px
- **Tablet**: 720px - 1200px
- **Desktop**: > 1200px

---

## 🎭 Shadows

### Card Shadow (Subtle)
```dart
AppTheme.cardShadow
// Black 8% opacity, 8px blur, 2px offset
```

### Elevated Shadow (Medium)
```dart
AppTheme.elevatedShadow
// Black 12% opacity, 12px blur, 4px offset
```

### Divine Gold Shadow (CTAs)
```dart
AppTheme.divineGoldShadow
// Gold 30% opacity, 12px blur, 4px offset
```

### Hover Shadow (Lift effect)
```dart
AppTheme.hoverShadow
// Black 15% opacity, 16px blur, 6px offset
```

---

## 🎬 Animation Guidelines

### Durations
```dart
AppTheme.buttonPressDuration    // 150ms - Button press
AppTheme.cardHoverDuration      // 250ms - Card hover
AppTheme.pageTransitionDuration // 300ms - Page transitions
AppTheme.modalOpenDuration      // 250ms - Modal open
```

### Standard Durations
```dart
AppTheme.fastAnimation          // 150ms
AppTheme.normalAnimation        // 250ms
AppTheme.slowAnimation          // 300ms
```

### Curves
```dart
AppTheme.easeOut                // Curves.easeOut
AppTheme.easeInOut              // Curves.easeInOut
AppTheme.easeIn                 // Curves.easeIn
```

### Micro-interactions
- **Button press**: Scale 0.98, 150ms
- **Card hover**: Lift 4px, 250ms ease-out
- **Page transitions**: Slide 300ms ease-in-out
- **Modal open**: Fade + scale from 0.95 to 1, 250ms
- **Loading states**: Pulsing glow effect
- **Success feedback**: Checkmark scale animation

### Scroll Behaviors
- **Horizontal carousels**: Smooth scroll with snap points
- **Infinite scroll**: Load more trigger at 80% scroll
- **Pull to refresh**: Custom loader with spiritual icon

---

## 🎨 Gradients

### Divine Gold Gradient (Primary CTAs)
```dart
AppTheme.divineGoldGradient
// #D4AF37 → #F4D03F
```

### Sacred Blue Gradient
```dart
AppTheme.sacredGradient
// #004C99 → #0066CC
```

### Peaceful Gradient
```dart
AppTheme.peacefulGradient
// #4A90E2 → #50C9C3
```

### Saffron Gradient
```dart
AppTheme.saffronGradient
// #FF9933 → #FFB366
```

---

## 🛠️ Helper Methods

### Responsive Padding
```dart
EdgeInsets padding = AppTheme.getResponsivePadding(context);
// Returns appropriate padding based on screen width
```

### Card Decoration
```dart
BoxDecoration decoration = AppTheme.cardDecoration(
  color: Colors.white,
  shadows: AppTheme.cardShadow,
);
```

### Gradient Button Decoration
```dart
BoxDecoration decoration = AppTheme.gradientButtonDecoration(
  gradient: AppTheme.divineGoldGradient,
  radius: AppTheme.radiusMD,
);
```

### Status Badge Decoration
```dart
BoxDecoration decoration = AppTheme.statusBadgeDecoration('completed');
// Returns appropriate background color for status
```

### Status Color
```dart
Color color = AppTheme.getStatusColor('pending');
// Returns appropriate color for status
```

---

## 📋 Usage Examples

### Creating a Card
```dart
Container(
  decoration: AppTheme.cardDecoration(),
  padding: EdgeInsets.all(AppTheme.cardPadding),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Card Title', style: AppTheme.h3),
      SizedBox(height: AppTheme.spaceStandard),
      Text('Card content', style: AppTheme.bodyBase),
    ],
  ),
)
```

### Creating a Primary CTA Button
```dart
Container(
  decoration: AppTheme.gradientButtonDecoration(),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        child: Text(
          'BOOK NOW',
          style: AppTheme.buttonText.copyWith(color: Colors.white),
        ),
      ),
    ),
  ),
)
```

### Creating a Status Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: AppTheme.statusBadgeDecoration('completed'),
  child: Text(
    'Completed',
    style: AppTheme.caption.copyWith(
      color: AppTheme.getStatusColor('completed'),
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

### Animated Card Hover
```dart
AnimatedContainer(
  duration: AppTheme.cardHoverDuration,
  curve: AppTheme.easeOut,
  decoration: AppTheme.cardDecoration(
    shadows: isHovered ? AppTheme.hoverShadow : AppTheme.cardShadow,
  ),
  transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
  child: // Card content
)
```

---

## ✅ Best Practices

### Do's
✅ Use semantic color names (e.g., `AppTheme.successGreen`)
✅ Use responsive helpers for adaptive layouts
✅ Apply consistent spacing using the spacing system
✅ Use appropriate text styles for hierarchy
✅ Apply shadows for depth and elevation
✅ Use animations for micro-interactions
✅ Follow the grid system for layouts

### Don'ts
❌ Don't hardcode color values
❌ Don't use arbitrary spacing values
❌ Don't mix font families inconsistently
❌ Don't skip animation curves
❌ Don't ignore responsive breakpoints
❌ Don't use excessive shadows
❌ Don't create custom text styles without reason

---

## 🔄 Migration Guide

### Updating Existing Code

**Old:**
```dart
Container(
  color: Color(0xFFFFFFFF),
  padding: EdgeInsets.all(16),
  child: Text('Title', style: TextStyle(fontSize: 24)),
)
```

**New:**
```dart
Container(
  decoration: AppTheme.cardDecoration(),
  padding: EdgeInsets.all(AppTheme.cardPadding),
  child: Text('Title', style: AppTheme.h2),
)
```

---

## 📦 Dependencies

Required packages in `pubspec.yaml`:
```yaml
dependencies:
  google_fonts: ^6.1.0  # For typography system
```

---

## 🎯 Implementation Checklist

- [x] Color system defined
- [x] Typography system with Google Fonts
- [x] Spacing system
- [x] Border radius constants
- [x] Shadow definitions
- [x] Animation durations and curves
- [x] Gradient definitions
- [x] Status colors
- [x] Helper methods
- [x] Responsive utilities
- [x] Theme data configuration
- [x] Documentation

---

## 📚 Additional Resources

- [Material Design 3](https://m3.material.io/)
- [Flutter Theme Documentation](https://docs.flutter.dev/cookbook/design/themes)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)

---

**Last Updated**: November 2025
**Version**: 1.0.0

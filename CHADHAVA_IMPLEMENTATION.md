# Chadhava Screen Implementation

## Overview
Complete implementation of the Chadhava (Offerings) feature allowing users to offer prasad/chadhava to various deities at temples.

## Features Implemented

### 1. Main Chadhava Screen
- **Header Section**
  - Title: "Offer Chadhava"
  - Subtitle: "Present offerings to your beloved deities"
  - Search bar with real-time filtering

### 2. Category Filter
- Horizontal scrollable category chips with deity icons
- Categories:
  - All (🙏)
  - Daily Deity (🕉️)
  - Ekadashi (🌙)
  - Gauseva (🐄)
  - Success & Growth (📈)
  - Health & Healing (💚)
- Active selection with divine glow effect
- Smooth animations and transitions

### 3. Featured Banner
- Multi-Temple Chadhava special packages
- Example: "Panch Devi-Devta 5 Temple Chadhava"
- Displays:
  - Occasion (e.g., Saturday Maha Ekadashi)
  - Package name and description
  - Temple icons (5 circular deity images)
  - Temple names
  - CTA button: "BOOK 5 TEMPLE CHADHAVA"
- Gradient background with decorative elements

### 4. Chadhava Categories

#### Daily Deity Chadhava
- Grid layout (2 columns)
- Cards showing:
  - Deity image/icon
  - Deity name (e.g., Maa Kali, Shri Ganesh)
  - Service type (Daily Chadhava)
  - Starting price (From ₹51)
  - "OFFER" button

#### Special Occasion Chadhava
- Ekadashi Specials
- Purnima Offerings
- Amavasya Rituals
- Festival Chadhava
- Shows:
  - Occasion badge
  - Name & significance
  - Included offerings
  - Price
  - Next available date

#### Life Benefit Chadhava
- Success & Growth
- Health & Healing
- Relationship Harmony
- Financial Prosperity
- Education Excellence
- Protection & Safety

#### Gauseva (Cow Service)
- Special offerings for serving holy cows
- Green fodder, jaggery, grains

### 5. Chadhava Detail Screen

#### Header
- Large deity image with gradient overlay
- Special occasion badge (if applicable)
- Deity name and temple location

#### Description Section
- About the chadhava
- Significance (for special occasions)
- Occasion information with next available date

#### Included Offerings
- Visual chips showing base package items
- Green checkmarks for included items
- Examples: Flowers, Incense, Diya, Tulsi, Fruits

#### Offering Type Selector
- Visual grid (4 columns)
- Each offering shows:
  - Icon emoji (🌸 Flowers, 🍯 Honey, 🕯️ Diya, 🥥 Coconut)
  - Name
  - Price (or "Included"/"Free")
  - Selection indicator
- Default offerings pre-selected
- Additional offerings can be added

#### Quantity Selector
- +/- buttons
- Current quantity display
- Minimum quantity: 1

#### Special Message Section
- Optional textarea (200 char limit)
- Placeholder: "Add your prayer/wish to be offered with chadhava"
- Message will be offered along with the chadhava

#### Video Preview Section
- Info card showing video will be included
- Estimated delivery time (24-48 hours)
- Video icon and description

#### Bottom Bar
- Total amount calculation
- "BOOK NOW" button
- Responsive to quantity and offering selections

### 6. Multi-Temple Chadhava Screen

#### Features
- Special package for multiple temples
- Temple selection checklist
- Each temple card shows:
  - Selection checkbox
  - Temple image
  - Temple name
  - Deity name
  - Individual price
- Combined price calculation
- Single booking for all selected temples
- Separate video for each temple offering

#### Temple Selection
- Visual cards with selection state
- Can select/deselect individual temples
- Shows selected count (e.g., "3/5 selected")
- Total price updates dynamically

#### Bottom Bar
- Shows selected temple count
- Total price for selected temples
- CTA: "BOOK X TEMPLE CHADHAVA"
- Disabled if no temples selected

## Technical Implementation

### Models
**Chadhava Model** (`lib/models/chadhava.dart`)
- id, name, description, imageUrl
- basePrice, category, deityName
- includedOfferings (List<String>)
- availableOfferings (List<OfferingType>)
- isSpecialOccasion, occasion, nextAvailableDate
- significance, estimatedDuration
- videoIncluded, templeId, templeName

**OfferingType Model**
- id, name, icon, price
- isDefault (for pre-selected offerings)

**MultiTempleChadhava Model**
- id, name, description, imageUrl
- temples (List<TempleChadhava>)
- totalPrice, occasion, isSpecial

**TempleChadhava Model**
- templeId, templeName, deityName
- imageUrl, price, isSelected

### Provider
**ChadhavaProvider** (`lib/services/chadhava_provider.dart`)
- Manages chadhava data and state
- Category filtering
- Search functionality
- Mock data for testing
- Methods:
  - `loadChadhavas()` - Load all chadhava data
  - `setCategory(String)` - Filter by category
  - `getChadhavaById(String)` - Get specific chadhava
  - `getMultiTempleChadhavaById(String)` - Get multi-temple package

### Screens
1. **ChadhavaScreen** - Main listing screen
2. **ChadhavaDetailScreen** - Single chadhava details
3. **MultiTempleChadhavaScreen** - Multi-temple package details

### Widgets
1. **CategoryFilter** - Horizontal scrollable category chips
2. **FeaturedBanner** - Special package banner
3. **ChadhavaCard** - Grid item card
4. **OfferingSelector** - Visual offering selection grid

## Integration

### Navigation
- Integrated into main bottom navigation
- Tab: "Chadavas" with flower icon (🌸)
- Index: 3 in bottom nav

### Provider Registration
- Added to `main.dart` MultiProvider
- Available throughout the app

## Mock Data
Includes sample data for:
- 6 different chadhava types
- 1 multi-temple package (5 temples)
- Various offering types
- Different categories and occasions

## UI/UX Features
- Smooth animations and transitions
- Gradient backgrounds for premium feel
- Icon-based visual communication
- Clear pricing and selection states
- Responsive layouts
- Loading and error states
- Empty state handling

## Next Steps for Production
1. Replace mock data with API integration
2. Implement actual booking flow
3. Add payment integration
4. Implement video delivery system
5. Add user authentication checks
6. Implement order tracking
7. Add push notifications for video delivery
8. Implement review/rating system for completed offerings

## Files Created
- `lib/models/chadhava.dart`
- `lib/services/chadhava_provider.dart`
- `lib/screens/chadhava_screen.dart`
- `lib/screens/chadhava_detail_screen.dart`
- `lib/screens/multi_temple_chadhava_screen.dart`
- `lib/widgets/chadhava/category_filter.dart`
- `lib/widgets/chadhava/featured_banner.dart`
- `lib/widgets/chadhava/chadhava_card.dart`
- `lib/widgets/chadhava/offering_selector.dart`

## Files Modified
- `lib/screens/chadavas_screen.dart` - Updated to use new implementation
- `lib/main.dart` - Added ChadhavaProvider registration

## Testing
All files compile without errors. Ready for testing in the app.

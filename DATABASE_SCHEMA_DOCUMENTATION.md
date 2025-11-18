# Mandir Mitra - Database Schema Documentation

## Overview

This document explains the complete database schema for the Mandir Mitra application, designed to work with **Supabase** as the database and **Cloudinary** for image storage.

## Architecture

### Technology Stack
- **Database**: Supabase (PostgreSQL)
- **Image Storage**: Cloudinary
- **Authentication**: Supabase Auth
- **Real-time**: Supabase Realtime

### Design Principles
- **Row Level Security (RLS)** for data protection
- **UUID primary keys** for scalability
- **Audit trails** with timestamps
- **Performance optimized** with indexes
- **Cloudinary integration** for media management

## Core Tables

### 1. Users Table
```sql
users
├── id (UUID) - Primary Key
├── email (TEXT, UNIQUE) - User email
├── full_name (TEXT) - Display name
├── phone (TEXT) - Contact number
├── profile_cloudinary_id (TEXT) - Cloudinary public ID for avatar
├── is_verified (BOOLEAN) - Email verification status
├── is_active (BOOLEAN) - Account status
├── language (TEXT) - Preferred language (english, hindi, etc.)
├── preferred_temple (TEXT) - User's preferred temple
├── loyalty_points (INTEGER) - Current points balance
├── loyalty_tier (TEXT) - Bronze, Silver, Gold, Platinum
└── timestamps
```

**Purpose**: Stores user profiles and authentication data.

**Cloudinary Integration**: Profile images stored as Cloudinary public IDs.

### 2. Temples Table
```sql
temples
├── id (UUID) - Primary Key
├── name (TEXT) - Temple name
├── location (TEXT) - Full address
├── city (TEXT) - City name
├── state (TEXT) - State name
├── country (TEXT) - Default: India
├── description (TEXT) - Temple description
├── cloudinary_id (TEXT) - Temple image Cloudinary ID
├── deity (TEXT) - Main deity
├── timings (TEXT) - Opening/closing times
├── contact (TEXT) - Contact information
├── website (TEXT) - Official website
├── latitude (DECIMAL) - GPS coordinates
├── longitude (DECIMAL) - GPS coordinates
├── is_popular (BOOLEAN) - Featured temple
├── is_active (BOOLEAN) - Status
├── rating (DECIMAL) - Average rating
├── review_count (INTEGER) - Total reviews
└── timestamps
```

**Purpose**: Physical temple locations and information.

**Admin Managed**: Content added/updated by admin only.

### 3. Rituals Table
```sql
rituals
├── id (UUID) - Primary Key
├── name (TEXT) - Ritual name
├── description (TEXT) - Detailed description
├── category (TEXT) - Puja category
├── subcategory (TEXT) - Specific type
├── price (DECIMAL) - Base price
├── duration (INTEGER) - Duration in minutes
├── cloudinary_id (TEXT) - Ritual image Cloudinary ID
├── video_url (TEXT) - Demonstration video
├── temple_id (UUID) - Foreign key to temples
├── deity (TEXT) - Associated deity
├── benefits (TEXT) - Spiritual benefits
├── requirements (TEXT) - Prerequisites
├── what_includes (TEXT) - Included items
├── is_popular (BOOLEAN) - Popular ritual
├── is_featured (BOOLEAN) - Featured ritual
├── is_active (BOOLEAN) - Available for booking
├── rating (DECIMAL) - Average rating
├── review_count (INTEGER) - Total reviews
└── timestamps
```

**Purpose**: Available puja/ritual services.

**Relationship**: Many rituals can belong to one temple.

### 4. Orders Table
```sql
orders
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── ritual_id (UUID) - Foreign key to rituals
├── temple_id (UUID) - Foreign key to temples
├── order_number (TEXT, UNIQUE) - Auto-generated
├── status (TEXT) - pending, confirmed, completed, cancelled
├── payment_status (TEXT) - Payment state
├── payment_method (TEXT) - razorpay, etc.
├── payment_id (TEXT) - Gateway transaction ID
├── amount (DECIMAL) - Base amount
├── discount_amount (DECIMAL) - Discount applied
├── final_amount (DECIMAL) - Total payable
├── currency (TEXT) - Default: INR
├── scheduled_date (DATE) - Puja date
├── scheduled_time (TIME) - Puja time
├── duration (INTEGER) - Expected duration
├── participant_names (TEXT[]) - Names for puja
├── special_requests (TEXT) - Custom requirements
├── address (TEXT) - Delivery address
├── city (TEXT) - Delivery city
├── state (TEXT) - Delivery state
├── postal_code (TEXT) - PIN code
├── phone (TEXT) - Contact number
├── email (TEXT) - Contact email
├── video_link (TEXT) - Live stream link
├── invoice_url (TEXT) - Invoice Cloudinary ID
├── tracking_info (JSONB) - Tracking details
├── admin_notes (TEXT) - Internal notes
├── assigned_to (UUID) - Admin assignment
└── timestamps
```

**Purpose**: User orders and booking management.

**Auto-Generation**: Order numbers follow format: MMYYMM123456

### 5. Bookings Table
```sql
bookings
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── order_id (UUID) - Foreign key to orders
├── ritual_id (UUID) - Foreign key to rituals
├── temple_id (UUID) - Foreign key to temples
├── booking_date (DATE) - Scheduled date
├── booking_time (TIME) - Scheduled time
├── status (TEXT) - confirmed, rescheduled, cancelled
├── participant_names (TEXT[]) - Participant details
├── special_instructions (TEXT) - Custom instructions
├── total_amount (DECIMAL) - Total cost
├── paid_amount (DECIMAL) - Amount paid
├── balance_amount (DECIMAL) - Remaining amount
├── payment_status (TEXT) - Payment state
├── notes (TEXT) - Additional notes
└── timestamps
```

**Purpose**: Detailed booking information for scheduled pujas.

**Relationship**: Links orders with specific time slots.

## Feature Tables

### 6. Wishlist Table
```sql
wishlist
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── ritual_id (UUID) - Foreign key to rituals
└── created_at (TIMESTAMP) - When added
```

**Purpose**: User's saved rituals for later booking.

**Unique Constraint**: One entry per user-ritual combination.

### 7. Reviews Table
```sql
reviews
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── ritual_id (UUID) - Foreign key to rituals
├── order_id (UUID) - Foreign key to orders
├── rating (INTEGER) - 1-5 stars
├── title (TEXT) - Review title
├── review_text (TEXT) - Detailed review
├── images (TEXT[]) - Cloudinary public IDs
├── is_verified (BOOLEAN) - Admin verified
├── is_public (BOOLEAN) - Public visibility
├── helpful_count (INTEGER) - Helpful votes
└── timestamps
```

**Purpose**: User feedback and ratings.

**Images**: Multiple images stored as Cloudinary public IDs.

### 8. Notifications Table
```sql
notifications
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── title (TEXT) - Notification title
├── message (TEXT) - Notification message
├── type (TEXT) - order, payment, promotional, etc.
├── data (JSONB) - Additional data
├── is_read (BOOLEAN) - Read status
├── image_url (TEXT) - Optional image Cloudinary ID
├── action_url (TEXT) - Deep link
├── created_at (TIMESTAMP) - When sent
└── read_at (TIMESTAMP) - When read
```

**Purpose**: Push notification management.

**Types**: Order updates, payment confirmations, promotional messages.

### 9. Loyalty Points Table
```sql
loyalty_points
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── points (INTEGER) - Points amount
├── type (TEXT) - earned, redeemed, expired
├── source (TEXT) - order, referral, signup
├── reference_id (UUID) - Related record ID
├── description (TEXT) - Transaction description
├── expires_at (TIMESTAMP) - Expiration date
└── created_at (TIMESTAMP) - When awarded
```

**Purpose**: Loyalty program point tracking.

**Expiration**: Points can have expiry dates.

### 10. Coupons Table
```sql
coupons
├── id (UUID) - Primary Key
├── code (TEXT, UNIQUE) - Coupon code
├── name (TEXT) - Display name
├── description (TEXT) - Usage description
├── type (TEXT) - percentage, fixed, free_shipping
├── value (DECIMAL) - Discount value
├── min_order_amount (DECIMAL) - Minimum order value
├── max_discount_amount (DECIMAL) - Maximum discount
├── usage_limit (INTEGER) - Total usage limit
├── usage_count (INTEGER) - Current usage count
├── user_limit (INTEGER) - Per-user limit
├── applicable_categories (TEXT[]) - Valid categories
├── applicable_rituals (TEXT[]) - Valid rituals
├── is_active (BOOLEAN) - Currently active
├── starts_at (TIMESTAMP) - Valid from
├── expires_at (TIMESTAMP) - Valid until
└── timestamps
```

**Purpose**: Discount and promotion management.

**Flexibility**: Supports percentage, fixed amount, and category-specific coupons.

### 11. User Coupons Table
```sql
user_coupons
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── coupon_id (UUID) - Foreign key to coupons
├── order_id (UUID) - Foreign key to orders
├── discount_amount (DECIMAL) - Discount applied
└── used_at (TIMESTAMP) - When used
```

**Purpose**: Track coupon usage per user.

**Prevention**: Prevents multiple uses of same coupon by same user.

### 12. Tracking Table
```sql
tracking
├── id (UUID) - Primary Key
├── order_id (UUID) - Foreign key to orders
├── status (TEXT) - Tracking status
├── location (TEXT) - Current location
├── notes (TEXT) - Status notes
├── timestamp (TIMESTAMP) - When updated
└── updated_by (UUID) - Who updated
```

**Purpose**: Order status tracking history.

**Audit Trail**: Complete history of order status changes.

## Content Management Tables

### 13. Blogs Table
```sql
blogs
├── id (UUID) - Primary Key
├── title (TEXT) - Blog title
├── slug (TEXT, UNIQUE) - URL-friendly identifier
├── content (TEXT) - Blog content (HTML/Markdown)
├── excerpt (TEXT) - Short description
├── cloudinary_id (TEXT) - Featured image Cloudinary ID
├── author (TEXT) - Author name
├── category (TEXT) - Blog category
├── tags (TEXT[]) - Searchable tags
├── is_published (BOOLEAN) - Published status
├── is_featured (BOOLEAN) - Featured blog
├── view_count (INTEGER) - Page views
├── like_count (INTEGER) - User likes
├── published_at (TIMESTAMP) - Publication date
└── timestamps
```

**Purpose**: Content management for blog posts.

**SEO**: URL slugs and categories for search optimization.

### 14. FAQs Table
```sql
faqs
├── id (UUID) - Primary Key
├── question (TEXT) - FAQ question
├── answer (TEXT) - FAQ answer
├── category (TEXT) - Question category
├── order_index (INTEGER) - Display order
├── is_active (BOOLEAN) - Currently active
└── timestamps
```

**Purpose**: Frequently asked questions management.

**Organization**: Categories and ordering for better user experience.

### 15. Live Streams Table
```sql
live_streams
├── id (UUID) - Primary Key
├── title (TEXT) - Stream title
├── description (TEXT) - Stream description
├── ritual_id (UUID) - Foreign key to rituals
├── temple_id (UUID) - Foreign key to temples
├── stream_url (TEXT) - Live stream URL
├── thumbnail_cloudinary_id (TEXT) - Thumbnail Cloudinary ID
├── scheduled_at (TIMESTAMP) - Stream schedule
├── duration (INTEGER) - Expected duration
├── status (TEXT) - scheduled, live, ended, cancelled
├── viewer_count (INTEGER) - Current viewers
├── max_viewers (INTEGER) - Peak viewers
├── recording_url (TEXT) - Recorded video URL
├── is_featured (BOOLEAN) - Featured stream
└── timestamps
```

**Purpose**: Live puja streaming management.

**Analytics**: Viewer tracking and engagement metrics.

### 16. Chadhava Table (Offerings)
```sql
chadhava
├── id (UUID) - Primary Key
├── name (TEXT) - Offering name
├── description (TEXT) - Description
├── category (TEXT) - Offering category
├── price (DECIMAL) - Price
├── cloudinary_id (TEXT) - Image Cloudinary ID
├── temple_id (UUID) - Foreign key to temples
├── deity (TEXT) - Associated deity
├── significance (TEXT) - Religious significance
├── is_popular (BOOLEAN) - Popular offering
├── is_active (BOOLEAN) - Available
└── timestamps
```

**Purpose**: Religious offerings management.

**Relationship**: Offerings linked to specific temples.

### 17. Chadhava Orders Table
```sql
chadhava_orders
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── chadhava_id (UUID) - Foreign key to chadhava
├── temple_id (UUID) - Foreign key to temples
├── order_number (TEXT, UNIQUE) - Order number
├── quantity (INTEGER) - Quantity ordered
├── price (DECIMAL) - Unit price
├── total_amount (DECIMAL) - Total cost
├── payment_status (TEXT) - Payment state
├── payment_method (TEXT) - Payment method
├── payment_id (TEXT) - Transaction ID
├── status (TEXT) - Order status
├── special_instructions (TEXT) - Custom notes
├── delivery_address (TEXT) - Delivery location
└── timestamps
```

**Purpose**: Offering orders management.

**Separate**: Different from ritual orders for better tracking.

### 18. Testimonials Table
```sql
testimonials
├── id (UUID) - Primary Key
├── user_id (UUID) - Foreign key to users
├── name (TEXT) - Display name
├── content (TEXT) - Testimonial text
├── rating (INTEGER) - 1-5 rating
├── ritual_name (TEXT) - Related ritual
├── image_cloudinary_id (TEXT) - User image Cloudinary ID
├── is_featured (BOOLEAN) - Featured testimonial
├── is_verified (BOOLEAN) - Admin verified
├── is_active (BOOLEAN) - Currently active
└── timestamps
```

**Purpose**: Customer testimonials for social proof.

**Verification**: Admin verification for authenticity.

## System Tables

### 19. App Settings Table
```sql
app_settings
├── id (UUID) - Primary Key
├── key (TEXT, UNIQUE) - Setting key
├── value (TEXT) - Setting value
├── description (TEXT) - Setting description
├── type (TEXT) - Data type (string, number, boolean, json)
├── is_public (BOOLEAN) - Publicly accessible
└── timestamps
```

**Purpose**: Application configuration management.

**Dynamic Settings**: Runtime configuration without app updates.

### 20. Referrals Table
```sql
referrals
├── id (UUID) - Primary Key
├── referrer_id (UUID) - User who referred
├── referred_id (UUID) - User who was referred
├── referral_code (TEXT) - Unique referral code
├── status (TEXT) - pending, confirmed, rewarded
├── reward_points (INTEGER) - Points awarded
├── reward_amount (DECIMAL) - Cash reward
└── timestamps
```

**Purpose**: Referral program management.

**Tracking**: Complete referral lifecycle tracking.

## Cloudinary Integration

### Image Storage Strategy
All images are stored in Cloudinary with the following benefits:

1. **CDN Delivery**: Fast image loading globally
2. **Automatic Optimization**: Responsive images
3. **Transformations**: Resize, crop, filter on-demand
4. **Cost Effective**: Pay only for what you use
5. **Scalable**: No storage limits

### Cloudinary Public IDs
Instead of storing full URLs, we store Cloudinary public IDs:

```sql
-- Instead of:
profile_image_url TEXT

-- We use:
profile_cloudinary_id TEXT
```

**Benefits**:
- Smaller database size
- URL flexibility (can change domain)
- Easy transformations
- Consistent naming

### Flutter Integration
```dart
// Get Cloudinary URL from public ID
String getImageUrl(String publicId) {
  return 'https://res.cloudinary.com/your-cloud/image/upload/$publicId';
}

// Transformed image
String getTransformedImage(String publicId, int width, int height) {
  return 'https://res.cloudinary.com/your-cloud/image/upload/w_$width,h_$height/$publicId';
}
```

## Security Features

### Row Level Security (RLS)
Every table has RLS policies:

```sql
-- Users can only access their own data
CREATE POLICY "Users can view own orders" ON orders
  FOR SELECT USING (auth.uid() = user_id);

-- Public content is readable by anyone
CREATE POLICY "Anyone can view active rituals" ON rituals
  FOR SELECT USING (is_active = true);
```

### Data Protection
- **Authentication**: Supabase Auth integration
- **Authorization**: Role-based access control
- **Audit Trails**: Complete change tracking
- **Privacy**: User data isolation

## Performance Optimization

### Indexes
Over 50 performance indexes for:

- **Foreign Keys**: Fast joins
- **Search Fields**: Quick lookups
- **Date Ranges**: Efficient filtering
- **Status Fields**: Status-based queries

### Triggers
Automatic operations:

```sql
-- Auto-update timestamps
CREATE TRIGGER update_users_updated_at 
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Auto-generate order numbers
CREATE TRIGGER generate_order_number_trigger
  BEFORE INSERT ON orders
  FOR EACH ROW EXECUTE FUNCTION generate_order_number();
```

## Setup Instructions

### 1. Database Setup
```bash
# 1. Create Supabase project
# 2. Run the SQL schema in Supabase SQL Editor
# 3. Configure Cloudinary in your Flutter app
```

### 2. Cloudinary Configuration
```dart
// In lib/config/cloudinary_config.dart
class CloudinaryConfig {
  static const String cloudName = 'your-cloud-name';
  static const String apiKey = 'your-api-key';
  static const String apiSecret = 'your-api-secret';
}
```

### 3. Flutter Integration
```dart
// Update models to use cloudinary_id instead of image_url
class Ritual {
  final String cloudinaryId; // Instead of imageUrl
  
  String get imageUrl => CloudinaryConfig.getImageUrl(cloudinaryId);
}
```

## Migration Guide

### From Firebase
1. **Export** existing data
2. **Transform** image URLs to Cloudinary public IDs
3. **Import** to Supabase
4. **Update** Flutter models
5. **Test** all features

### Data Validation
- **Constraints**: Check data integrity
- **Relationships**: Verify foreign keys
- **Images**: Upload to Cloudinary
- **Testing**: Comprehensive feature testing

## Maintenance

### Regular Tasks
- **Backup**: Daily database backups
- **Monitoring**: Performance metrics
- **Cleanup**: Expired data removal
- **Updates**: Schema migrations

### Scaling Considerations
- **Read Replicas**: For high read traffic
- **Connection Pooling**: Manage database connections
- **Caching**: Redis for frequent queries
- **CDN**: Cloudinary for images

## Troubleshooting

### Common Issues
1. **RLS Policies**: Users can't access data
2. **Foreign Keys**: Constraint violations
3. **Image URLs**: Broken Cloudinary links
4. **Performance**: Slow queries

### Debugging Steps
1. **Check RLS policies** in Supabase dashboard
2. **Verify foreign key** relationships
3. **Test Cloudinary** configuration
4. **Analyze query** performance

---

**Last Updated**: November 16, 2024  
**Version**: 1.0.0  
**Compatible**: Supabase + Cloudinary + Flutter

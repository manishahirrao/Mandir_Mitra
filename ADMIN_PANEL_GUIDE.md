# Admin Panel Implementation Guide

## Overview
This guide covers setting up a Flutter web-based admin panel for managing orders, videos, users, and other content.

## Architecture

### Option 1: Separate Flutter Web App (Recommended)
- Create `admin_panel/` folder at root level
- Share models and services via path imports
- Deploy separately to admin.yourdomain.com
- Secure with admin-only authentication

### Option 2: Same App with Role-Based Access
- Add admin routes to existing app
- Use role-based navigation guards
- Show admin menu only for admin users
- Deploy together but restrict access

## Features to Implement

### 1. Dashboard
- Total users, orders, revenue stats
- Recent activity feed
- Quick actions panel

### 2. User Management
- List all users with search/filter
- View user details and order history
- Edit user profiles
- Suspend/activate accounts

### 3. Order Management
- View all orders (pending, completed, cancelled)
- Update order status
- Assign priests/performers
- Track order fulfillment
- Refund management

### 4. Video Management
- Upload live stream videos
- Schedule live streams
- Manage video library
- Set video visibility (public/private)

### 5. Content Management
- Manage rituals, temples, chadhava offerings
- Edit pricing and packages
- Update descriptions and images
- Manage blog posts and FAQs

### 6. Analytics
- Revenue reports
- Popular rituals/temples
- User engagement metrics
- Booking trends

## Database Schema Additions

### Admin Users Table
```sql
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  role TEXT NOT NULL, -- 'super_admin', 'admin', 'content_manager', 'support'
  permissions JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Order Status Updates
```sql
ALTER TABLE orders ADD COLUMN assigned_to UUID REFERENCES admin_users(id);
ALTER TABLE orders ADD COLUMN admin_notes TEXT;
```

## Security Considerations

1. **Authentication**
   - Separate admin login flow
   - Multi-factor authentication required
   - Session timeout (15 minutes)

2. **Authorization**
   - Role-based access control (RBAC)
   - Audit logs for all admin actions
   - IP whitelist for admin access

3. **Data Protection**
   - Mask sensitive user data (phone, email)
   - Secure file uploads
   - Rate limiting on API endpoints

## Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (existing)
- **Auth**: Supabase Auth with admin roles
- **Storage**: Supabase Storage for videos
- **Hosting**: Vercel or Firebase Hosting

## Quick Start

### Step 1: Create Admin Panel Structure
```
man/
├── lib/           # Main app
└── admin_panel/   # New admin app
    ├── lib/
    │   ├── main.dart
    │   ├── screens/
    │   │   ├── admin_dashboard.dart
    │   │   ├── users_management_screen.dart
    │   │   ├── orders_management_screen.dart
    │   │   └── videos_management_screen.dart
    │   ├── widgets/
    │   └── services/
    └── pubspec.yaml
```

### Step 2: Setup Supabase Policies

```sql
-- Admin-only access to user data
CREATE POLICY "Admins can view all users"
ON users FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE user_id = auth.uid()
  )
);

-- Admin can update orders
CREATE POLICY "Admins can update orders"
ON orders FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE user_id = auth.uid()
  )
);
```

### Step 3: Build Admin Routes

Key screens needed:
- `/admin/login` - Admin authentication
- `/admin/dashboard` - Overview stats
- `/admin/users` - User management
- `/admin/orders` - Order management
- `/admin/videos` - Video uploads and streaming
- `/admin/content` - Rituals, temples, blog management
- `/admin/analytics` - Reports and insights

## Development Workflow

1. **Local Development**
   ```bash
   cd admin_panel
   flutter run -d chrome
   ```

2. **Build for Production**
   ```bash
   flutter build web --release
   ```

3. **Deploy to Vercel**
   - Create separate Vercel project
   - Point to `admin_panel/build/web`
   - Set custom domain: admin.yourdomain.com

## Next Steps

1. Set up admin user roles in Supabase
2. Create basic admin panel structure
3. Implement authentication guard
4. Build dashboard with key metrics
5. Add user management screen
6. Add order management screen
7. Add video upload/management
8. Deploy and test

## Extended Features Implemented ✅

The admin panel now includes:

### Core Management
- ✅ Dashboard with real-time stats
- ✅ User management with search/filter
- ✅ Order management with status updates
- ✅ Video upload and management

### Advanced Features
- ✅ **Analytics Screen**: Revenue trends, user growth, popular rituals with charts
- ✅ **Content Management**: Manage rituals, temples, chadhava, blogs, FAQs
- ✅ **Push Notifications**: Send targeted notifications to users
- ✅ **Bulk Operations**: Export data, bulk updates, cleanup tasks
- ✅ **Audit Log**: Track all admin actions with complete history
- ✅ **Settings**: App configuration, maintenance mode, support details

### Security & Compliance
- ✅ Role-based access control
- ✅ Complete audit trail
- ✅ Row Level Security policies
- ✅ Secure authentication

## Files Created

```
admin_panel/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── admin_login_screen.dart
│   │   ├── admin_dashboard.dart
│   │   ├── users_management_screen.dart
│   │   ├── orders_management_screen.dart
│   │   ├── videos_management_screen.dart
│   │   ├── analytics_screen.dart ⭐ NEW
│   │   ├── content_management_screen.dart ⭐ NEW
│   │   ├── notifications_screen.dart ⭐ NEW
│   │   ├── bulk_operations_screen.dart ⭐ NEW
│   │   ├── audit_log_screen.dart ⭐ NEW
│   │   └── settings_screen.dart ⭐ NEW
│   └── services/
│       └── admin_auth_service.dart
├── pubspec.yaml
├── supabase_admin_setup.sql
├── README.md
├── DEPLOYMENT.md
├── FEATURES.md
└── run_admin.bat

Total: 10 screens, complete admin solution
```

## Quick Start

1. **Setup Database**
   ```bash
   # Run SQL in Supabase Dashboard
   # File: admin_panel/supabase_admin_setup.sql
   ```

2. **Configure**
   ```bash
   # Edit admin_panel/lib/main.dart
   # Add your Supabase URL and keys
   ```

3. **Run**
   ```bash
   cd admin_panel
   flutter pub get
   flutter run -d chrome
   ```

   Or double-click `run_admin.bat` on Windows

## Alternative: Use Existing Admin Tools

If you want faster setup, consider:

1. **Supabase Studio** - Built-in admin interface for database
2. **Retool** - Low-code admin panel builder
3. **Forest Admin** - Auto-generated admin panel
4. **Appsmith** - Open-source admin panel builder

These can connect to your Supabase backend and provide instant admin capabilities.

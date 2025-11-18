-- =====================================================
-- Mandir Mitra - Complete Database Schema
-- Main App Tables for Supabase
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone TEXT,
  profile_cloudinary_id TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  language TEXT DEFAULT 'english',
  preferred_temple TEXT,
  loyalty_points INTEGER DEFAULT 0,
  loyalty_tier TEXT DEFAULT 'bronze',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. TEMPLES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS temples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  city TEXT,
  state TEXT,
  country TEXT DEFAULT 'India',
  description TEXT,
  cloudinary_id TEXT,
  deity TEXT,
  timings TEXT,
  contact TEXT,
  website TEXT,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  is_popular BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  rating DECIMAL(3,2) DEFAULT 0.00,
  review_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. RITUALS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS rituals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  subcategory TEXT,
  price DECIMAL(10,2) NOT NULL,
  duration INTEGER, -- in minutes
  cloudinary_id TEXT,
  video_url TEXT,
  temple_id UUID REFERENCES temples(id),
  deity TEXT,
  benefits TEXT,
  requirements TEXT,
  what_includes TEXT,
  is_popular BOOLEAN DEFAULT FALSE,
  is_featured BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  rating DECIMAL(3,2) DEFAULT 0.00,
  review_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. ORDERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  ritual_id UUID REFERENCES rituals(id),
  temple_id UUID REFERENCES temples(id),
  order_number TEXT UNIQUE NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  payment_status TEXT DEFAULT 'pending',
  payment_method TEXT,
  payment_id TEXT,
  amount DECIMAL(10,2) NOT NULL,
  discount_amount DECIMAL(10,2) DEFAULT 0.00,
  final_amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'INR',
  scheduled_date DATE,
  scheduled_time TIME,
  duration INTEGER, -- in minutes
  participant_names TEXT[],
  special_requests TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  phone TEXT,
  email TEXT,
  video_link TEXT,
  invoice_url TEXT,
  tracking_info JSONB,
  admin_notes TEXT,
  assigned_to UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 5. BOOKINGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  ritual_id UUID REFERENCES rituals(id),
  temple_id UUID REFERENCES temples(id),
  booking_date DATE NOT NULL,
  booking_time TIME NOT NULL,
  status TEXT DEFAULT 'confirmed',
  participant_names TEXT[],
  special_instructions TEXT,
  total_amount DECIMAL(10,2) NOT NULL,
  paid_amount DECIMAL(10,2) DEFAULT 0.00,
  balance_amount DECIMAL(10,2) DEFAULT 0.00,
  payment_status TEXT DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 6. WISHLIST TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS wishlist (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  ritual_id UUID REFERENCES rituals(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, ritual_id)
);

-- =====================================================
-- 7. REVIEWS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  ritual_id UUID REFERENCES rituals(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  review_text TEXT,
  images TEXT[], -- Cloudinary public IDs
  is_verified BOOLEAN DEFAULT FALSE,
  is_public BOOLEAN DEFAULT TRUE,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, order_id)
);

-- =====================================================
-- 8. NOTIFICATIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  action_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  read_at TIMESTAMP WITH TIME ZONE
);

-- =====================================================
-- 9. LOYALTY POINTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS loyalty_points (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  points INTEGER NOT NULL,
  type TEXT NOT NULL, -- earned, redeemed, expired
  source TEXT NOT NULL, -- order, referral, signup, etc.
  reference_id UUID, -- order_id, referral_id, etc.
  description TEXT,
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 10. COUPONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS coupons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL, -- percentage, fixed, free_shipping
  value DECIMAL(10,2) NOT NULL,
  min_order_amount DECIMAL(10,2) DEFAULT 0.00,
  max_discount_amount DECIMAL(10,2),
  usage_limit INTEGER,
  usage_count INTEGER DEFAULT 0,
  user_limit INTEGER DEFAULT 1, -- per user
  applicable_categories TEXT[],
  applicable_rituals TEXT[],
  is_active BOOLEAN DEFAULT TRUE,
  starts_at TIMESTAMP WITH TIME ZONE,
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 11. USER COUPONS TABLE (Track user-specific coupon usage)
-- =====================================================
CREATE TABLE IF NOT EXISTS user_coupons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  coupon_id UUID REFERENCES coupons(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id),
  discount_amount DECIMAL(10,2) NOT NULL,
  used_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, coupon_id, order_id)
);

-- =====================================================
-- 12. TRACKING TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS tracking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  status TEXT NOT NULL,
  location TEXT,
  notes TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_by UUID REFERENCES users(id)
);

-- =====================================================
-- 13. BLOGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS blogs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  content TEXT NOT NULL,
  excerpt TEXT,
  cloudinary_id TEXT,
  author TEXT NOT NULL,
  category TEXT NOT NULL,
  tags TEXT[],
  is_published BOOLEAN DEFAULT FALSE,
  is_featured BOOLEAN DEFAULT FALSE,
  view_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  published_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 14. FAQS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS faqs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  category TEXT NOT NULL,
  order_index INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 15. LIVE STREAMS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS live_streams (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  ritual_id UUID REFERENCES rituals(id),
  temple_id UUID REFERENCES temples(id),
  stream_url TEXT,
  thumbnail_cloudinary_id TEXT,
  scheduled_at TIMESTAMP WITH TIME ZONE,
  duration INTEGER, -- in minutes
  status TEXT DEFAULT 'scheduled', -- scheduled, live, ended, cancelled
  viewer_count INTEGER DEFAULT 0,
  max_viewers INTEGER DEFAULT 0,
  recording_url TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 16. CHADHAVA TABLE (Offerings)
-- =====================================================
CREATE TABLE IF NOT EXISTS chadhava (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  cloudinary_id TEXT,
  temple_id UUID REFERENCES temples(id),
  deity TEXT,
  significance TEXT,
  is_popular BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 17. CHADHAVA ORDERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS chadhava_orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  chadhava_id UUID REFERENCES chadhava(id),
  temple_id UUID REFERENCES temples(id),
  order_number TEXT UNIQUE NOT NULL,
  quantity INTEGER DEFAULT 1,
  price DECIMAL(10,2) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  payment_status TEXT DEFAULT 'pending',
  payment_method TEXT,
  payment_id TEXT,
  status TEXT DEFAULT 'pending',
  special_instructions TEXT,
  delivery_address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 18. TESTIMONIALS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS testimonials (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  content TEXT NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  ritual_name TEXT,
  image_cloudinary_id TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 19. APP SETTINGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS app_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key TEXT UNIQUE NOT NULL,
  value TEXT,
  description TEXT,
  type TEXT DEFAULT 'string', -- string, number, boolean, json
  is_public BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 20. REFERRALS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS referrals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  referrer_id UUID REFERENCES users(id) ON DELETE CASCADE,
  referred_id UUID REFERENCES users(id) ON DELETE CASCADE,
  referral_code TEXT NOT NULL,
  status TEXT DEFAULT 'pending', -- pending, confirmed, rewarded
  reward_points INTEGER DEFAULT 0,
  reward_amount DECIMAL(10,2) DEFAULT 0.00,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(referrer_id, referred_id)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_loyalty_tier ON users(loyalty_tier);

-- Rituals indexes
CREATE INDEX IF NOT EXISTS idx_rituals_category ON rituals(category);
CREATE INDEX IF NOT EXISTS idx_rituals_temple ON rituals(temple_id);
CREATE INDEX IF NOT EXISTS idx_rituals_price ON rituals(price);
CREATE INDEX IF NOT EXISTS idx_rituals_rating ON rituals(rating);
CREATE INDEX IF NOT EXISTS idx_rituals_popular ON rituals(is_popular);
CREATE INDEX IF NOT EXISTS idx_rituals_active ON rituals(is_active);

-- Temples indexes
CREATE INDEX IF NOT EXISTS idx_temples_location ON temples(location);
CREATE INDEX IF NOT EXISTS idx_temples_city ON temples(city);
CREATE INDEX IF NOT EXISTS idx_temples_state ON temples(state);
CREATE INDEX IF NOT EXISTS idx_temples_rating ON temples(rating);

-- Orders indexes
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_ritual ON orders(ritual_id);
CREATE INDEX IF NOT EXISTS idx_orders_temple ON orders(temple_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_orders_created ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);

-- Bookings indexes
CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_order ON bookings(order_id);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- Reviews indexes
CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_ritual ON reviews(ritual_id);
CREATE INDEX IF NOT EXISTS idx_reviews_order ON reviews(order_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_public ON reviews(is_public);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(created_at);

-- Loyalty points indexes
CREATE INDEX IF NOT EXISTS idx_loyalty_user ON loyalty_points(user_id);
CREATE INDEX IF NOT EXISTS idx_loyalty_type ON loyalty_points(type);
CREATE INDEX IF NOT EXISTS idx_loyalty_created ON loyalty_points(created_at);

-- Coupons indexes
CREATE INDEX IF NOT EXISTS idx_coupons_code ON coupons(code);
CREATE INDEX IF NOT EXISTS idx_coupons_active ON coupons(is_active);
CREATE INDEX IF NOT EXISTS idx_coupons_expires ON coupons(expires_at);

-- Tracking indexes
CREATE INDEX IF NOT EXISTS idx_tracking_order ON tracking(order_id);
CREATE INDEX IF NOT EXISTS idx_tracking_status ON tracking(status);
CREATE INDEX IF NOT EXISTS idx_tracking_timestamp ON tracking(timestamp);

-- Blogs indexes
CREATE INDEX IF NOT EXISTS idx_blogs_category ON blogs(category);
CREATE INDEX IF NOT EXISTS idx_blogs_published ON blogs(is_published);
CREATE INDEX IF NOT EXISTS idx_blogs_featured ON blogs(is_featured);
CREATE INDEX IF NOT EXISTS idx_blogs_published_at ON blogs(published_at);

-- FAQs indexes
CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs(category);
CREATE INDEX IF NOT EXISTS idx_faqs_active ON faqs(is_active);
CREATE INDEX IF NOT EXISTS idx_faqs_order ON faqs(order_index);

-- Live streams indexes
CREATE INDEX IF NOT EXISTS idx_live_streams_ritual ON live_streams(ritual_id);
CREATE INDEX IF NOT EXISTS idx_live_streams_temple ON live_streams(temple_id);
CREATE INDEX IF NOT EXISTS idx_live_streams_status ON live_streams(status);
CREATE INDEX IF NOT EXISTS idx_live_streams_scheduled ON live_streams(scheduled_at);

-- Chadhava indexes
CREATE INDEX IF NOT EXISTS idx_chadhava_category ON chadhava(category);
CREATE INDEX IF NOT EXISTS idx_chadhava_temple ON chadhava(temple_id);
CREATE INDEX IF NOT EXISTS idx_chadhava_active ON chadhava(is_active);

-- Chadhava orders indexes
CREATE INDEX IF NOT EXISTS idx_chadhava_orders_user ON chadhava_orders(user_id);
CREATE INDEX IF NOT EXISTS idx_chadhava_orders_chadhava ON chadhava_orders(chadhava_id);
CREATE INDEX IF NOT EXISTS idx_chadhava_orders_temple ON chadhava_orders(temple_id);
CREATE INDEX IF NOT EXISTS idx_chadhava_orders_status ON chadhava_orders(status);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE rituals ENABLE ROW LEVEL SECURITY;
ALTER TABLE temples ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE loyalty_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE blogs ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_streams ENABLE ROW LEVEL SECURITY;
ALTER TABLE chadhava ENABLE ROW LEVEL SECURITY;
ALTER TABLE chadhava_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Rituals table policies (public read)
CREATE POLICY "Anyone can view active rituals" ON rituals
  FOR SELECT USING (is_active = true);

-- Temples table policies (public read)
CREATE POLICY "Anyone can view active temples" ON temples
  FOR SELECT USING (is_active = true);

-- Orders table policies
CREATE POLICY "Users can view own orders" ON orders
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders" ON orders
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own orders" ON orders
  FOR UPDATE USING (auth.uid() = user_id);

-- Bookings table policies
CREATE POLICY "Users can view own bookings" ON bookings
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own bookings" ON bookings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own bookings" ON bookings
  FOR UPDATE USING (auth.uid() = user_id);

-- Wishlist table policies
CREATE POLICY "Users can manage own wishlist" ON wishlist
  FOR ALL USING (auth.uid() = user_id);

-- Reviews table policies
CREATE POLICY "Users can view public reviews" ON reviews
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can manage own reviews" ON reviews
  FOR ALL USING (auth.uid() = user_id);

-- Notifications table policies
CREATE POLICY "Users can manage own notifications" ON notifications
  FOR ALL USING (auth.uid() = user_id);

-- Loyalty points table policies
CREATE POLICY "Users can view own loyalty points" ON loyalty_points
  FOR SELECT USING (auth.uid() = user_id);

-- Coupons table policies (public read for active)
CREATE POLICY "Anyone can view active coupons" ON coupons
  FOR SELECT USING (is_active = true AND (starts_at IS NULL OR starts_at <= NOW()) AND (expires_at IS NULL OR expires_at > NOW()));

-- User coupons table policies
CREATE POLICY "Users can view own coupon usage" ON user_coupons
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own coupon usage" ON user_coupons
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Tracking table policies
CREATE POLICY "Users can view tracking for own orders" ON tracking
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = tracking.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Blogs table policies
CREATE POLICY "Anyone can view published blogs" ON blogs
  FOR SELECT USING (is_published = true);

-- FAQs table policies
CREATE POLICY "Anyone can view active FAQs" ON faqs
  FOR SELECT USING (is_active = true);

-- Live streams table policies
CREATE POLICY "Anyone can view live streams" ON live_streams
  FOR SELECT USING (status IN ('scheduled', 'live', 'ended'));

-- Chadhava table policies (public read for active)
CREATE POLICY "Anyone can view active chadhava" ON chadhava
  FOR SELECT USING (is_active = true);

-- Chadhava orders table policies
CREATE POLICY "Users can manage own chadhava orders" ON chadhava_orders
  FOR ALL USING (auth.uid() = user_id);

-- Testimonials table policies
CREATE POLICY "Anyone can view active testimonials" ON testimonials
  FOR SELECT USING (is_active = true AND is_verified = true);

-- App settings table policies
CREATE POLICY "Anyone can view public settings" ON app_settings
  FOR SELECT USING (is_public = true);

-- Referrals table policies
CREATE POLICY "Users can view own referrals" ON referrals
  FOR SELECT USING (auth.uid() = referrer_id OR auth.uid() = referred_id);

CREATE POLICY "Users can create referrals" ON referrals
  FOR INSERT WITH CHECK (auth.uid() = referrer_id);

-- =====================================================
-- TRIGGERS AND FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rituals_updated_at BEFORE UPDATE ON rituals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_temples_updated_at BEFORE UPDATE ON temples
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_coupons_updated_at BEFORE UPDATE ON coupons
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_faqs_updated_at BEFORE UPDATE ON faqs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_live_streams_updated_at BEFORE UPDATE ON live_streams
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chadhava_updated_at BEFORE UPDATE ON chadhava
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_testimonials_updated_at BEFORE UPDATE ON testimonials
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_app_settings_updated_at BEFORE UPDATE ON app_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_referrals_updated_at BEFORE UPDATE ON referrals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
DECLARE
  order_num TEXT;
  year_month TEXT := to_char(NOW(), 'YYMM');
  sequence_num INTEGER;
BEGIN
  -- Get next sequence number for this month
  SELECT COALESCE(MAX(CAST(SUBSTRING(order_number FROM 7) AS INTEGER)), 0) + 1
  INTO sequence_num
  FROM orders
  WHERE order_number LIKE 'MM' || year_month || '%';
  
  -- Format: MMYYMM123456
  order_num := 'MM' || year_month || LPAD(sequence_num::TEXT, 6, '0');
  
  RETURN order_num;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate order number
CREATE TRIGGER generate_order_number_trigger
  BEFORE INSERT ON orders
  FOR EACH ROW
  WHEN (NEW.order_number IS NULL)
  EXECUTE FUNCTION generate_order_number();

-- Function to update ritual rating when review is added
CREATE OR REPLACE FUNCTION update_ritual_rating()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.is_public != OLD.is_public) THEN
    UPDATE rituals
    SET 
      rating = (
        SELECT COALESCE(AVG(rating), 0)
        FROM reviews
        WHERE ritual_id = NEW.ritual_id
        AND is_public = true
      ),
      review_count = (
        SELECT COUNT(*)
        FROM reviews
        WHERE ritual_id = NEW.ritual_id
        AND is_public = true
      )
    WHERE id = NEW.ritual_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for rating updates
CREATE TRIGGER update_ritual_rating_on_review
  AFTER INSERT OR UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_ritual_rating();

CREATE TRIGGER update_ritual_rating_on_review_delete
  AFTER DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_ritual_rating();

-- =====================================================
-- INITIAL DATA
-- =====================================================

-- Insert default app settings
INSERT INTO app_settings (key, value, description, type, is_public) VALUES
('app_name', 'Mandir Mitra', 'Application name', 'string', true),
('app_version', '1.0.0', 'Current app version', 'string', true),
('maintenance_mode', 'false', 'App under maintenance', 'boolean', true),
('min_order_amount', '100', 'Minimum order amount', 'number', true),
('support_email', 'support@mandirmitra.app', 'Support email', 'string', true),
('support_phone', '+919876543210', 'Support phone', 'string', true),
('loyalty_points_per_rupee', '1', 'Loyalty points earned per rupee', 'number', false),
('referral_bonus_points', '100', 'Points for successful referral', 'number', false),
('signup_bonus_points', '50', 'Points for new signup', 'number', false);



SELECT 'Mandir Mitra Database Schema Created Successfully!' as status;

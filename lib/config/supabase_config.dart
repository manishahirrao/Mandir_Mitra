import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Replace with your actual Supabase credentials
  static const String supabaseUrl = 'https://widjqzuxwueorlufjnpj.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpZGpxenV4d3Vlb3JsdWZqbnBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyMjIxMzAsImV4cCI6MjA3ODc5ODEzMH0.ZXIYHgoOpaW_zQk50zO-EjF0AsTkZ4fJQVA8kw-_uEk';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  // Database tables
  static const String usersTable = 'users';
  static const String ritualsTable = 'rituals';
  static const String ordersTable = 'orders';
  static const String wishlistTable = 'wishlist';
  static const String reviewsTable = 'reviews';
  static const String notificationsTable = 'notifications';
  static const String loyaltyPointsTable = 'loyalty_points';
  static const String couponsTable = 'coupons';
  static const String bookingsTable = 'bookings';
  static const String trackingTable = 'tracking';
  static const String blogsTable = 'blogs';
  static const String faqsTable = 'faqs';
  static const String templesTable = 'temples';

  // Storage buckets (NOT USED - Using Cloudinary instead)
  // All images and videos are stored in Cloudinary
  // Cloudinary provides better optimization, CDN, and transformations
}

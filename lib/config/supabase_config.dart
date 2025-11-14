import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Replace with your actual Supabase credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

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

  // Storage buckets
  static const String profileImagesBucket = 'profile-images';
  static const String ritualImagesBucket = 'ritual-images';
  static const String reviewImagesBucket = 'review-images';
  static const String invoicesBucket = 'invoices';
}

import 'package:flutter/material.dart';
import '../screens/ritual_detail_screen.dart';
import '../screens/temple_detail_screen.dart';
import '../screens/chadhava_detail_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/services_screen.dart';
import '../screens/temples_screen.dart';
import '../screens/chadhava_screen.dart';
import '../screens/personal_ritual_screen.dart';
import '../screens/my_rituals_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/search_screen.dart';
import '../screens/blog_screen.dart';
import '../screens/faq_screen.dart';
import '../screens/about_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/loyalty_screen.dart';
import '../screens/tracking_screen.dart';
import '../screens/live_stream_screen.dart';
import '../screens/loved_ones_screen.dart';
import '../models/ritual.dart';
import '../models/temple.dart';
import '../models/chadhava.dart';

/// Navigation helper class for consistent navigation throughout the app
class NavigationHelper {
  /// Navigate to Ritual Detail Screen
  static void navigateToRitualDetail(BuildContext context, Ritual ritual) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RitualDetailScreen(ritual: ritual),
      ),
    );
  }

  /// Navigate to Temple Detail Screen
  static void navigateToTempleDetail(BuildContext context, Temple temple) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TempleDetailScreen(temple: temple),
      ),
    );
  }

  /// Navigate to Chadhava Detail Screen
  static void navigateToChadhavaDetail(BuildContext context, Chadhava chadhava) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChadhavaDetailScreen(chadhava: chadhava),
      ),
    );
  }

  /// Navigate to Booking Screen
  static void navigateToBooking(BuildContext context, {Ritual? ritual}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          ritual: ritual!,
          selectedPackage: 'basic',
        ),
      ),
    );
  }

  /// Navigate to Services/Rituals Screen
  static void navigateToServices(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServicesScreen(),
      ),
    );
  }

  /// Navigate to Temples Screen
  static void navigateToTemples(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TemplesScreen(),
      ),
    );
  }

  /// Navigate to Chadhava Screen
  static void navigateToChadhava(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChadhavaScreen(),
      ),
    );
  }

  /// Navigate to Personal Ritual Screen
  static void navigateToPersonalRitual(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonalRitualScreen(),
      ),
    );
  }

  /// Navigate to My Rituals Screen
  static void navigateToMyRituals(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyRitualsScreen(),
      ),
    );
  }

  /// Navigate to Profile Screen
  static void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  /// Navigate to Wishlist Screen
  static void navigateToWishlist(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WishlistScreen(),
      ),
    );
  }

  /// Navigate to Notifications Screen
  static void navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }

  /// Navigate to Search Screen
  static void navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
  }

  /// Navigate to Blog Screen
  static void navigateToBlog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BlogScreen(),
      ),
    );
  }

  /// Navigate to FAQ Screen
  static void navigateToFAQ(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FAQScreen(),
      ),
    );
  }

  /// Navigate to Help & Support Screen
  static void navigateToHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpSupportScreen(),
      ),
    );
  }

  /// Navigate to About Screen
  static void navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }

  /// Navigate to Settings Screen
  static void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  /// Navigate to Loyalty Screen
  static void navigateToLoyalty(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoyaltyScreen(),
      ),
    );
  }

  /// Navigate to Tracking Screen
  static void navigateToTracking(BuildContext context, String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackingScreen(orderId: orderId),
      ),
    );
  }

  /// Navigate to Live Stream Screen
  static void navigateToLiveStream(BuildContext context, String streamId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStreamScreen(ritualId: streamId),
      ),
    );
  }

  /// Navigate to Loved Ones Screen
  static void navigateToLovedOnes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LovedOnesScreen(),
      ),
    );
  }

  /// Show Coming Soon Dialog
  static void showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

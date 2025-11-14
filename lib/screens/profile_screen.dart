import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../services/auth_provider.dart';
import '../widgets/profile/menu_item.dart';
import '../utils/app_theme.dart';
import 'faq_screen.dart';
import 'blog_screen.dart';
import 'about_screen.dart';
import 'auth/login_screen.dart';
import 'notification_preferences_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          if (user == null) {
            return const Center(child: Text('Please login'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context, user),
                const SizedBox(height: 16),
                _buildAccountSection(context),
                const SizedBox(height: 16),
                _buildOrdersSection(context),
                const SizedBox(height: 16),
                _buildSpiritualSection(context),
                const SizedBox(height: 16),
                _buildContentSection(context),
                const SizedBox(height: 16),
                _buildSupportSection(context),
                const SizedBox(height: 16),
                _buildSettingsSection(context),
                const SizedBox(height: 16),
                _buildAccountActions(context, userProvider),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.sacredBlue.withOpacity(0.05),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: user.profilePhoto != null
                    ? NetworkImage(user.profilePhoto!)
                    : null,
                child: user.profilePhoto == null
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.sacredBlue,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt,
                        size: 16, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Change photo feature coming soon')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.phone,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (user.isPhoneVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, size: 16, color: AppTheme.successGreen),
              ],
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile feature coming soon')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.sacredBlue),
              foregroundColor: AppTheme.sacredBlue,
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSection(
      'ACCOUNT',
      [
        MenuItem(
          icon: Icons.person_outline,
          title: 'Personal Information',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.location_on_outlined,
          title: 'Saved Addresses',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.favorite_border,
          title: 'Wishlist',
          onTap: () {
            Navigator.pushNamed(context, '/wishlist');
          },
        ),
        MenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notification Preferences',
          onTap: () => _showComingSoon(context),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildOrdersSection(BuildContext context) {
    return _buildSection(
      'ORDERS',
      [
        MenuItem(
          icon: Icons.event_note,
          title: 'My Orders',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.local_shipping_outlined,
          title: 'Aashirwad Box Tracking',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.history,
          title: 'Order History',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.receipt_outlined,
          title: 'Download Invoices',
          onTap: () => _showComingSoon(context),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSpiritualSection(BuildContext context) {
    return _buildSection(
      'SPIRITUAL',
      [
        MenuItem(
          icon: Icons.calendar_today_outlined,
          title: 'Spiritual Consultation Booking',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.video_call_outlined,
          title: 'My Consultations',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.recommend_outlined,
          title: 'Recommended Rituals',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.stars_outlined,
          title: 'Astrology Profile',
          onTap: () => _showComingSoon(context),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return _buildSection(
      'CONTENT',
      [
        MenuItem(
          icon: Icons.article_outlined,
          title: 'Blog & Resources',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BlogScreen()),
            );
          },
        ),
        MenuItem(
          icon: Icons.help_outline,
          title: 'FAQ',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQScreen()),
            );
          },
        ),
        MenuItem(
          icon: Icons.info_outline,
          title: 'About Mandir Mitra',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
        MenuItem(
          icon: Icons.temple_hindu_outlined,
          title: 'Temple Partners',
          onTap: () => _showComingSoon(context),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      'SUPPORT',
      [
        MenuItem(
          icon: Icons.support_agent_outlined,
          title: 'Help & Support',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.contact_mail_outlined,
          title: 'Contact Us',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.star_outline,
          title: 'Rate the App',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.share_outlined,
          title: 'Share App',
          onTap: () => _showComingSoon(context),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSection(
      'SETTINGS',
      [
        MenuItem(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'English',
          onTap: () => _showLanguageDialog(context),
        ),
        MenuItem(
          icon: Icons.dark_mode_outlined,
          title: 'Theme',
          trailing: Switch(
            value: false,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme toggle coming soon')),
              );
            },
            activeColor: AppTheme.sacredBlue,
          ),
          onTap: null,
        ),
        MenuItem(
          icon: Icons.cleaning_services_outlined,
          title: 'Clear Cache',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.info_outline,
          title: 'App Version',
          subtitle: '1.0.0',
          trailing: const SizedBox.shrink(),
          onTap: null,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context, UserProvider userProvider) {
    return _buildSection(
      'ACCOUNT ACTIONS',
      [
        MenuItem(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          onTap: () => _showComingSoon(context),
        ),
        MenuItem(
          icon: Icons.delete_outline,
          title: 'Delete Account',
          onTap: () => _showDeleteAccountDialog(context),
        ),
        MenuItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () => _showLogoutDialog(context, userProvider),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: items),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming soon')),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'English'),
            _buildLanguageOption(context, 'Hindi'),
            _buildLanguageOption(context, 'Bengali'),
            _buildLanguageOption(context, 'Tamil'),
            _buildLanguageOption(context, 'Telugu'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language changed to $language')),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              userProvider.logout();
              
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout',
                style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Account deletion request submitted')),
              );
            },
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}

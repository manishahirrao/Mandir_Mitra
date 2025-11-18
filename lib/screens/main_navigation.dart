import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/navigation_helper.dart';
import '../services/user_provider.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'temples_screen.dart';
import 'chadavas_screen.dart';
import 'personal_ritual_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2; // Start with Home (center)
  
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF8C42), width: 2),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFFFE5D0),
                radius: 16,
                child: Icon(Icons.person, color: Color(0xFFFF8C42), size: 20),
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Color(0xFF2D3748)),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8C42),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              NavigationHelper.navigateToNotifications(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildProfileDrawer(context),
      body: PageStorage(
        bucket: _bucket,
        child: _getScreen(),
      ),
      bottomNavigationBar: _buildPremiumBottomNav(),
    );
  }

  Widget _getScreen() {
    // Wrap screens to remove their AppBars
    switch (_currentIndex) {
      case 0:
        return const TemplesScreen();
      case 1:
        return const ServicesScreen();
      case 2:
        return const HomeScreen();
      case 3:
        return const ChadavasScreen();
      case 4:
        return const PersonalRitualScreen();
      default:
        return const HomeScreen();
    }
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Temples';
      case 1:
        return 'Rituals';
      case 2:
        return 'Mandir Mitra';
      case 3:
        return 'Chadavas';
      case 4:
        return 'Personal Rituals';
      default:
        return 'Mandir Mitra';
    }
  }

  Widget _buildProfileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final user = userProvider.user;
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: user?.profilePhoto != null ? NetworkImage(user!.profilePhoto!) : null,
                        child: user?.profilePhoto == null ? const Icon(Icons.person, size: 35, color: Colors.grey) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'User Name',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Complete your Profile',
                              style: TextStyle(fontSize: 14, color: Color(0xFFFF8C42), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard('Punya\nMudra', '1,200')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Bhakti\nChakra', '75%')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Attendance', '15 Days')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Help Centre & Language
            _buildDrawerTile(Icons.help_outline, 'Help Centre', () {}),
            _buildDrawerTileWithToggle(Icons.language, 'English Mode'),
            const SizedBox(height: 16),
            // Primary Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Primary Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF8C42))),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      NavigationHelper.navigateToLovedOnes(context);
                    },
                    child: _buildActionButton(Icons.group_add, 'Add your loved ones on Sri Mandir'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Main Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Text('Main Menu Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.person_outline, 'My Profile', () => NavigationHelper.navigateToProfile(context), isHighlighted: true),
                  _buildMenuItem(Icons.calendar_today_outlined, 'My Bookings', () => NavigationHelper.navigateToMyRituals(context)),
                  _buildMenuItem(Icons.volunteer_activism_outlined, 'Offer Chadhava Today', () {}),
                  _buildMenuItem(Icons.book_outlined, 'Book Puja with Sri Mandir', () {}),
                  const SizedBox(height: 20),
                  const Text('Other Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.translate, 'Change the language', () {}),
                  _buildMenuItem(Icons.star_outline, 'Rate on Playstore', () {}),
                  _buildMenuItem(Icons.favorite_outline, 'Wishlist', () => NavigationHelper.navigateToWishlist(context)),
                  _buildMenuItem(Icons.card_giftcard, 'Loyalty & Rewards', () => NavigationHelper.navigateToLoyalty(context)),
                  _buildMenuItem(Icons.settings, 'Settings', () => NavigationHelper.navigateToSettings(context)),
                  _buildMenuItem(Icons.help_outline, 'Help & Support', () => NavigationHelper.navigateToHelpSupport(context)),
                  _buildMenuItem(Icons.info_outline, 'About', () => NavigationHelper.navigateToAbout(context)),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: AppTheme.errorRed, size: 22),
                      title: const Text('Logout', style: TextStyle(fontSize: 15, color: AppTheme.errorRed)),
                      onTap: () {
                        Navigator.pop(context);
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
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Add logout logic here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Logged out successfully')),
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFFFE5D0), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFFFF8C42), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF2D3748))),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
      onTap: onTap,
    );
  }

  Widget _buildDrawerTileWithToggle(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFFFE5D0), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFFFF8C42), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF2D3748))),
      trailing: Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFFFF8C42)),
    );
  }

  Widget _buildActionButton(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFE5D0), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF8C42)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3748)))),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isHighlighted = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFFFE5D0) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF8C42), size: 22),
        title: Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF2D3748))),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }



  Widget _buildPremiumBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.temple_hindu, 'Temples'),
              _buildNavItem(1, Icons.auto_awesome, 'Rituals'),
              _buildCenterNavItem(),
              _buildNavItem(3, Icons.local_florist, 'Chadavas'),
              _buildNavItem(4, Icons.person_pin, 'Personal'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.sacredBlue : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.sacredBlue : Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    final isSelected = _currentIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppTheme.sacredGradient
                    : LinearGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade500],
                      ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isSelected ? AppTheme.sacredBlue : Colors.grey)
                        .withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

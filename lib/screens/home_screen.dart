import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/featured_services.dart';
import '../widgets/home/temple_preview.dart';
import '../widgets/home/process_timeline.dart';
import '../widgets/home/testimonials_carousel.dart';
import '../services/notification_provider.dart';
import '../services/wishlist_provider.dart';
import '../utils/app_theme.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            flexibleSpace: CustomAppBar(
              title: 'Mandir Mitra',
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),
                Consumer<WishlistProvider>(
                  builder: (context, provider, child) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WishlistScreen(),
                              ),
                            );
                          },
                        ),
                        if (provider.wishlistCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                provider.wishlistCount > 9 ? '9+' : '${provider.wishlistCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                        if (provider.unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.errorRed,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                provider.unreadCount > 9 ? '9+' : '${provider.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: const [
                HeroSection(),
                FeaturedServices(),
                TemplePreview(),
                ProcessTimeline(),
                TestimonialsCarousel(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

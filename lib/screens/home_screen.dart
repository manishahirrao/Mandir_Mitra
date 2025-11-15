import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/home/greeting_header.dart';
import '../widgets/home/quick_stats_card.dart';
import '../widgets/home/hero_banner_carousel.dart';
import '../widgets/home/service_categories_grid.dart';
import '../widgets/home/featured_rituals_carousel.dart';
import '../widgets/home/trust_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.templeCream,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // A. Greeting Header
            const GreetingHeader(),
            
            // B. Quick Stats Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spaceStandard),
              child: const QuickStatsCard(),
            ),
            SizedBox(height: AppTheme.spaceLoose),
            
            // C. Hero Banner Carousel
            const HeroBannerCarousel(),
            SizedBox(height: AppTheme.spaceLoose),
            
            // D. Service Categories Grid (2x3)
            const ServiceCategoriesGrid(),
            SizedBox(height: AppTheme.sectionSpacing),
            
            // E. Featured Rituals Section
            const FeaturedRitualsCarousel(),
            SizedBox(height: AppTheme.sectionSpacing),
            
            // F. Trust Section
            const TrustSection(),
            SizedBox(height: AppTheme.sectionSpacing),
          ],
        ),
      ),
    );
  }
}

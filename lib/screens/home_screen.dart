import 'package:flutter/material.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/featured_services.dart';
import '../widgets/home/temple_preview.dart';
import '../widgets/home/process_timeline.dart';
import '../widgets/home/testimonials_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}

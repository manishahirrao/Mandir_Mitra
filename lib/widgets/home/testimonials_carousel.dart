import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../models/testimonial.dart';

class TestimonialsCarousel extends StatefulWidget {
  const TestimonialsCarousel({super.key});

  @override
  State<TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<TestimonialsCarousel> {
  final PageController _pageController = PageController();
  final List<Testimonial> _testimonials = Testimonial.getMockTestimonials();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _testimonials.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        children: [
          Text(
            'What Our Devotees Say',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.templeBrown,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: AppTheme.spaceLG),
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                return _TestimonialCard(
                  testimonial: _testimonials[index],
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _testimonials.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.divineGold
                      : AppTheme.earthTones.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(testimonial.customerPhoto),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  index < testimonial.rating ? Icons.star : Icons.star_border,
                  color: AppTheme.saffronYellow,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Text(
              '"${testimonial.text}"',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            Text(
              testimonial.customerName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.divineGold,
                  ),
            ),
            Text(
              testimonial.ritualPerformed,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

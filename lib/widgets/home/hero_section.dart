import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 500,
        width: double.infinity,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=1200',
            ),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.sacredBlue.withOpacity(0.7),
              AppTheme.sacredBlue.withOpacity(0.3),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.sacredBlue.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Connect with the Divine',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.sacredWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  Text(
                    'Authentic spiritual rituals at your fingertips',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.sacredWhite,
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceXL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.divineGold,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceXL,
                            vertical: AppTheme.spaceMD,
                          ),
                        ),
                        child: const Text('Book Your Ritual'),
                      ),
                      const SizedBox(width: AppTheme.spaceMD),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.sacredWhite,
                          side: const BorderSide(
                            color: AppTheme.sacredWhite,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceXL,
                            vertical: AppTheme.spaceMD,
                          ),
                        ),
                        child: const Text('Explore Services'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

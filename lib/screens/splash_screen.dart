import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../services/auth_provider.dart';
import 'onboarding/onboarding_screen.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
    
    // Navigate after checking auth status
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Check if user is authenticated
    final isAuthenticated = authProvider.isAuthenticated;
    
    if (!mounted) return;
    
    if (isAuthenticated) {
      // User is logged in, go to main app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      // User not logged in, show onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.sacredBlue,
              AppTheme.gangajalBlue,
              AppTheme.divineGold,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.temple_hindu,
                  size: 120,
                  color: AppTheme.sacredWhite,
                ),
                const SizedBox(height: AppTheme.spaceXL),
                Text(
                  'Mandir Mitra',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.sacredWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppTheme.spaceSM),
                Text(
                  'Your Spiritual Companion',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.sacredWhite.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

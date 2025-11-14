import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/wishlist_provider.dart';
import '../../services/auth_provider.dart';

class WishlistButton extends StatefulWidget {
  final String ritualId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const WishlistButton({
    super.key,
    required this.ritualId,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, AuthProvider>(
      builder: (context, wishlistProvider, authProvider, child) {
        final isInWishlist = wishlistProvider.isInWishlist(widget.ritualId);
        
        return GestureDetector(
          onTap: () => _handleTap(wishlistProvider, authProvider),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    size: widget.size,
                    color: isInWishlist
                        ? (widget.activeColor ?? Colors.red)
                        : (widget.inactiveColor ?? Colors.grey),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleTap(
    WishlistProvider wishlistProvider,
    AuthProvider authProvider,
  ) async {
    // Check if user is logged in
    if (!authProvider.isLoggedIn) {
      _showLoginDialog();
      return;
    }

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Animate
    await _controller.forward();
    await _controller.reverse();

    // Toggle wishlist
    final wasInWishlist = wishlistProvider.isInWishlist(widget.ritualId);
    await wishlistProvider.toggleWishlist(widget.ritualId);

    // Show snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasInWishlist ? 'Removed from Wishlist' : 'Added to Wishlist',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: wasInWishlist
              ? null
              : SnackBarAction(
                  label: 'View',
                  onPressed: () {
                    Navigator.pushNamed(context, '/wishlist');
                  },
                ),
        ),
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to save favorites'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

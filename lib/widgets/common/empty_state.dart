import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 120,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Predefined empty states
class EmptyRitualsState extends StatelessWidget {
  final VoidCallback? onBrowse;

  const EmptyRitualsState({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.temple_hindu,
      title: 'No Rituals Found',
      message: 'We couldn\'t find any rituals matching your criteria. Try adjusting your filters.',
      actionLabel: 'Browse All Rituals',
      onAction: onBrowse,
    );
  }
}

class EmptyOrdersState extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyOrdersState({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long,
      title: 'No Orders Yet',
      message: 'You haven\'t placed any orders yet. Start exploring our rituals and book your first puja.',
      actionLabel: 'Explore Rituals',
      onAction: onExplore,
    );
  }
}

class EmptyWishlistState extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyWishlistState({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'Your Wishlist is Empty',
      message: 'Save your favorite rituals here to book them later.',
      actionLabel: 'Explore Rituals',
      onAction: onExplore,
    );
  }
}

class EmptyNotificationsState extends StatelessWidget {
  const EmptyNotificationsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message: 'You\'re all caught up! We\'ll notify you about important updates.',
    );
  }
}

class EmptyReviewsState extends StatelessWidget {
  final VoidCallback? onWriteReview;

  const EmptyReviewsState({super.key, this.onWriteReview});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.rate_review,
      title: 'No Reviews Yet',
      message: 'Share your experience by writing your first review.',
      actionLabel: 'Write a Review',
      onAction: onWriteReview,
    );
  }
}

class EmptyReferralsState extends StatelessWidget {
  final VoidCallback? onShare;

  const EmptyReferralsState({super.key, this.onShare});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.people_outline,
      title: 'No Referrals Yet',
      message: 'Invite your friends and family to earn rewards together.',
      actionLabel: 'Share Referral Code',
      onAction: onShare,
    );
  }
}

class EmptyDownloadsState extends StatelessWidget {
  const EmptyDownloadsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.cloud_download,
      title: 'No Downloaded Content',
      message: 'Download rituals and content to access them offline.',
    );
  }
}

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'Try different keywords or browse our categories.',
    );
  }
}

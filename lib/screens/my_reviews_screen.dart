import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/review_provider.dart';
import '../services/rituals_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/reviews/review_card.dart';
import 'write_review_screen.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<ReviewProvider, RitualsProvider>(
        builder: (context, reviewProvider, ritualsProvider, child) {
          final myReviews = reviewProvider.getReviewsByUser('USER001');

          if (myReviews.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myReviews.length,
            itemBuilder: (context, index) {
              final review = myReviews[index];
              final ritual = ritualsProvider.rituals
                  .firstWhere((r) => r.id == review.ritualId);

              return _buildMyReviewCard(context, review, ritual, reviewProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildMyReviewCard(
    BuildContext context,
    review,
    ritual,
    ReviewProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ritual.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              ritual.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ritual.templeName),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ReviewCard(review: review),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WriteReviewScreen(
                            ritual: ritual,
                            existingReview: review,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.sacredBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(context, provider, review.id),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You haven\'t reviewed any rituals yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sacredBlue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Explore Rituals',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ReviewProvider provider, String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteReview(reviewId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}

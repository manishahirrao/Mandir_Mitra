import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../models/ritual.dart';
import '../../screens/ritual_detail_screen.dart';
import '../../services/review_provider.dart';
import '../common/wishlist_button.dart';
import '../common/star_rating.dart';

class RitualCard extends StatelessWidget {
  final Ritual ritual;

  const RitualCard({super.key, required this.ritual});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RitualDetailScreen(ritual: ritual),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    ritual.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.templeCream,
                        child: const Icon(
                          Icons.temple_hindu,
                          size: 50,
                          color: AppTheme.divineGold,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: AppTheme.spaceSM,
                  right: AppTheme.spaceSM,
                  child: WishlistButton(
                    ritualId: ritual.id,
                    size: 20,
                  ),
                ),
                Positioned(
                  bottom: AppTheme.spaceSM,
                  right: AppTheme.spaceSM,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceSM,
                      vertical: AppTheme.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.divineGold,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Text(
                      '₹${ritual.price}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.sacredWhite,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ritual.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spaceXS),
                  Text(
                    ritual.templeName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.earthTones,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Consumer<ReviewProvider>(
                    builder: (context, provider, child) {
                      final avgRating = provider.calculateAverageRating(ritual.id);
                      final reviewCount = provider.getReviewCount(ritual.id);
                      if (reviewCount == 0) return const SizedBox.shrink();
                      return Row(
                        children: [
                          StarRating(rating: avgRating, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '($reviewCount)',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spaceSM,
                        ),
                      ),
                      child: const Text('Book Now'),
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
}

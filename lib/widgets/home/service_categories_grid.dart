import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/navigation_helper.dart';

class ServiceCategoriesGrid extends StatelessWidget {
  const ServiceCategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.sacredGrey,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildServiceCard(
                context,
                '🙏',
                'Personal\nRituals',
                'Book for yourself',
                () => NavigationHelper.navigateToPersonalRitual(context),
              ),
              _buildServiceCard(
                context,
                '👥',
                'Public\nRituals',
                'Join group pujas',
                () => NavigationHelper.navigateToServices(context),
              ),
              _buildServiceCard(
                context,
                '🪔',
                'Chadhava',
                'Offer prasad',
                () => NavigationHelper.navigateToChadhava(context),
              ),
              _buildServiceCard(
                context,
                '🛕',
                'Temple\nServices',
                'Visit temples',
                () => NavigationHelper.navigateToTemples(context),
              ),
              _buildServiceCard(
                context,
                '📜',
                'Custom\nPuja',
                'Personalized rituals',
                () => NavigationHelper.navigateToPersonalRitual(context),
              ),
              _buildServiceCard(
                context,
                '🎁',
                'Loyalty\nRewards',
                'Earn points',
                () => NavigationHelper.navigateToLoyalty(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String emoji,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppTheme.templeCream,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.sacredGrey,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
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

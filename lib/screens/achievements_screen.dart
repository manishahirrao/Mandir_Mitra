import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/loyalty_provider.dart';
import '../utils/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LoyaltyProvider>(
        builder: (context, provider, child) {
          final achievements = provider.achievements;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _buildAchievementCard(achievement);
            },
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(achievement) {
    final isAchieved = achievement.isAchieved;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 48,
                color: isAchieved ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              achievement.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAchieved ? AppTheme.templeBrown : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (!isAchieved) ...[
              LinearProgressIndicator(
                value: achievement.progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.sacredBlue),
              ),
              const SizedBox(height: 4),
              Text(
                '${achievement.currentCount}/${achievement.targetCount}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ] else ...[
              const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 24),
            ],
            const SizedBox(height: 4),
            Text(
              '+${achievement.pointsReward} pts',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.divineGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

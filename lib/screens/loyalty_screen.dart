import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/loyalty_provider.dart';
import '../services/coupon_provider.dart';
import '../models/loyalty_points.dart';
import '../utils/app_theme.dart';
import 'referral_screen.dart';
import 'tier_benefits_screen.dart';
import 'achievements_screen.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty & Rewards'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showPointsHistory(context),
          ),
        ],
      ),
      body: Consumer<LoyaltyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPointsSummaryCard(provider),
                const SizedBox(height: 16),
                _buildQuickActions(),
                const SizedBox(height: 16),
                _buildEarnPointsSection(provider),
                const SizedBox(height: 16),
                _buildRedeemPointsSection(provider),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsSummaryCard(LoyaltyProvider provider) {
    final points = provider.loyaltyPoints;
    if (points == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.divineGold, Color(0xFFD4AF37)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.divineGold.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Points',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TierBenefitsScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getTierIcon(points.tier),
                      const SizedBox(width: 6),
                      Text(
                        points.getTierName(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  points.balance.toString(),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Worth ₹${points.balance}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          if (points.tier != LoyaltyTier.platinum) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress to ${_getNextTierName(points.tier)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      '${points.pointsToNextTier()} points to go',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: points.getTierProgress(),
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.card_giftcard,
              label: 'Refer & Earn',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReferralScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.emoji_events,
              label: 'Achievements',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AchievementsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppTheme.sacredBlue),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarnPointsSection(LoyaltyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ways to Earn Points',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildEarnCard('Book a ritual', '+50 points', Icons.event_available),
        _buildEarnCard('Complete first ritual', '+100 bonus', Icons.check_circle),
        _buildEarnCard('Write a review', '+20 points', Icons.rate_review),
        _buildEarnCard('Upload photos in review', '+10 points', Icons.add_photo_alternate),
        _buildEarnCard('Refer a friend', '+200 points', Icons.person_add),
        _buildEarnCard('Share on social media', '+5 points', Icons.share),
        _buildEarnCard('Daily app open', '+2 points', Icons.login),
        _buildEarnCard('Complete profile', '+50 points', Icons.account_circle),
      ],
    );
  }

  Widget _buildEarnCard(String title, String points, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.sacredBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.sacredBlue),
        ),
        title: Text(title),
        trailing: Text(
          points,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.successGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildRedeemPointsSection(LoyaltyProvider provider) {
    final rewards = provider.getAvailableRewards();
    final balance = provider.pointsBalance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Redeem Your Points',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...rewards.map((reward) => _buildRewardCard(reward, balance, provider)),
      ],
    );
  }

  Widget _buildRewardCard(
    LoyaltyReward reward,
    int balance,
    LoyaltyProvider provider,
  ) {
    final canRedeem = balance >= reward.pointsRequired;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.divineGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  reward.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reward.pointsRequired} points',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.divineGold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: canRedeem
                  ? () => _showRedeemDialog(reward, provider)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sacredBlue,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text(
                'Redeem',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTierIcon(LoyaltyTier tier) {
    switch (tier) {
      case LoyaltyTier.bronze:
        return const Icon(Icons.workspace_premium, size: 16, color: Color(0xFFCD7F32));
      case LoyaltyTier.silver:
        return const Icon(Icons.workspace_premium, size: 16, color: Color(0xFFC0C0C0));
      case LoyaltyTier.gold:
        return const Icon(Icons.workspace_premium, size: 16, color: AppTheme.divineGold);
      case LoyaltyTier.platinum:
        return const Icon(Icons.workspace_premium, size: 16, color: Color(0xFFE5E4E2));
    }
  }

  String _getNextTierName(LoyaltyTier tier) {
    switch (tier) {
      case LoyaltyTier.bronze:
        return 'Silver';
      case LoyaltyTier.silver:
        return 'Gold';
      case LoyaltyTier.gold:
        return 'Platinum';
      case LoyaltyTier.platinum:
        return 'Platinum';
    }
  }

  void _showRedeemDialog(LoyaltyReward reward, LoyaltyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Reward'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to redeem this reward?'),
            const SizedBox(height: 16),
            Text(
              reward.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(reward.description),
            const SizedBox(height: 8),
            Text(
              '${reward.pointsRequired} points will be deducted',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await provider.redeemPoints(
                reward.id,
                reward.pointsRequired,
              );
              
              if (success && context.mounted) {
                // Generate coupon
                await Provider.of<CouponProvider>(context, listen: false)
                    .generateCouponFromReward(reward.id, reward.pointsRequired);
                
                Navigator.pop(context);
                _showSuccessDialog(reward);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sacredBlue,
            ),
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(LoyaltyReward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 64,
              color: AppTheme.successGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'You have successfully redeemed ${reward.name}!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check "My Coupons" to use your reward.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sacredBlue,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showPointsHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PointsHistoryScreen(),
      ),
    );
  }
}

class PointsHistoryScreen extends StatelessWidget {
  const PointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points History'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LoyaltyProvider>(
        builder: (context, provider, child) {
          final transactions = provider.transactions;

          if (transactions.isEmpty) {
            return const Center(
              child: Text('No transactions yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isEarned = transaction.type == TransactionType.earned;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isEarned
                              ? AppTheme.successGreen
                              : AppTheme.errorRed)
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEarned ? Icons.add : Icons.remove,
                      color: isEarned
                          ? AppTheme.successGreen
                          : AppTheme.errorRed,
                    ),
                  ),
                  title: Text(transaction.activity),
                  subtitle: Text(
                    _formatDate(transaction.date),
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    '${isEarned ? '+' : '-'}${transaction.points}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEarned
                          ? AppTheme.successGreen
                          : AppTheme.errorRed,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

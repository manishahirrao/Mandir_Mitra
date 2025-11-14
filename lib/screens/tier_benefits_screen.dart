import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/loyalty_points.dart';

class TierBenefitsScreen extends StatelessWidget {
  const TierBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tier Benefits'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTierCard(
            'Bronze',
            '0-500 points',
            const Color(0xFFCD7F32),
            [
              'Basic rewards access',
              'Standard support',
            ],
          ),
          _buildTierCard(
            'Silver',
            '501-1500 points',
            const Color(0xFFC0C0C0),
            [
              '5% extra points on bookings',
              'Priority email support',
              'Birthday bonus (50 pts)',
            ],
          ),
          _buildTierCard(
            'Gold',
            '1501-3000 points',
            AppTheme.divineGold,
            [
              '10% extra points',
              'Exclusive offers',
              'Free Aashirwad box upgrade once/month',
              'Priority WhatsApp support',
            ],
          ),
          _buildTierCard(
            'Platinum',
            '3000+ points',
            const Color(0xFFE5E4E2),
            [
              '15% extra points',
              'Early access to new rituals',
              'Personal spiritual advisor consultation (free once/quarter)',
              'Dedicated support line',
              'Premium Aashirwad boxes',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(String name, String range, Color color, List<String> benefits) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium, color: color, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      range,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(benefit)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

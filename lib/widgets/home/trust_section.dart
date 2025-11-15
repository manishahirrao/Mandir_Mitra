import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.templeCream,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldenAccent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Why Choose Mandir Mitra?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.sacredGrey,
            ),
          ),
          const SizedBox(height: 24),
          _buildTrustItem('✓', '50+ Verified Temples'),
          const SizedBox(height: 16),
          _buildTrustItem('✓', '100+ Qualified Priests'),
          const SizedBox(height: 16),
          _buildTrustItem('✓', '10,000+ Rituals Completed'),
          const SizedBox(height: 16),
          _buildTrustItem('✓', '4.9★ Average Rating'),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.sacredBlue,
              side: const BorderSide(color: AppTheme.sacredBlue, width: 2),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Learn More About Us',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem(String icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              icon,
              style: const TextStyle(
                color: AppTheme.successGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.sacredGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

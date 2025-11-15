import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class FeaturedRitualsCarousel extends StatelessWidget {
  const FeaturedRitualsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Rituals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.sacredGrey,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All →'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildRitualCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRitualCard(int index) {
    final rituals = [
      {'name': 'Maa Kali Puja', 'price': '₹301', 'rating': '4.8'},
      {'name': 'Rudra Abhishek', 'price': '₹501', 'rating': '4.9'},
      {'name': 'Ganesh Puja', 'price': '₹401', 'rating': '4.7'},
      {'name': 'Lakshmi Puja', 'price': '₹351', 'rating': '4.8'},
      {'name': 'Hanuman Puja', 'price': '₹251', 'rating': '4.9'},
    ];

    final ritual = rituals[index];

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.sacredGradient,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.temple_hindu,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ritual['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.sacredGrey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppTheme.goldenAccent),
                    const SizedBox(width: 4),
                    Text(
                      ritual['rating']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ritual['price']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.sacredBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

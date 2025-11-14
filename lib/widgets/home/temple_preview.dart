import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class TemplePreview extends StatelessWidget {
  const TemplePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              
              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildImage(),
                    ),
                    const SizedBox(width: AppTheme.spaceLG),
                    Expanded(
                      flex: 6,
                      child: _buildContent(context),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildImage(),
                    const SizedBox(height: AppTheme.spaceLG),
                    _buildContent(context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      child: Image.network(
        'https://images.unsplash.com/photo-1609619385002-f40f5e5c73b0?w=600',
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Kalighat Temple',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.templeBrown,
              ),
        ),
        const SizedBox(height: AppTheme.spaceMD),
        Text(
          'One of the 51 Shakti Peethas, Kalighat Temple is a sacred Hindu temple dedicated to Goddess Kali. Located in Kolkata, this ancient temple has been a center of devotion for centuries, attracting millions of devotees seeking blessings and spiritual fulfillment.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppTheme.spaceLG),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Meet Our Temple Partners'),
        ),
      ],
    );
  }
}

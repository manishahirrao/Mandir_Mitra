import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class FeaturedServices extends StatelessWidget {
  const FeaturedServices({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'icon': Icons.auto_awesome,
        'name': 'Daily Deity Worship',
        'description': 'Regular pujas and offerings to your chosen deity',
      },
      {
        'icon': Icons.celebration,
        'name': 'Special Occasions',
        'description': 'Festivals, birthdays, and auspicious ceremonies',
      },
      {
        'icon': Icons.spa,
        'name': 'Personal Benefits',
        'description': 'Rituals for health, wealth, and prosperity',
      },
      {
        'icon': Icons.temple_hindu,
        'name': 'Temple Offerings',
        'description': 'Donations and offerings at sacred temples',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.templeBrown,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: AppTheme.spaceLG),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return _ServiceCard(
                  icon: service['icon'] as IconData,
                  name: service['name'] as String,
                  description: service['description'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.name,
    required this.description,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        margin: const EdgeInsets.only(right: AppTheme.spaceMD),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceMD),
                    decoration: BoxDecoration(
                      color: AppTheme.divineGold.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 40,
                      color: AppTheme.divineGold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Learn More'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class ProcessTimeline extends StatelessWidget {
  const ProcessTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'icon': Icons.calendar_today,
        'title': 'Booking',
        'description': 'Choose your ritual and select date & time',
      },
      {
        'icon': Icons.temple_hindu,
        'title': 'Ritual Preparation',
        'description': 'Our pandits prepare for your sacred ceremony',
      },
      {
        'icon': Icons.videocam,
        'title': 'Live Streaming',
        'description': 'Watch your ritual performed live',
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'Aashirwad Box',
        'description': 'Receive prasad and sacred items at home',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        children: [
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.templeBrown,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: AppTheme.spaceXL),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              
              if (isWide) {
                return Row(
                  children: List.generate(
                    steps.length,
                    (index) => Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _StepCard(
                              icon: steps[index]['icon'] as IconData,
                              title: steps[index]['title'] as String,
                              description: steps[index]['description'] as String,
                              stepNumber: index + 1,
                            ),
                          ),
                          if (index < steps.length - 1)
                            Container(
                              width: 40,
                              height: 2,
                              color: AppTheme.saffronYellow,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Column(
                  children: List.generate(
                    steps.length,
                    (index) => Column(
                      children: [
                        _StepCard(
                          icon: steps[index]['icon'] as IconData,
                          title: steps[index]['title'] as String,
                          description: steps[index]['description'] as String,
                          stepNumber: index + 1,
                        ),
                        if (index < steps.length - 1)
                          Container(
                            width: 2,
                            height: 40,
                            color: AppTheme.saffronYellow,
                            margin: const EdgeInsets.symmetric(
                              vertical: AppTheme.spaceSM,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int stepNumber;

  const _StepCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.saffronYellow.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.saffronYellow,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: 40,
            color: AppTheme.saffronYellow,
          ),
        ),
        const SizedBox(height: AppTheme.spaceMD),
        Text(
          'Step $stepNumber',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.saffronYellow,
              ),
        ),
        const SizedBox(height: AppTheme.spaceXS),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spaceXS),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

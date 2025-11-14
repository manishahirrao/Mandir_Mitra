import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../services/rituals_provider.dart';
import 'ritual_card.dart';

class RitualGrid extends StatelessWidget {
  const RitualGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RitualsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.divineGold,
            ),
          );
        }

        if (provider.rituals.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: AppTheme.earthTones.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppTheme.spaceLG),
                  Text(
                    'No rituals found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spaceSM),
                  Text(
                    'Try adjusting your filters',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.earthTones,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spaceLG),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearFilters();
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 2;

            return GridView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.75,
                crossAxisSpacing: AppTheme.spaceMD,
                mainAxisSpacing: AppTheme.spaceMD,
              ),
              itemCount: provider.rituals.length,
              itemBuilder: (context, index) {
                return RitualCard(ritual: provider.rituals[index]);
              },
            );
          },
        );
      },
    );
  }
}

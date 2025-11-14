import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../services/rituals_provider.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RitualsProvider>(
      builder: (context, provider, child) {
        final deities = [
          'Maa Kali',
          'Maa Tara',
          'Maa Shodashi',
          'Maa Bhuvaneshwari',
          'Maa Bagalamukhi',
          'Ram Janmabhoomi',
        ];

        return Container(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceLG),
              Text(
                'Deity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spaceSM),
              Wrap(
                spacing: AppTheme.spaceSM,
                children: deities.map((deity) {
                  final isSelected = provider.selectedDeities.contains(deity);
                  return FilterChip(
                    label: Text(deity),
                    selected: isSelected,
                    onSelected: (selected) {
                      provider.toggleDeity(deity);
                    },
                    backgroundColor: AppTheme.sacredWhite,
                    selectedColor: AppTheme.divineGold,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.sacredWhite
                          : AppTheme.sacredGrey,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTheme.spaceLG),
              Text(
                'Price Range',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spaceSM),
              RangeSlider(
                values: RangeValues(provider.minPrice, provider.maxPrice),
                min: 301,
                max: 5001,
                divisions: 47,
                labels: RangeLabels(
                  '₹${provider.minPrice.round()}',
                  '₹${provider.maxPrice.round()}',
                ),
                activeColor: AppTheme.divineGold,
                onChanged: (values) {
                  provider.setPriceRange(values.start, values.end);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹${provider.minPrice.round()}'),
                  Text('₹${provider.maxPrice.round()}'),
                ],
              ),
              const SizedBox(height: AppTheme.spaceXL),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        provider.clearFilters();
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}

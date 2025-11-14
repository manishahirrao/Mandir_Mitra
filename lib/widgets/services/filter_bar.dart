import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../services/rituals_provider.dart';
import 'filter_bottom_sheet.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RitualsProvider>(
      builder: (context, provider, child) {
        final categories = [
          'All',
          'Daily Deity Worship',
          'Special Occasions',
          'Personal Benefits',
          'Astrological Doshas',
          'Temple Offerings',
        ];

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSM),
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMD,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = provider.selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spaceSM),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          provider.setCategory(category);
                        },
                        backgroundColor: AppTheme.sacredWhite,
                        selectedColor: AppTheme.divineGold,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.sacredWhite
                              : AppTheme.sacredGrey,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.divineGold
                              : AppTheme.sacredGrey.withOpacity(0.3),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusLG),
                      ),
                    ),
                    builder: (context) => const FilterBottomSheet(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

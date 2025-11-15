import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildCategoryChip(category, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.primaryOrange, AppTheme.secondaryOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[100],
              ),
              child: Center(
                child: Text(
                  _getCategoryIcon(category),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _getCategoryShortName(category),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'All':
        return '🙏';
      case 'Daily Deity':
        return '🕉️';
      case 'Ekadashi':
        return '🌙';
      case 'Gauseva':
        return '🐄';
      case 'Success & Growth':
        return '📈';
      case 'Health & Healing':
        return '💚';
      default:
        return '🙏';
    }
  }

  String _getCategoryShortName(String category) {
    if (category.length <= 10) return category;
    
    switch (category) {
      case 'Success & Growth':
        return 'Success';
      case 'Health & Healing':
        return 'Health';
      default:
        return category;
    }
  }
}

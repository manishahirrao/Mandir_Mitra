import 'package:flutter/material.dart';
import '../../models/chadhava.dart';
import '../../utils/app_theme.dart';

class OfferingSelector extends StatelessWidget {
  final List<OfferingType> offerings;
  final List<String> selectedOfferings;
  final Function(List<String>) onSelectionChanged;

  const OfferingSelector({
    Key? key,
    required this.offerings,
    required this.selectedOfferings,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: offerings.length,
      itemBuilder: (context, index) {
        final offering = offerings[index];
        final isSelected = selectedOfferings.contains(offering.id);
        final isDefault = offering.isDefault;
        
        return GestureDetector(
          onTap: isDefault
              ? null
              : () {
                  final newSelection = List<String>.from(selectedOfferings);
                  if (isSelected) {
                    newSelection.remove(offering.id);
                  } else {
                    newSelection.add(offering.id);
                  }
                  onSelectionChanged(newSelection);
                },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryOrange.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Text(
                      offering.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    if (isSelected && !isDefault)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    if (isDefault)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  offering.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryOrange : Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (offering.price > 0)
                  Text(
                    isDefault ? 'Included' : '+₹${offering.price.toInt()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDefault ? Colors.green[700] : Colors.grey[600],
                      fontWeight: isDefault ? FontWeight.w600 : FontWeight.normal,
                    ),
                  )
                else
                  Text(
                    'Free',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

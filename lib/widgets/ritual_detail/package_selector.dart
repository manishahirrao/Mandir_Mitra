import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PackageSelector extends StatefulWidget {
  final Function(String, double) onPackageSelected;

  const PackageSelector({super.key, required this.onPackageSelected});

  @override
  State<PackageSelector> createState() => _PackageSelectorState();
}

class _PackageSelectorState extends State<PackageSelector> {
  String _selectedPackage = 'Family Package';

  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'Shared Package',
      'price': 301.0,
      'participants': 10,
      'benefits': 'Shared blessings with other devotees',
    },
    {
      'name': 'Family Package',
      'price': 501.0,
      'participants': 6,
      'benefits': 'Perfect for family occasions',
    },
    {
      'name': 'Personal Package',
      'price': 1001.0,
      'participants': 3,
      'benefits': 'Exclusive personal ritual',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Package',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        ...List.generate(_packages.length, (index) {
          final package = _packages[index];
          final isSelected = _selectedPackage == package['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPackage = package['name'];
              });
              widget.onPackageSelected(
                package['name'],
                package['price'],
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.divineGold.withOpacity(0.1)
                    : AppTheme.sacredWhite,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.divineGold
                      : AppTheme.earthTones.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: package['name'],
                    groupValue: _selectedPackage,
                    onChanged: (value) {
                      setState(() {
                        _selectedPackage = value!;
                      });
                      widget.onPackageSelected(
                        package['name'],
                        package['price'],
                      );
                    },
                    activeColor: AppTheme.divineGold,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package['name'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spaceXS),
                        Text(
                          '₹${package['price']}/person • ${package['participants']} participants',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppTheme.spaceXS),
                        Text(
                          package['benefits'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.earthTones,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

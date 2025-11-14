import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../services/rituals_provider.dart';
import '../widgets/services/filter_bar.dart';
import '../widgets/services/ritual_grid.dart';
import 'custom_order_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<RitualsProvider>().setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            decoration: const BoxDecoration(
              gradient: AppTheme.sacredGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: AppTheme.sacredWhite),
                decoration: InputDecoration(
                  hintText: 'Search rituals, deities, temples...',
                  hintStyle: TextStyle(
                    color: AppTheme.sacredWhite.withOpacity(0.7),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.sacredWhite,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppTheme.sacredWhite,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            context.read<RitualsProvider>().setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppTheme.sacredWhite.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMD,
                    vertical: AppTheme.spaceSM,
                  ),
                ),
              ),
            ),
          ),

          // Filter Bar
          const FilterBar(),

          // Ritual Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<RitualsProvider>().refreshRituals();
              },
              color: AppTheme.divineGold,
              child: const RitualGrid(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomOrderScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.sacredBlue,
        icon: const Icon(Icons.add),
        label: const Text('Custom Ritual'),
      ),
    );
  }
}


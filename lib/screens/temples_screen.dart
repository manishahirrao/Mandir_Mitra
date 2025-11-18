import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/temple_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/temples/temple_card.dart';
import '../widgets/temples/featured_temple_spotlight.dart';
import '../widgets/temples/temple_category_filter.dart';
import 'temple_detail_screen.dart';
import 'temple_comparison_screen.dart';

class TemplesScreen extends StatefulWidget {
  const TemplesScreen({super.key});

  @override
  State<TemplesScreen> createState() => _TemplesScreenState();
}

class _TemplesScreenState extends State<TemplesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TempleProvider>().loadTemples();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      body: SafeArea(
        child: Consumer<TempleProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(provider.error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.loadTemples(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // Featured Temple Spotlight
                      if (provider.featuredTemple != null)
                        SliverToBoxAdapter(
                          child: FeaturedTempleSpotlight(
                            temple: provider.featuredTemple!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TempleDetailScreen(
                                    temple: provider.featuredTemple!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // Category Filter
                      SliverToBoxAdapter(
                        child: TempleCategoryFilter(
                          categories: provider.categories,
                          selectedCategory: provider.selectedCategory,
                          onCategorySelected: (category) {
                            provider.setCategory(category);
                          },
                        ),
                      ),

                      // Section Title
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getSectionTitle(provider.selectedCategory),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (provider.comparisonList.isNotEmpty)
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TempleComparisonScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.compare_arrows),
                                  label: Text('Compare (${provider.comparisonList.length})'),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Temple Grid
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final temple = _getFilteredTemples(provider)[index];
                              return TempleCard(
                                temple: temple,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TempleDetailScreen(
                                        temple: temple,
                                      ),
                                    ),
                                  );
                                },
                                onCompareToggle: () {
                                  if (provider.comparisonList.any((t) => t.id == temple.id)) {
                                    provider.removeFromComparison(temple);
                                  } else {
                                    provider.addToComparison(temple);
                                  }
                                },
                                isInComparison: provider.comparisonList.any((t) => t.id == temple.id),
                              );
                            },
                            childCount: _getFilteredTemples(provider).length,
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 24),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  String _getSectionTitle(String category) {
    if (category == 'All Temples') return 'All Temples';
    return category;
  }

  List _getFilteredTemples(TempleProvider provider) {
    var temples = provider.filteredTemples;
    
    if (_searchQuery.isNotEmpty) {
      temples = temples.where((t) {
        return t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (t.presidingDeity?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    
    return temples;
  }
}

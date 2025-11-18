import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chadhava_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/chadhava/category_filter.dart';
import '../widgets/chadhava/featured_banner.dart';
import '../widgets/chadhava/chadhava_card.dart';
import 'chadhava_detail_screen.dart';
import 'multi_temple_chadhava_screen.dart';

class ChadhavaScreen extends StatefulWidget {
  const ChadhavaScreen({Key? key}) : super(key: key);

  @override
  State<ChadhavaScreen> createState() => _ChadhavaScreenState();
}

class _ChadhavaScreenState extends State<ChadhavaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChadhavaProvider>().loadChadhavas();
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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<ChadhavaProvider>(
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
                            onPressed: () => provider.loadChadhavas(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // Category Filter
                      SliverToBoxAdapter(
                        child: CategoryFilter(
                          categories: provider.categories,
                          selectedCategory: provider.selectedCategory,
                          onCategorySelected: (category) {
                            provider.setCategory(category);
                          },
                        ),
                      ),

                      // Featured Banner
                      if (provider.multiTempleChadhavas.isNotEmpty)
                        SliverToBoxAdapter(
                          child: FeaturedBanner(
                            multiTempleChadhava: provider.multiTempleChadhavas.first,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiTempleChadhavaScreen(
                                    multiTempleChadhava: provider.multiTempleChadhavas.first,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // Section Title
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _getSectionTitle(provider.selectedCategory),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Chadhava Grid
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final chadhava = _getFilteredChadhavas(provider)[index];
                              return ChadhavaCard(
                                chadhava: chadhava,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChadhavaDetailScreen(
                                        chadhava: chadhava,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: _getFilteredChadhavas(provider).length,
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
    switch (category) {
      case 'All':
        return 'All Chadhava';
      case 'Daily Deity':
        return 'Daily Deity Chadhava';
      case 'Ekadashi':
        return 'Ekadashi Special';
      case 'Gauseva':
        return 'Gauseva Offerings';
      case 'Success & Growth':
        return 'Success & Growth';
      case 'Health & Healing':
        return 'Health & Healing';
      default:
        return category;
    }
  }

  List _getFilteredChadhavas(ChadhavaProvider provider) {
    var chadhavas = provider.filteredChadhavas;
    
    if (_searchQuery.isNotEmpty) {
      chadhavas = chadhavas.where((c) {
        return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.deityName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return chadhavas;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/search_provider.dart';
import '../services/rituals_provider.dart';
import '../models/ritual.dart';
import '../utils/app_theme.dart';
import '../widgets/services/ritual_card.dart';
import 'ritual_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    provider.setQuery(_searchController.text);
    setState(() {
      _showSuggestions = _searchController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.sacredBlue,
        title: _buildSearchBar(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (_searchController.text.isEmpty) {
            return _buildSearchSuggestions(provider);
          }

          if (_showSuggestions && provider.getSuggestions().isNotEmpty) {
            return _buildAutoComplete(provider);
          }

          return Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppTheme.sacredBlue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.sacredBlue,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Rituals'),
                  Tab(text: 'Blog Posts'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllTab(provider),
                    _buildRitualsTab(provider),
                    _buildBlogPostsTab(provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search rituals, temples, deities...',
        hintStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _showSuggestions = false;
                  });
                },
              )
            : const Icon(Icons.mic, color: Colors.white70),
      ),
    );
  }

  Widget _buildSearchSuggestions(SearchProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.templeBrown,
                  ),
                ),
                TextButton(
                  onPressed: () => provider.clearSearchHistory(),
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...provider.searchHistory.map((query) {
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => provider.removeFromHistory(query),
                ),
                onTap: () {
                  _searchController.text = query;
                  provider.setQuery(query);
                  setState(() {
                    _showSuggestions = false;
                  });
                },
              );
            }),
            const SizedBox(height: 24),
          ],
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.popularSearches.map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () {
                  _searchController.text = search;
                  provider.setQuery(search);
                  provider.saveSearchHistory(search);
                  setState(() {
                    _showSuggestions = false;
                  });
                },
                backgroundColor: AppTheme.sacredBlue.withOpacity(0.1),
                labelStyle: const TextStyle(color: AppTheme.sacredBlue),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoComplete(SearchProvider provider) {
    final suggestions = provider.getSuggestions();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: AppTheme.sacredBlue),
          title: Text(suggestion),
          onTap: () {
            _searchController.text = suggestion;
            provider.setQuery(suggestion);
            provider.saveSearchHistory(suggestion);
            setState(() {
              _showSuggestions = false;
            });
          },
        );
      },
    );
  }

  Widget _buildAllTab(SearchProvider provider) {
    final rituals = provider.searchRituals().take(3).toList();
    final blogPosts = provider.searchBlogPosts().take(2).toList();

    if (rituals.isEmpty && blogPosts.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rituals.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rituals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.templeBrown,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...rituals.map((ritual) => _buildRitualCard(ritual)),
          ],
          if (blogPosts.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Blog Posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.templeBrown,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(2),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...blogPosts.map((post) => ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.excerpt, maxLines: 2),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildRitualsTab(SearchProvider provider) {
    final rituals = provider.searchRituals();

    if (rituals.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSortBar(provider),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: rituals.length,
            itemBuilder: (context, index) {
              return RitualCard(ritual: rituals[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBlogPostsTab(SearchProvider provider) {
    final posts = provider.searchBlogPosts();

    if (posts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(post.excerpt, maxLines: 2),
                const SizedBox(height: 4),
                Text(
                  '${post.category} • ${post.readTime} min read',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildSortBar(SearchProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Relevance', 'relevance', provider),
                  _buildSortChip('Price: Low', 'price_low', provider),
                  _buildSortChip('Price: High', 'price_high', provider),
                  _buildSortChip('Popular', 'popularity', provider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value, SearchProvider provider) {
    final isSelected = provider.filters.sortBy == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          provider.setFilters(provider.filters.copyWith(sortBy: value));
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.sacredBlue.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.sacredBlue : Colors.black87,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRitualCard(Ritual ritual) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            ritual.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image),
            ),
          ),
        ),
        title: Text(ritual.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹${ritual.price.toStringAsFixed(0)}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RitualDetailScreen(ritual: ritual),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

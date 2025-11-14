import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ritual.dart';
import '../models/blog_post.dart';
import 'rituals_provider.dart';
import 'blog_provider.dart';

class SearchFilters {
  final List<String> categories;
  final List<String> deities;
  final double minPrice;
  final double maxPrice;
  final String? packageType;
  final List<String> temples;
  final double? minRating;
  final String sortBy;

  SearchFilters({
    this.categories = const [],
    this.deities = const [],
    this.minPrice = 301,
    this.maxPrice = 5001,
    this.packageType,
    this.temples = const [],
    this.minRating,
    this.sortBy = 'relevance',
  });

  int get activeFilterCount {
    int count = 0;
    if (categories.isNotEmpty) count++;
    if (deities.isNotEmpty) count++;
    if (minPrice != 301 || maxPrice != 5001) count++;
    if (packageType != null) count++;
    if (temples.isNotEmpty) count++;
    if (minRating != null) count++;
    if (sortBy != 'relevance') count++;
    return count;
  }

  SearchFilters copyWith({
    List<String>? categories,
    List<String>? deities,
    double? minPrice,
    double? maxPrice,
    String? packageType,
    List<String>? temples,
    double? minRating,
    String? sortBy,
  }) {
    return SearchFilters(
      categories: categories ?? this.categories,
      deities: deities ?? this.deities,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      packageType: packageType ?? this.packageType,
      temples: temples ?? this.temples,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  SearchFilters clear() {
    return SearchFilters();
  }
}

class SearchProvider with ChangeNotifier {
  final RitualsProvider _ritualsProvider;
  final BlogProvider _blogProvider;
  
  String _query = '';
  SearchFilters _filters = SearchFilters();
  List<String> _searchHistory = [];
  bool _isLoading = false;

  SearchProvider(this._ritualsProvider, this._blogProvider) {
    _loadSearchHistory();
  }

  String get query => _query;
  SearchFilters get filters => _filters;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;

  final List<String> popularSearches = [
    'Maa Kali Puja',
    'Ram Janmabhoomi',
    'Wedding Rituals',
    'Shanti Puja',
    'Astrology Remedies',
    'Lakshmi Puja',
    'Ganesh Puja',
    'Navratri Special',
  ];

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void setFilters(SearchFilters filters) {
    _filters = filters;
    notifyListeners();
  }

  void clearFilters() {
    _filters = SearchFilters();
    notifyListeners();
  }

  List<Ritual> searchRituals() {
    var results = _ritualsProvider.rituals;

    // Filter by query
    if (_query.isNotEmpty) {
      results = results.where((ritual) {
        final queryLower = _query.toLowerCase();
        return ritual.name.toLowerCase().contains(queryLower) ||
            ritual.description.toLowerCase().contains(queryLower) ||
            ritual.deity.toLowerCase().contains(queryLower) ||
            ritual.templeName.toLowerCase().contains(queryLower) ||
            ritual.category.toLowerCase().contains(queryLower);
      }).toList();
    }

    // Apply filters
    if (_filters.categories.isNotEmpty) {
      results = results.where((r) => _filters.categories.contains(r.category)).toList();
    }

    if (_filters.deities.isNotEmpty) {
      results = results.where((r) => _filters.deities.contains(r.deity)).toList();
    }

    results = results.where((r) => 
      r.price >= _filters.minPrice && r.price <= _filters.maxPrice
    ).toList();

    // Sort results
    switch (_filters.sortBy) {
      case 'price_low':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'popularity':
        results.sort((a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
        break;
      case 'newest':
        results = results.reversed.toList();
        break;
    }

    return results;
  }

  List<BlogPost> searchBlogPosts() {
    if (_query.isEmpty) return [];

    final queryLower = _query.toLowerCase();
    return _blogProvider.posts.where((post) {
      return post.title.toLowerCase().contains(queryLower) ||
          post.excerpt.toLowerCase().contains(queryLower) ||
          post.content.toLowerCase().contains(queryLower) ||
          post.category.toLowerCase().contains(queryLower);
    }).toList();
  }

  List<String> getSuggestions() {
    if (_query.isEmpty) return [];

    final queryLower = _query.toLowerCase();
    final suggestions = <String>{};

    // Add matching ritual names
    for (var ritual in _ritualsProvider.rituals) {
      if (ritual.name.toLowerCase().contains(queryLower)) {
        suggestions.add(ritual.name);
      }
      if (ritual.deity.toLowerCase().contains(queryLower)) {
        suggestions.add(ritual.deity);
      }
      if (ritual.templeName.toLowerCase().contains(queryLower)) {
        suggestions.add(ritual.templeName);
      }
    }

    return suggestions.take(8).toList();
  }

  Future<void> saveSearchHistory(String query) async {
    if (query.isEmpty) return;

    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.take(10).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
    notifyListeners();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList('search_history') ?? [];
    notifyListeners();
  }

  Future<void> clearSearchHistory() async {
    _searchHistory = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    notifyListeners();
  }

  Future<void> removeFromHistory(String query) async {
    _searchHistory.remove(query);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
    notifyListeners();
  }
}

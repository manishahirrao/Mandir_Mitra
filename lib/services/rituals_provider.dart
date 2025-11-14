import 'package:flutter/foundation.dart';
import '../models/ritual.dart';

class RitualsProvider with ChangeNotifier {
  List<Ritual> _allRituals = [];
  List<Ritual> _filteredRituals = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _selectedDeities = [];
  double _minPrice = 301;
  double _maxPrice = 5001;

  List<Ritual> get rituals => _filteredRituals;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get selectedDeities => _selectedDeities;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  RitualsProvider() {
    loadRituals();
  }

  Future<void> loadRituals() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _allRituals = Ritual.getMockRituals();
    _filteredRituals = List.from(_allRituals);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshRituals() async {
    await loadRituals();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void toggleDeity(String deity) {
    if (_selectedDeities.contains(deity)) {
      _selectedDeities.remove(deity);
    } else {
      _selectedDeities.add(deity);
    }
    _applyFilters();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _selectedDeities.clear();
    _minPrice = 301;
    _maxPrice = 5001;
    _searchQuery = '';
    _applyFilters();
  }

  void toggleFavorite(String ritualId) {
    final ritual = _allRituals.firstWhere((r) => r.id == ritualId);
    ritual.isFavorite = !ritual.isFavorite;
    notifyListeners();
  }

  void _applyFilters() {
    _filteredRituals = _allRituals.where((ritual) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!ritual.name.toLowerCase().contains(query) &&
            !ritual.deity.toLowerCase().contains(query) &&
            !ritual.templeName.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != 'All' && ritual.category != _selectedCategory) {
        return false;
      }

      // Deity filter
      if (_selectedDeities.isNotEmpty &&
          !_selectedDeities.contains(ritual.deity)) {
        return false;
      }

      // Price filter
      if (ritual.price < _minPrice || ritual.price > _maxPrice) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<Ritual> get featuredRituals {
    return _allRituals.where((r) => r.featured).take(4).toList();
  }
}

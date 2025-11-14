import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/wishlist.dart';
import '../models/ritual.dart';

class WishlistProvider with ChangeNotifier {
  List<WishlistItem> _wishlistItems = [];
  final String _userId = 'USER001'; // Mock user ID
  bool _isLoading = false;

  WishlistProvider() {
    _loadWishlist();
  }

  List<WishlistItem> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  int get wishlistCount => _wishlistItems.length;

  List<String> get wishlistRitualIds =>
      _wishlistItems.map((item) => item.ritualId).toList();

  bool isInWishlist(String ritualId) {
    return _wishlistItems.any((item) => item.ritualId == ritualId);
  }

  Future<void> _loadWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = prefs.getString('wishlist_$_userId');
      
      if (wishlistJson != null) {
        final List<dynamic> decoded = json.decode(wishlistJson);
        _wishlistItems = decoded
            .map((item) => WishlistItem.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = json.encode(
        _wishlistItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('wishlist_$_userId', wishlistJson);
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  Future<bool> addToWishlist(String ritualId) async {
    if (isInWishlist(ritualId)) {
      return false;
    }

    final newItem = WishlistItem(
      id: 'WL${DateTime.now().millisecondsSinceEpoch}',
      userId: _userId,
      ritualId: ritualId,
      addedAt: DateTime.now(),
    );

    _wishlistItems.add(newItem);
    await _saveWishlist();
    notifyListeners();
    return true;
  }

  Future<bool> removeFromWishlist(String ritualId) async {
    final initialLength = _wishlistItems.length;
    _wishlistItems.removeWhere((item) => item.ritualId == ritualId);
    
    if (_wishlistItems.length < initialLength) {
      await _saveWishlist();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> toggleWishlist(String ritualId) async {
    if (isInWishlist(ritualId)) {
      await removeFromWishlist(ritualId);
    } else {
      await addToWishlist(ritualId);
    }
  }

  Future<void> removeMultiple(List<String> ritualIds) async {
    _wishlistItems.removeWhere((item) => ritualIds.contains(item.ritualId));
    await _saveWishlist();
    notifyListeners();
  }

  Future<void> clearWishlist() async {
    _wishlistItems.clear();
    await _saveWishlist();
    notifyListeners();
  }

  List<Ritual> getWishlistRituals(List<Ritual> allRituals) {
    return allRituals
        .where((ritual) => isInWishlist(ritual.id))
        .toList();
  }

  void sortByRecentlyAdded() {
    _wishlistItems.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    notifyListeners();
  }

  void sortByPriceLowToHigh(List<Ritual> allRituals) {
    final ritualMap = {for (var r in allRituals) r.id: r};
    _wishlistItems.sort((a, b) {
      final priceA = ritualMap[a.ritualId]?.price ?? 0;
      final priceB = ritualMap[b.ritualId]?.price ?? 0;
      return priceA.compareTo(priceB);
    });
    notifyListeners();
  }

  void sortByPriceHighToLow(List<Ritual> allRituals) {
    final ritualMap = {for (var r in allRituals) r.id: r};
    _wishlistItems.sort((a, b) {
      final priceA = ritualMap[a.ritualId]?.price ?? 0;
      final priceB = ritualMap[b.ritualId]?.price ?? 0;
      return priceB.compareTo(priceA);
    });
    notifyListeners();
  }

  void sortByName(List<Ritual> allRituals) {
    final ritualMap = {for (var r in allRituals) r.id: r};
    _wishlistItems.sort((a, b) {
      final nameA = ritualMap[a.ritualId]?.name ?? '';
      final nameB = ritualMap[b.ritualId]?.name ?? '';
      return nameA.compareTo(nameB);
    });
    notifyListeners();
  }

  Future<void> syncWithServer() async {
    // Mock sync - in production, this would sync with backend
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user.dart';
import '../config/supabase_config.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  List<SavedAddress> _addresses = [];
  List<String> _wishlist = [];
  bool _isLoading = false;

  UserProvider() {
    _initializeUser();
  }

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  List<SavedAddress> get addresses => _addresses;
  List<String> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  Future<void> _initializeUser() async {
    final currentUser = SupabaseConfig.client.auth.currentUser;
    if (currentUser != null) {
      await loadUserProfile(currentUser.id);
    }
  }

  Future<void> loadUserProfile(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      _user = User(
        id: response['id'],
        fullName: response['full_name'] ?? '',
        email: response['email'] ?? '',
        phone: response['phone'],
        profilePhoto: response['profile_cloudinary_id'],
        isVerified: response['is_verified'] ?? false,
        createdAt: DateTime.parse(response['created_at']),
        updatedAt: DateTime.parse(response['updated_at']),
      );

      _isLoggedIn = true;
      
      // Load user's addresses and wishlist
      await _loadAddresses(userId);
      await _loadWishlist(userId);
      
    } catch (e) {
      print('Error loading user profile: $e');
      _user = null;
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAddresses(String userId) async {
    try {
      // TODO: Implement address loading from Supabase
      // For now, use empty list
      _addresses = [];
    } catch (e) {
      print('Error loading addresses: $e');
    }
  }

  Future<void> _loadWishlist(String userId) async {
    try {
      final response = await SupabaseConfig.client
          .from('wishlist')
          .select('ritual_id')
          .eq('user_id', userId);

      _wishlist = (response as List).map((item) => item['ritual_id'] as String).toList();
    } catch (e) {
      print('Error loading wishlist: $e');
      _wishlist = [];
    }
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _user = null;
    _addresses = [];
    _wishlist = [];
    notifyListeners();
  }

  void addToWishlist(String ritualId) {
    if (!_wishlist.contains(ritualId)) {
      _wishlist.add(ritualId);
      notifyListeners();
    }
  }

  void removeFromWishlist(String ritualId) {
    _wishlist.remove(ritualId);
    notifyListeners();
  }

  bool isInWishlist(String ritualId) {
    return _wishlist.contains(ritualId);
  }

  void addAddress(SavedAddress address) {
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(SavedAddress address) {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
      notifyListeners();
    }
  }

  void deleteAddress(String addressId) {
    _addresses.removeWhere((a) => a.id == addressId);
    notifyListeners();
  }
}

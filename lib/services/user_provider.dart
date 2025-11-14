import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = true;
  List<SavedAddress> _addresses = [];
  List<String> _wishlist = [];

  UserProvider() {
    _loadMockUser();
  }

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  List<SavedAddress> get addresses => _addresses;
  List<String> get wishlist => _wishlist;

  void _loadMockUser() {
    _user = User(
      id: 'USER001',
      name: 'Rajesh Kumar',
      email: 'rajesh.kumar@example.com',
      phone: '+91 98765 43210',
      profilePhoto: 'https://i.pravatar.cc/300?img=33',
      dateOfBirth: DateTime(1985, 5, 15),
      gender: 'Male',
      isPhoneVerified: true,
      isEmailVerified: true,
    );

    _addresses = [
      SavedAddress(
        id: 'ADDR001',
        label: 'Home',
        addressLine1: '123, MG Road',
        addressLine2: 'Koramangala',
        city: 'Bangalore',
        state: 'Karnataka',
        pincode: '560034',
        landmark: 'Near Sony World Signal',
        isDefault: true,
      ),
      SavedAddress(
        id: 'ADDR002',
        label: 'Work',
        addressLine1: 'Tower B, Tech Park',
        addressLine2: 'Whitefield',
        city: 'Bangalore',
        state: 'Karnataka',
        pincode: '560066',
        landmark: 'Opposite ITPL',
      ),
    ];

    _wishlist = ['R001', 'R003', 'R005'];
    notifyListeners();
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

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      _token = prefs.getString('token');
      _user = User(
        id: prefs.getString('userId') ?? '',
        name: prefs.getString('userName') ?? '',
        email: prefs.getString('userEmail') ?? '',
        phone: prefs.getString('userPhone') ?? '',
        profilePhoto: prefs.getString('userPhoto'),
        isPhoneVerified: prefs.getBool('isPhoneVerified') ?? false,
        isEmailVerified: prefs.getBool('isEmailVerified') ?? true,
      );
    }
    notifyListeners();
  }

  Future<bool> login(String emailOrPhone, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (emailOrPhone == 'test@test.com' && password == '123456') {
      _isLoggedIn = true;
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = User(
        id: 'USER001',
        name: 'Rajesh Kumar',
        email: 'test@test.com',
        phone: '+91 98765 43210',
        profilePhoto: 'https://i.pravatar.cc/300?img=33',
        isPhoneVerified: true,
        isEmailVerified: true,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', _token!);
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userPhone', _user!.phone);
      await prefs.setString('userPhoto', _user!.profilePhoto ?? '');
      await prefs.setBool('isPhoneVerified', _user!.isPhoneVerified);
      await prefs.setBool('isEmailVerified', _user!.isEmailVerified);

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _user = User(
      id: 'USER_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      isPhoneVerified: false,
      isEmailVerified: false,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (otp == '123456') {
      _isLoggedIn = true;
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      
      if (_user != null) {
        _user = User(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          phone: _user!.phone,
          profilePhoto: _user!.profilePhoto,
          isPhoneVerified: true,
          isEmailVerified: true,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', _token!);
        await prefs.setString('userId', _user!.id);
        await prefs.setString('userName', _user!.name);
        await prefs.setString('userEmail', _user!.email);
        await prefs.setString('userPhone', _user!.phone);
        await prefs.setBool('isPhoneVerified', true);
        await prefs.setBool('isEmailVerified', true);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> sendPasswordResetLink(String email) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> resetPassword(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  Future<void> skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingComplete') ?? false;
  }
}

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../config/supabase_config.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    supabase.Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final supabase.AuthState authState = data;
      if (authState.session != null) {
        final supabase.User? supabaseUser = authState.session!.user;
        _loadUserProfile(supabaseUser!);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(supabase.User supabaseUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase.Supabase.instance.client
          .from('users')
          .select()
          .eq('id', supabaseUser.id)
          .single();

      _user = User.fromSupabaseUser(supabaseUser, response);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load user profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await supabase.Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String fullName, String email, String phone, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('🔐 Starting signup for: $email');

      final response = await supabase.Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      print('✅ Auth signup response: ${response.user?.id}');

      if (response.user != null) {
        // Create user profile
        print('📝 Creating user profile in users table...');
        
        try {
          // Use RPC function to bypass RLS during signup
          await supabase.Supabase.instance.client.rpc('create_user_profile', params: {
            'user_id': response.user!.id,
            'user_email': email,
            'user_full_name': fullName,
            'user_phone': phone,
          });
          
          print('✅ User profile created successfully!');
        } catch (profileError) {
          print('❌ Error creating user profile: $profileError');
          _errorMessage = 'Profile creation failed: $profileError';
          // Still return true as auth user was created
        }
        
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Signup error: $e');
      _errorMessage = 'Signup failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await supabase.Supabase.instance.client.auth.verifyOTP(
        email: phone, // phone parameter contains email
        token: otp,
        type: supabase.OtpType.signup,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'OTP verification failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await supabase.Supabase.instance.client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      _errorMessage = 'Password reset failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await supabase.Supabase.instance.client.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
      return true;
    } catch (e) {
      _errorMessage = 'Password update failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await supabase.Supabase.instance.client.auth.signOut();
      _user = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? language,
    String? preferredTemple,
  }) async {
    if (_user == null) return false;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (language != null) updates['language'] = language;
      if (preferredTemple != null) updates['preferred_temple'] = preferredTemple;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await supabase.Supabase.instance.client
          .from('users')
          .update(updates)
          .eq('id', _user!.id);

      // Reload user profile
      await _loadUserProfile(supabase.Supabase.instance.client.auth.currentUser!);
      return true;
    } catch (e) {
      _errorMessage = 'Profile update failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error is supabase.AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid email or password';
        case 'User not found':
          return 'No account found with this email';
        case 'Email already registered':
          return 'An account with this email already exists';
        case 'Phone already registered':
          return 'An account with this phone number already exists';
        case 'Weak password':
          return 'Password is too weak. Please choose a stronger password';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred';
  }

  Future<void> skipOnboarding() async {
    // This can be implemented using SharedPreferences if needed
  }

  Future<bool> hasCompletedOnboarding() async {
    // This can be implemented using SharedPreferences if needed
    return true;
  }
}

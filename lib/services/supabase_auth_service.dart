import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user.dart' as app_user;

class SupabaseAuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
        },
      );

      if (response.user != null) {
        // Create user profile in database
        await _client.from(SupabaseConfig.usersTable).insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'phone': phone,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      return response;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  // Sign in with phone OTP
  Future<void> signInWithPhone(String phone) async {
    try {
      await _client.auth.signInWithOtp(
        phone: phone,
        shouldCreateUser: true,
      );
    } catch (e) {
      debugPrint('Phone sign in error: $e');
      rethrow;
    }
  }

  // Verify OTP
  Future<AuthResponse> verifyOTP({
    required String phone,
    required String token,
  }) async {
    try {
      return await _client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );
    } catch (e) {
      debugPrint('OTP verification error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Reset password error: $e');
      rethrow;
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      debugPrint('Update password error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<app_user.User?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.usersTable)
          .select()
          .eq('id', userId)
          .single();

      return app_user.User.fromJson(response);
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _client
          .from(SupabaseConfig.usersTable)
          .update(data)
          .eq('id', userId);
    } catch (e) {
      debugPrint('Update user profile error: $e');
      rethrow;
    }
  }

  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required String filePath,
    required Uint8List fileBytes,
  }) async {
    try {
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await _client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .uploadBinary(fileName, fileBytes);

      return _client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Upload profile image error: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return;

      // Delete user data from database
      await _client
          .from(SupabaseConfig.usersTable)
          .delete()
          .eq('id', userId);

      // Sign out
      await signOut();
    } catch (e) {
      debugPrint('Delete account error: $e');
      rethrow;
    }
  }
}

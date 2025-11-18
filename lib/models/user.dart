import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class User {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? profilePhoto;
  final bool isVerified;
  final bool isActive;
  final String? language;
  final String? preferredTemple;
  final int loyaltyPoints;
  final String loyaltyTier;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.profilePhoto,
    this.isVerified = false,
    this.isActive = true,
    this.language = 'english',
    this.preferredTemple,
    this.loyaltyPoints = 0,
    this.loyaltyTier = 'bronze',
    required this.createdAt,
    required this.updatedAt,
  });

  // For backward compatibility
  String get name => fullName ?? 'User';
  // Getters for compatibility
  String? get profilePhotoUrl => profilePhoto != null 
      ? 'https://res.cloudinary.com/your-cloud/image/upload/$profilePhoto'
      : null;
  bool get isPhoneVerified => isVerified;
  bool get isEmailVerified => isVerified;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      profilePhoto: json['profile_cloudinary_id'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      language: json['language'] as String?,
      preferredTemple: json['preferred_temple'] as String?,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      loyaltyTier: json['loyalty_tier'] as String? ?? 'bronze',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'profile_cloudinary_id': profilePhoto,
      'is_verified': isVerified,
      'is_active': isActive,
      'language': language,
      'preferred_temple': preferredTemple,
      'loyalty_points': loyaltyPoints,
      'loyalty_tier': loyaltyTier,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? profileCloudinaryId,
    bool? isVerified,
    bool? isActive,
    String? language,
    String? preferredTemple,
    int? loyaltyPoints,
    String? loyaltyTier,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      language: language ?? this.language,
      preferredTemple: preferredTemple ?? this.preferredTemple,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Create from Supabase User
  factory User.fromSupabaseUser(supabase.User supabaseUser, Map<String, dynamic>? userData) {
    return User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      fullName: userData?['full_name'] as String?,
      phone: userData?['phone'] as String?,
      profilePhoto: userData?['profile_cloudinary_id'] as String?,
      isVerified: userData?['is_verified'] as bool? ?? false,
      isActive: userData?['is_active'] as bool? ?? true,
      language: userData?['language'] as String? ?? 'english',
      preferredTemple: userData?['preferred_temple'] as String?,
      loyaltyPoints: userData?['loyalty_points'] as int? ?? 0,
      loyaltyTier: userData?['loyalty_tier'] as String? ?? 'bronze',
      createdAt: userData?['created_at'] != null 
          ? DateTime.parse(userData!['created_at'] as String)
          : DateTime.now(),
      updatedAt: userData?['updated_at'] != null
          ? DateTime.parse(userData!['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

class SavedAddress {
  final String id;
  final String label;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.isDefault = false,
  });

  String get fullAddress =>
      '$addressLine1, $addressLine2, $city, $state - $pincode';
}

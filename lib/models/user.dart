class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePhoto;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isPhoneVerified;
  final bool isEmailVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhoto,
    this.dateOfBirth,
    this.gender,
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
  });

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePhoto,
    DateTime? dateOfBirth,
    String? gender,
    bool? isPhoneVerified,
    bool? isEmailVerified,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
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

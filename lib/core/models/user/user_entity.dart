import 'package:json_annotation/json_annotation.dart';

import '../../enums/action_status.dart';
import 'onboarding_status.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  final int id;
  final String phone;
  final String status;
  final String role;

  final String? firstName;
  final String? lastName;
  final String? email;

  final DateTime? phoneVerifiedAt;
  final DateTime? dateOfBirth;

  final String? homeAddress;
  final String? country;
  final String? state;
  final String? city;

  final String? profilePicture;
  final String? displayName;

  final bool identityVerified;
  final bool licenseVerified;

  @JsonKey(name: 'onboarding_status')
  final OnboardingStatus? onboardingStatus;

  UserEntity({
    required this.id,
    required this.phone,
    required this.status,
    required this.role,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneVerifiedAt,
    this.dateOfBirth,
    this.homeAddress,
    this.country,
    this.state,
    this.city,
    this.profilePicture,
    this.displayName,
    required this.identityVerified,
    required this.licenseVerified,
    this.onboardingStatus,
  });

  bool get isAccountVerified => phoneVerifiedAt != null;
  // Clean integration of the 3 use cases using Dart 3 pattern matching
  ActionStatus get kycStatus => switch ((identityVerified, licenseVerified)) {
    (true, true) => ActionStatus.completed, // 1. Both are true
    (false, false) => ActionStatus.notSet, // 3. Both are false
    _ => ActionStatus.pending, // 2. One of both is false (fallback)
  };

  String get fullname => "$firstName $lastName";
  double get rating => 0.0;
  // Helper to get initials (e.g., "Ibrahim Musa" -> "IM")
  String get initials {
    final f = firstName?.trim().isNotEmpty == true ? firstName![0] : '';
    final l = lastName?.trim().isNotEmpty == true ? lastName![0] : '';
    return '$f$l'.toUpperCase();
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

extension UserEntityCopyWith on UserEntity {
  UserEntity copyWith({
    int? id,
    String? phone,
    String? status,
    String? role,

    String? firstName,
    String? lastName,
    String? email,

    DateTime? phoneVerifiedAt,
    DateTime? dateOfBirth,

    String? homeAddress,
    String? country,
    String? state,
    String? city,

    String? profilePicture,
    String? displayName,

    bool? identityVerified,
    bool? licenseVerified,

    final OnboardingStatus? onboardingStatus,
  }) {
    return UserEntity(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      homeAddress: homeAddress ?? this.homeAddress,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      profilePicture: profilePicture ?? this.profilePicture,
      displayName: displayName ?? this.displayName,
      identityVerified: identityVerified ?? this.identityVerified,
      licenseVerified: licenseVerified ?? this.licenseVerified,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
    );
  }
}

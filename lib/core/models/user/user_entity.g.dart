// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
  id: (json['id'] as num).toInt(),
  phone: json['phone'] as String,
  status: json['status'] as String,
  role: json['role'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  phoneVerifiedAt: json['phoneVerifiedAt'] == null
      ? null
      : DateTime.parse(json['phoneVerifiedAt'] as String),
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  homeAddress: json['homeAddress'] as String?,
  country: json['country'] as String?,
  state: json['state'] as String?,
  city: json['city'] as String?,
  profilePicture: json['profilePicture'] as String?,
  displayName: json['displayName'] as String?,
  identityVerified: json['identityVerified'] as bool,
  licenseVerified: json['licenseVerified'] as bool,
  onboardingStatus: json['onboarding_status'] == null
      ? null
      : OnboardingStatus.fromJson(
          json['onboarding_status'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'status': instance.status,
      'role': instance.role,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneVerifiedAt': instance.phoneVerifiedAt?.toIso8601String(),
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'homeAddress': instance.homeAddress,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'profilePicture': instance.profilePicture,
      'displayName': instance.displayName,
      'identityVerified': instance.identityVerified,
      'licenseVerified': instance.licenseVerified,
      'onboarding_status': instance.onboardingStatus,
    };

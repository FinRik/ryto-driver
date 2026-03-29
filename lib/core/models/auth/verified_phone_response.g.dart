// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verified_phone_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiedPhoneResponse _$VerifiedPhoneResponseFromJson(
  Map<String, dynamic> json,
) => VerifiedPhoneResponse(
  id: json['id'] as String,
  phoneVerifiedAt: json['phoneVerifiedAt'] == null
      ? null
      : DateTime.parse(json['phoneVerifiedAt'] as String),
  identityVerified: json['identityVerified'] as bool,
  licenseVerified: json['licenseVerified'] as bool,
  phone: json['phone'] as String?,
  status: json['status'] as String?,
  role: json['role'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  homeAddress: json['homeAddress'] as String?,
  country: json['country'] as String?,
  state: json['state'] as String?,
  city: json['city'] as String?,
  profilePicture: json['profilePicture'] as String?,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$VerifiedPhoneResponseToJson(
  VerifiedPhoneResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'phoneVerifiedAt': instance.phoneVerifiedAt?.toIso8601String(),
  'identityVerified': instance.identityVerified,
  'licenseVerified': instance.licenseVerified,
  'phone': instance.phone,
  'status': instance.status,
  'role': instance.role,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'homeAddress': instance.homeAddress,
  'country': instance.country,
  'state': instance.state,
  'city': instance.city,
  'profilePicture': instance.profilePicture,
  'displayName': instance.displayName,
};

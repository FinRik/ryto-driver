import 'package:json_annotation/json_annotation.dart';

part 'verified_phone_response.g.dart';

@JsonSerializable()
class VerifiedPhoneResponse {
  final String id;
  final DateTime? phoneVerifiedAt;

  final bool identityVerified;
  final bool licenseVerified;

  // optional profile fields (same as driver profile)
  final String? phone;
  final String? status;
  final String? role;

  final String? firstName;
  final String? lastName;
  final String? email;

  final DateTime? dateOfBirth;

  final String? homeAddress;
  final String? country;
  final String? state;
  final String? city;

  final String? profilePicture;
  final String? displayName;

  VerifiedPhoneResponse({
    required this.id,
    this.phoneVerifiedAt,
    required this.identityVerified,
    required this.licenseVerified,
    this.phone,
    this.status,
    this.role,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.homeAddress,
    this.country,
    this.state,
    this.city,
    this.profilePicture,
    this.displayName,
  });

  factory VerifiedPhoneResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifiedPhoneResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifiedPhoneResponseToJson(this);
}
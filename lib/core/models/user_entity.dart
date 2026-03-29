import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
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

  UserEntity({
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
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
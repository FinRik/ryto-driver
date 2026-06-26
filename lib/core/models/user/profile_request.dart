import 'package:json_annotation/json_annotation.dart';

part 'profile_request.g.dart';

@JsonSerializable()
class ProfileRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String dateOfBirth;
  final String homeAddress;
  final String country;
  final String state;
  final String city;
  final String profilePicture;

  ProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.homeAddress,
    required this.country,
    required this.state,
    required this.city,
    required this.profilePicture,
  });

  factory ProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileRequestToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

import '../user/user_entity.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String token;
  final UserEntity profile;

  AuthResponse({
    required this.token,
    required this.profile,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
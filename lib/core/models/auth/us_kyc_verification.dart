import 'package:json_annotation/json_annotation.dart';

part 'us_kyc_verification.g.dart';

@JsonSerializable()
class USKycVerification {
  final String verificationSessionId;
  final String ephemeralKeySecret;

  USKycVerification({
    required this.verificationSessionId,
    required this.ephemeralKeySecret,
  });

  factory USKycVerification.fromJson(Map<String, dynamic> json) =>
      _$USKycVerificationFromJson(json);

  Map<String, dynamic> toJson() => _$USKycVerificationToJson(this);
}
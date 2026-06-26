import 'package:json_annotation/json_annotation.dart';

part 'us_kyc_preflight.g.dart';

@JsonSerializable()
class USKycPreflight {
  final String licenseFrontUrl;
  final String licenseBackUrl;

  USKycPreflight({
    required this.licenseFrontUrl,
    required this.licenseBackUrl,
  });

  factory USKycPreflight.fromJson(Map<String, dynamic> json) =>
      _$USKycPreflightFromJson(json);

  Map<String, dynamic> toJson() => _$USKycPreflightToJson(this);
}
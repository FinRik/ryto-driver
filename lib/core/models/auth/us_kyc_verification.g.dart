// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'us_kyc_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

USKycVerification _$USKycVerificationFromJson(Map<String, dynamic> json) =>
    USKycVerification(
      verificationSessionId: json['verificationSessionId'] as String,
      ephemeralKeySecret: json['ephemeralKeySecret'] as String,
    );

Map<String, dynamic> _$USKycVerificationToJson(USKycVerification instance) =>
    <String, dynamic>{
      'verificationSessionId': instance.verificationSessionId,
      'ephemeralKeySecret': instance.ephemeralKeySecret,
    };

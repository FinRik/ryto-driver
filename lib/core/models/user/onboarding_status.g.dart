// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingStatus _$OnboardingStatusFromJson(Map<String, dynamic> json) =>
    OnboardingStatus(
      kyc: json['kyc'] as String,
      vehicle: json['vehicle'] as String,
      preferences: json['preferences'] as String?,
      payout: json['payout'] as String?,
      isFullyOnboarded: json['is_fully_onboarded'] as bool,
    );

Map<String, dynamic> _$OnboardingStatusToJson(OnboardingStatus instance) =>
    <String, dynamic>{
      'kyc': instance.kyc,
      'vehicle': instance.vehicle,
      'preferences': instance.preferences,
      'payout': instance.payout,
      'is_fully_onboarded': instance.isFullyOnboarded,
    };

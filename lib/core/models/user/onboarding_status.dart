import 'package:json_annotation/json_annotation.dart';

part 'onboarding_status.g.dart';

@JsonSerializable(explicitToJson: true)
class OnboardingStatus {
  final String kyc;
  final String vehicle;
  final String? preferences;
  final String? payout;
  // final Preferences? preferences;
  // final PayoutModel? payout;
  @JsonKey(name: 'is_fully_onboarded')
  final bool isFullyOnboarded;

  OnboardingStatus({
    required this.kyc,
    required this.vehicle,
    required this.preferences,
    this.payout,
    required this.isFullyOnboarded,
  });

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingStatusToJson(this);
}

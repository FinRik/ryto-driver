import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_response.g.dart';

@JsonSerializable()
class WithdrawalResponse {
  final int id;
  final int userId;
  final int amount;
  final String currency;
  final String status;
  final String trigger;
  final String provider;
  final String providerRef;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  WithdrawalResponse({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.trigger,
    required this.provider,
    required this.providerRef,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalResponseToJson(this);
}
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payout_bank.g.dart';

@JsonSerializable()
class PayoutBank extends Equatable {
  final int id;
  final int userId;
  final String? bankName;
  final String? bankCode;
  final String? accountNumber;
  final String? accountName;
  final String? country;
  final String? currency;
  final String? provider;
  final String? providerRecipientCode;
  final String? stripeConnectAccountId;
  final String? stripeRecipientAccountId;
  final String? stripePayoutMethodId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PayoutBank({
    required this.id,
    required this.userId,
    this.bankName,
    this.bankCode,
    this.accountNumber,
    this.accountName,
    this.country,
    this.currency,
    this.provider,
    this.providerRecipientCode,
    this.stripeConnectAccountId,
    this.stripeRecipientAccountId,
    this.stripePayoutMethodId,
    this.createdAt,
    this.updatedAt,
  });

  factory PayoutBank.fromJson(Map<String, dynamic> json) =>
      _$PayoutBankFromJson(json);
  Map<String, dynamic> toJson() => _$PayoutBankToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    bankName,
    bankCode,
    accountNumber,
    accountName,
    country,
    currency,
    provider,
    providerRecipientCode,
    stripeConnectAccountId,
    stripeRecipientAccountId,
    stripePayoutMethodId,
    createdAt,
    updatedAt,
  ];
}

extension PayoutBankExtension on PayoutBank {
  PayoutBank copyWith({
    int? id,
    int? userId,
    String? bankName,
    String? bankCode,
    String? accountNumber,
    String? accountName,
    String? country,
    String? currency,
    String? provider,
    String? providerRecipientCode,
    String? stripeConnectAccountId,
    String? stripeRecipientAccountId,
    String? stripePayoutMethodId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PayoutBank(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      provider: provider ?? this.provider,
      providerRecipientCode:
          providerRecipientCode ?? this.providerRecipientCode,
      stripeConnectAccountId:
          stripeConnectAccountId ?? this.stripeConnectAccountId,
      stripeRecipientAccountId:
          stripeRecipientAccountId ?? this.stripeRecipientAccountId,
      stripePayoutMethodId: stripePayoutMethodId ?? this.stripePayoutMethodId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

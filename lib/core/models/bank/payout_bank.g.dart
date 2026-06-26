// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutBank _$PayoutBankFromJson(Map<String, dynamic> json) => PayoutBank(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  bankName: json['bankName'] as String?,
  bankCode: json['bankCode'] as String?,
  accountNumber: json['accountNumber'] as String?,
  accountName: json['accountName'] as String?,
  country: json['country'] as String?,
  currency: json['currency'] as String?,
  provider: json['provider'] as String?,
  providerRecipientCode: json['providerRecipientCode'] as String?,
  stripeConnectAccountId: json['stripeConnectAccountId'] as String?,
  stripeRecipientAccountId: json['stripeRecipientAccountId'] as String?,
  stripePayoutMethodId: json['stripePayoutMethodId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PayoutBankToJson(PayoutBank instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bankName': instance.bankName,
      'bankCode': instance.bankCode,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'country': instance.country,
      'currency': instance.currency,
      'provider': instance.provider,
      'providerRecipientCode': instance.providerRecipientCode,
      'stripeConnectAccountId': instance.stripeConnectAccountId,
      'stripeRecipientAccountId': instance.stripeRecipientAccountId,
      'stripePayoutMethodId': instance.stripePayoutMethodId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

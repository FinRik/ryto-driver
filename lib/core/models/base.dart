import 'package:json_annotation/json_annotation.dart';

import 'auth/auth_response.dart';
import 'auth/kyc_status_response.dart';
import 'auth/verified_phone_response.dart';
import 'user_entity.dart';

part 'base.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseModel<T> {
  @_Converter()
  int? code;
  String? message;
  // String? error;
  T? data;

  BaseModel({this.code, this.message, this.data});

  factory BaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) functionE,
  ) => _$BaseModelFromJson(json, functionE);

  Map<String, dynamic> toJson(Object Function(T? value) toJsonT) =>
      _$BaseModelToJson(this, toJsonT);
}

class _Converter<T> implements JsonConverter<T?, Object?> {
  const _Converter();

  @override
  T? fromJson(Object? json) {
    if (json == null) return null;

    if (json is List) {
      if (json.isNotEmpty) {
        var item = json.first;
        if (item is Map<String, dynamic> &&
            item.containsKey('token') &&
            item.containsKey('profile')) {
          return json
                  .map<AuthResponse>(
                    (i) => AuthResponse.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
              as T;
          // } else if (item is Map<String, dynamic> &&
          //     item.containsKey('id') &&
          //     item.containsKey('serviceID') &&
          //     item.containsKey('number')) {
          //   return json
          //       .map((i) => BeneficiaryEntity.fromJson(i as Map<String, dynamic>))
          //       .toList() as T;
          // } else if (item is Map<String, dynamic> &&
          //     item.containsKey('date') &&
          //     item.containsKey("reference") &&
          //     item.containsKey('amount') &&
          //     item.containsKey('wallet_balance') &&
          //     item.containsKey('status')) {
          //   return json
          //       .map((i) =>
          //           WalletHistoryEntity.fromJson(i as Map<String, dynamic>))
          //       .toList() as T;
          // } else if (item is Map<String, dynamic> &&
          //     item.containsKey('image') &&
          //     item.containsKey("type")) {
          //   return json
          //       .map((i) => AdEntity.fromJson(i as Map<String, dynamic>))
          //       .toList() as T;
          // }
          //   else if (item is Map<String, dynamic> &&
          //       item.containsKey('ref') &&
          //       item.containsKey("channel_name") &&
          //       item.containsKey('approvalStatus') &&
          //       item.containsKey('amount'))
          //     return json
          //         .map((i) => VoucherEntity.fromJson(i as Map<String, dynamic>))
          //         .toList() as T;
          //   else if (item is Map<String, dynamic> &&
          //       item.containsKey('faq') &&
          //       item.containsKey("answer") &&
          //       item.containsKey('id'))
          //     return json
          //         .map((i) => FaqEntity.fromJson(i as Map<String, dynamic>))
          //         .toList() as T;
          //   else if (item is Map<String, dynamic> &&
          //       item.containsKey('payment_ref') &&
          //       item.containsKey("fullname") &&
          //       item.containsKey('amount'))
        }
      } else {
        return null;
      }
    } else {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('token') && json.containsKey('profile')) {
          return AuthResponse.fromJson(json) as T;
        } else if (json.containsKey('phone') &&
            json.containsKey('status') &&
            json.containsKey('role') &&
            json.containsKey('firstname') &&
            json.containsKey('lastname')) {
          return UserEntity.fromJson(json) as T?;
        } else if (json.containsKey('phoneVerifiedAt') &&
            json.containsKey('licenseVerified') &&
            json.containsKey('identityVerified') &&
            json.containsKey('role')) {
          return VerifiedPhoneResponse.fromJson(json) as T?;
        } else if (json.containsKey('identityStatus') &&
            json.containsKey('licenseStatus')) {
          return KycResponse.fromJson(json) as T?;
          // } else if (json.containsKey('data')&&!json.containsKey('delivery_details')) {
          //   return DynamicResponse.fromJson(json) as T?;
        } else {
          return json as T?;
        }
      }
    }
    return null;
  }

  @override
  Object toJson(T? object) {
    if (object == null) return {};
    return (object as dynamic).toJson();
  }
}

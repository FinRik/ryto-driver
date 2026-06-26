import 'package:json_annotation/json_annotation.dart';

import 'auth/auth_response.dart';
import 'auth/kyc_response.dart';
import 'auth/us_kyc_preflight.dart';
import 'auth/us_kyc_verification.dart';
import 'bank/payout_bank.dart';
import 'preference.dart';
import 'bookings/booking_summary.dart';
import 'trip/trip.dart';
import 'trip/trip_cost_summary.dart';
import 'trip/trip_response.dart';
import 'trip/trip_summary.dart';
import 'user/user_entity.dart';
import 'vehicle_setup/vehicle_detail.dart';
import 'wallet/withdrawal_response.dart';

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
        } else if (item is Map<String, dynamic> &&
            item.containsKey('id') &&
            item.containsKey('userId') &&
            item.containsKey('bankName') &&
            item.containsKey('bankCode')) {
          return json
                  .map((i) => PayoutBank.fromJson(i as Map<String, dynamic>))
                  .toList()
              as T;
        } else if (item is Map<String, dynamic> &&
            item.containsKey('bookingStatus') &&
            item.containsKey("packageType") &&
            item.containsKey('seats') &&
            item.containsKey('passenger') &&
            item.containsKey('status')) {
          return json
                  .map(
                    (i) => BookingSummary.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
              as T;
        } else if (item is Map<String, dynamic> &&
            (item.containsKey('id') &&
                item.containsKey('status') &&
                item.containsKey('estimatedEarnings') &&
                item.containsKey('tripFeeGross') &&
                item.containsKey('platformCommission') &&
                item.containsKey('driverNet'))) {
          return json
                  .map(
                    (i) => Trip.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
              as T;
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
            json.containsKey('lastname') &&
            json.containsKey('phoneVerifiedAt') &&
            json.containsKey('email') &&
            json.containsKey('licenseVerified') &&
            json.containsKey('identityVerified')) {
          return UserEntity.fromJson(json) as T?;
        } else if (json.containsKey('identityStatus') &&
            json.containsKey('licenseStatus')) {
          return KycResponse.fromJson(json) as T?;
        } else if (json.containsKey('idCheckRequired') &&
            json.containsKey('smokingAllowed') &&
            json.containsKey('packagesAllowed')) {
          return Preferences.fromJson(json) as T?;
        } else if (json.containsKey('userId') &&
            json.containsKey('originCity') &&
            json.containsKey('originLat') &&
            json.containsKey('originLng')) {
          return TripSummary.fromJson(json) as T?;
        } else if (json.containsKey('id') &&
            json.containsKey('status') &&
            json.containsKey('estimatedEarnings') &&
            json.containsKey('tripFeeGross') &&
            json.containsKey('platformCommission') &&
            json.containsKey('driverNet')) {
          return Trip.fromJson(json) as T?;
        } else if (json.containsKey('data') &&
            json.containsKey('meta')) {
          return TripResponse.fromJson(json) as T?;
        } else if (json.containsKey('serviceTier') &&
            json.containsKey('makeModel') &&
            json.containsKey('plateNumber') &&
            json.containsKey('passengerSeats')) {
          return VehicleDetail.fromJson(json) as T?;
        } else if (json.containsKey('licenseFrontUrl') &&
            json.containsKey('licenseBackUrl')) {
          return USKycPreflight.fromJson(json) as T?;
        } else if (json.containsKey('ephemeralKeySecret') &&
            json.containsKey('verificationSessionId')) {
          return USKycVerification.fromJson(json) as T?;
        } else if (json.containsKey('trigger') &&
            json.containsKey('provider') &&
            json.containsKey('providerRef')) {
          return WithdrawalResponse.fromJson(json) as T?;
        } else if (json.containsKey('pricing') &&
            json.containsKey('distance_metrics')) {
          return TripCostSummary.fromJson(json) as T?;
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

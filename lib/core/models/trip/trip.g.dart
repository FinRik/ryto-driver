// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  tripPhase: json['tripPhase'] as String,
  isDeparturePast: json["isDeparturePast"] as bool,
  originCity: json['originCity'] as String,
  destinationCity: json['destinationCity'] as String,
  departureDateTime: Trip._dateTimeFromJson(
    Trip._readDateTimeFields(json, 'departureDateTime') as String,
  ),
  // departureDateTime: DateTime.parse(json['departureDateTime'] as String),
  passengersBooked: (json['passengersBooked'] as num).toInt(),
  packageType: json['packageType'] as String?,
  estimatedEarnings: (json['estimatedEarnings'] as num).toDouble(),
  currency: (json["currency"] as String?),
  tripFeeGross: (json["tripFeeGross"] as num?)?.toDouble(),
  platformCommission: (json['platformCommission'] as num?)?.toDouble(),
  serviceFee: (json['serviceFee'] as num?)?.toDouble(),
  driverNet: (json["driverNet"] as num?)?.toDouble(),
  netProfit: (json["netProfit"] as num?)?.toDouble(),
  distanceKm: (json['distanceKm'] as num).toDouble(),
);

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  "tripPhase": instance.tripPhase,
  "isDeparturePast": instance.isDeparturePast,
  'originCity': instance.originCity,
  'destinationCity': instance.destinationCity,
  'passengersBooked': instance.passengersBooked,
  'packageType': instance.packageType,
  'estimatedEarnings': instance.estimatedEarnings,
  'currency': instance.currency,
  'tripFeeGross': instance.tripFeeGross,
  'platformCommission': instance.platformCommission,
  'serviceFee': instance.serviceFee,
  'driverNet': instance.driverNet,
  'netProfit': instance.netProfit,
  'distanceKm': instance.distanceKm,
};

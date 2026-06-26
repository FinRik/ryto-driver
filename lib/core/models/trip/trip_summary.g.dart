// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripSummary _$TripSummaryFromJson(Map<String, dynamic> json) => TripSummary(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  originCity: json['originCity'] as String,
  originLat: (json['originLat'] as num).toDouble(),
  originLng: (json['originLng'] as num).toDouble(),
  destinationCity: json['destinationCity'] as String,
  destinationLat: (json['destinationLat'] as num).toDouble(),
  destinationLng: (json['destinationLng'] as num).toDouble(),
  // Inside _$TripFromJson(Map<String, dynamic> json)
  departureDateTime: TripSummary._dateTimeFromJson(
    // The generated code uses the custom reader helper instead of json['departureDateTime']
    TripSummary._readDateTimeFields(json, 'departureDateTime') as String,
  ),
  // departureDateTime: TripSummary._dateTimeFromJson(json['departureDateTime'] as String),
  passengerSeats: (json['passengerSeats'] as num).toInt(),
  packagesAllowed: json['packagesAllowed'] as bool,
  pickupLat: (json['pickupLat'] as num).toDouble(),
  pickupLng: (json['pickupLng'] as num).toDouble(),
  dropoffLat: (json['dropoffLat'] as num).toDouble(),
  dropoffLng: (json['dropoffLng'] as num).toDouble(),
  notes: json['notes'] as String?,
  status: json['status'] as String,
  vehicleId: (json['vehicleId'] as num).toInt(),
  createdAt: TripSummary._dateTimeFromJson(json['createdAt'] as String),
  updatedAt: TripSummary._dateTimeFromJson(json['updatedAt'] as String),
  currency: json['currency'] as String,
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  driverNet: (json['driverNet'] as num?)?.toDouble(),
  commission: (json['commission'] as num?)?.toDouble(),
  platformCommissionPercentApplied:
      (json['platformCommissionPercentApplied'] as num?)?.toDouble(),
  // bookings: (json['bookings'] as List<dynamic>?)
  //     ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
  //     .toList(),
  distanceKm: (json['distanceKm'] as num).toDouble(),
  passengersBooked: (json['passengersBooked'] as num).toInt(),
);

Map<String, dynamic> _$TripSummaryToJson(
  TripSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'originCity': instance.originCity,
  'originLat': instance.originLat,
  'originLng': instance.originLng,
  'destinationCity': instance.destinationCity,
  'destinationLat': instance.destinationLat,
  'destinationLng': instance.destinationLng,
  // 'departureDate': TripSummary._dateTimeToJson(instance.departureDateTime),
  'passengerSeats': instance.passengerSeats,
  'packagesAllowed': instance.packagesAllowed,
  'pickupLat': instance.pickupLat,
  'pickupLng': instance.pickupLng,
  'dropoffLat': instance.dropoffLat,
  'dropoffLng': instance.dropoffLng,
  'notes': instance.notes,
  'status': instance.status,
  'vehicleId': instance.vehicleId,
  'createdAt': TripSummary._dateTimeToJson(instance.createdAt),
  'updatedAt': TripSummary._dateTimeToJson(instance.updatedAt),
  'currency': instance.currency,
  'totalAmount': instance.totalAmount,
  'driverNet': instance.driverNet,
  'commission': instance.commission,
  'platformCommissionPercentApplied': instance.platformCommissionPercentApplied,
  // 'bookings': instance.bookings,
  'distanceKm': instance.distanceKm,
  'passengersBooked': instance.passengersBooked,
};

// Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
//   id: (json['id'] as num).toInt(),
//   tripId: (json['tripId'] as num).toInt(),
//   passengerId: (json['passengerId'] as num).toInt(),
//   transactionId: (json['transactionId'] as num).toInt(),
//   seats: (json['seats'] as num).toInt(),
//   bookingStatus: json['bookingStatus'] as String,
//   safetyPin: json['safetyPin'] as String,
//   driverPinVerifiedAt: json['driverPinVerifiedAt'] == null
//       ? null
//       : DateTime.parse(json['driverPinVerifiedAt'] as String),
//   packageType: json['packageType'] as String?,
//   passengerPickupLat: (json['passengerPickupLat'] as num).toDouble(),
//   passengerPickupLng: (json['passengerPickupLng'] as num).toDouble(),
//   passengerDropoffLat: (json['passengerDropoffLat'] as num).toDouble(),
//   passengerDropoffLng: (json['passengerDropoffLng'] as num).toDouble(),
//   packageSize: json['packageSize'] as String?,
//   packageWeight: (json['packageWeight'] as num?)?.toDouble(),
//   packageHandlingOptions: (json['packageHandlingOptions'] as List<dynamic>)
//       .map((e) => e as String)
//       .toList(),
//   packageContent: json['packageContent'] as String?,
//   offsetKm: (json['offsetKm'] as num).toDouble(),
//   createdAt: DateTime.parse(json['createdAt'] as String),
// );
//
// Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
//   'id': instance.id,
//   'tripId': instance.tripId,
//   'passengerId': instance.passengerId,
//   'transactionId': instance.transactionId,
//   'seats': instance.seats,
//   'bookingStatus': instance.bookingStatus,
//   'safetyPin': instance.safetyPin,
//   'driverPinVerifiedAt': instance.driverPinVerifiedAt?.toIso8601String(),
//   'packageType': instance.packageType,
//   'passengerPickupLat': instance.passengerPickupLat,
//   'passengerPickupLng': instance.passengerPickupLng,
//   'passengerDropoffLat': instance.passengerDropoffLat,
//   'passengerDropoffLng': instance.passengerDropoffLng,
//   'packageSize': instance.packageSize,
//   'packageWeight': instance.packageWeight,
//   'packageHandlingOptions': instance.packageHandlingOptions,
//   'packageContent': instance.packageContent,
//   'offsetKm': instance.offsetKm,
//   'createdAt': instance.createdAt.toIso8601String(),
// };

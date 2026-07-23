// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingSummary _$BookingSummaryFromJson(Map<String, dynamic> json) =>
    BookingSummary(
      id: (json['id'] as num).toInt(),
      bookingStatus: json['bookingStatus'] as String,
      seats: (json['seats'] as num).toInt(),
      pricePaid: (json["pricePaid"] as num?)?.toDouble(),
      priceCurrency: json["priceCurrency"] as String?,
      transactionStatus: json["transactionStatus"] as String?,
      packageType: json['packageType'] as String?,
      packageRecipientName: json["packageRecipientName"] as String?,
      packageRecipientPhone: json["packageRecipientPhone"] as String?,
      offsetKm: (json['offsetKm'] as num).toDouble(),
      passengerPickupLat: (json['passengerPickupLat'] as num).toDouble(),
      passengerPickupLng: (json['passengerPickupLng'] as num).toDouble(),
      passengerDropoffLat: (json['passengerDropoffLat'] as num).toDouble(),
      passengerDropoffLng: (json['passengerDropoffLng'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      driverPinVerifiedAt: json['driverPinVerifiedAt'] == null
          ? null
          : DateTime.parse(json['driverPinVerifiedAt'] as String),
      passenger: Passenger.fromJson(json['passenger'] as Map<String, dynamic>),
      passengers: json['passengers'] != null
          ? (json['passengers'] as List).map((i) => Passenger.fromJson(i)).toList()
          : [],
    );

Map<String, dynamic> _$BookingSummaryToJson(BookingSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingStatus': instance.bookingStatus,
      'seats': instance.seats,
      'pricePaid': instance.pricePaid,
      'priceCurrency': instance.priceCurrency,
      'transactionStatus': instance.transactionStatus,
      'packageType': instance.packageType,
      'packageRecipientName': instance.packageRecipientName,
      'packageRecipientPhone': instance.packageRecipientPhone,
      'offsetKm': instance.offsetKm,
      'passengerPickupLat': instance.passengerPickupLat,
      'passengerPickupLng': instance.passengerPickupLng,
      'passengerDropoffLat': instance.passengerDropoffLat,
      'passengerDropoffLng': instance.passengerDropoffLng,
      'createdAt': instance.createdAt.toIso8601String(),
      'driverPinVerifiedAt': instance.driverPinVerifiedAt?.toIso8601String(),
      'passenger': instance.passenger,
    };

Passenger _$PassengerFromJson(Map<String, dynamic> json) => Passenger(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'email': instance.email,
};

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_summary.g.dart';

@JsonSerializable()
class BookingSummary {
  final int id;
  final String bookingStatus;
  final int seats;
  final double? pricePaid;
  final String? priceCurrency;
  final String? transactionStatus;
  final String? packageType;
  final String? packageRecipientName;
  final String? packageRecipientPhone;
  final double offsetKm;
  final double passengerPickupLat;
  final double passengerPickupLng;
  final double passengerDropoffLat;
  final double passengerDropoffLng;
  final DateTime createdAt;
  final DateTime? driverPinVerifiedAt;

  final Passenger passenger;
  final List<Passenger>? passengers;

  BookingSummary({
    required this.id,
    required this.bookingStatus,
    required this.seats,
    this.pricePaid,
    this.priceCurrency,
    this.transactionStatus,
    this.packageType,
    this.packageRecipientName,
    this.packageRecipientPhone,
    required this.offsetKm,
    required this.passengerPickupLat,
    required this.passengerPickupLng,
    required this.passengerDropoffLat,
    required this.passengerDropoffLng,
    required this.createdAt,
    this.driverPinVerifiedAt,
    required this.passenger,
    this.passengers,
  });

  Color get formattedStatus {
    final status = bookingStatus.toUpperCase();
    switch (status) {
      case "CONFIRMED":
        return const Color(0xFF48BB78);
      case "ACCEPTED" || "APPROVED":
        return const Color(0xFF0060EB);
      default:
        return const Color(0xFFF6AD55);
    }
  }

  String getFriendlyHeaderStatus(String? rawStatus) {
    switch (rawStatus?.toUpperCase()) {
      case "PENDING":
      case "SCHEDULED":
        return "Trip Scheduled";
      case "BOOKED":
        return "Trip Booked";
      case "DRIVER_ACCEPTED":
        return "Driver is Assigned";
      case "DRIVER_REJECTED":
        return "Driver Canceled";
      case "TRIP_STARTED":
        return "Trip En Route";
      case "TRIP_COMPLETED":
        return "Arrived Safely";
      default:
        return "Finding your Trip";
    }
  }

  bool get getBookingStatus {
    switch (bookingStatus.toUpperCase()) {
      case "PENDING":
      case "SCHEDULED":
        return false;
      case "BOOKED":
      case "DRIVER_ACCEPTED":
      case "DRIVER_REJECTED":
      case "TRIP_STARTED":
      case "TRIP_COMPLETED":
        return true;
      default:
        return false;
    }
  }

  String get cleanRawStatus {
    final raw = bookingStatus;

    final words = raw.replaceAll('_', ' ').toLowerCase().split(' ');

    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    });

    return capitalizedWords.join(' ');
  }

  factory BookingSummary.fromJson(Map<String, dynamic> json) =>
      _$BookingSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$BookingSummaryToJson(this);
}

@JsonSerializable()
class Passenger {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  Passenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  String get fullname => "$firstName $lastName";
  String get initials => "${firstName[0]} ${lastName[0]}";
  double get rating => 0.0;
  int get tripCount => 0;

  factory Passenger.fromJson(Map<String, dynamic> json) =>
      _$PassengerFromJson(json);

  Map<String, dynamic> toJson() => _$PassengerToJson(this);
}

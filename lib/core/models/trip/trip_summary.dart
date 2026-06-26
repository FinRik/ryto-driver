import 'package:json_annotation/json_annotation.dart';

import '../../../utils/helpers/date_formatter_utils.dart';
import '../bookings/booking_summary.dart';

part 'trip_summary.g.dart';

@JsonSerializable()
class TripSummary {
  final int id;
  final int userId;
  final String originCity;
  final double originLat;
  final double originLng;
  final String destinationCity;
  final double destinationLat;
  final double destinationLng;
  @JsonKey(
    readValue: _readDateTimeFields,
    fromJson: _dateTimeFromJson,
    includeToJson: false,
  )
  final DateTime departureDateTime;

  final int passengerSeats;
  final bool packagesAllowed;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String? notes;
  final String status;
  final int vehicleId;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;
  final String currency;
  final double? totalAmount;
  final double? driverNet;
  final double? commission;
  final double? platformCommissionPercentApplied;

  // final List<Booking>? bookings;
  final double distanceKm;
  final int passengersBooked;

  TripSummary({
    required this.id,
    required this.userId,
    required this.originCity,
    required this.originLat,
    required this.originLng,
    required this.destinationCity,
    required this.destinationLat,
    required this.destinationLng,
    required this.departureDateTime,
    required this.passengerSeats,
    required this.packagesAllowed,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    this.notes,
    required this.status,
    required this.vehicleId,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    this.totalAmount,
    this.driverNet,
    this.commission,
    this.platformCommissionPercentApplied,
    // required this.bookings,
    required this.distanceKm,
    required this.passengersBooked,
  });

  // HELPER: Safely extracts and joins 'YYYY-MM-DD' and 'HH:MM' from JSON map
  static Object? _readDateTimeFields(Map json, String key) {
    final date = json['departureDate'] ?? '1970-01-01';
    final time = json['departureTime'] ?? '00:00';
    // Formats into a clean ISO-8601 string
    return '${date}T$time:00';
  }
  // Custom converters for DateTime
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  String get departureDate {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractDate(departureDateTime.toString());
  }

  String get departureTime24 {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractTime(departureDateTime.toString());
  }

  String get departureTime {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractTime12Hour(departureDateTime.toString());
  }

  // FRONTEND FALLBACK FINANCIAL CALCULATIONS
  // Use these getters in your UI when the root backend fields return null
  double calculateCalculatedEarnings(List<BookingSummary> fetchedBookings) {
    if (totalAmount != null && totalAmount! > 0) return totalAmount!;
    return fetchedBookings
        .where((b) => b.bookingStatus == "DRIVER_ACCEPTED" || b.bookingStatus == "CONFIRMED")
        .fold(0.0, (sum, item) => sum + (item.pricePaid ?? 0.0));
  }

  double calculateNetProfit(List<BookingSummary> fetchedBookings) {
    if (driverNet != null && driverNet! > 0) return driverNet!;
    double earnings = calculateCalculatedEarnings(fetchedBookings);
    // Assuming a local fallback 10% platform fee if commission configuration is null
    double feePercent = platformCommissionPercentApplied ?? 10.0;
    return earnings * (1 - (feePercent / 100));
  }

  double calculateServiceFee(List<BookingSummary> fetchedBookings) {
    if (commission != null) return commission!;
    return calculateCalculatedEarnings(fetchedBookings) - calculateNetProfit(fetchedBookings);
  }

  factory TripSummary.fromJson(Map<String, dynamic> json) =>
      _$TripSummaryFromJson(json);
  // Map<String, dynamic> toJson() => _$TripSummaryToJson(this);
  Map<String, dynamic> toJson() {
    final map = _$TripSummaryToJson(this);

    // Manually inject the exact split keys the backend expects
    map['departureDate'] = departureDateTime.toIso8601String().split('T').first; // YYYY-MM-DD
    map['departureTime'] = "${departureDateTime.hour.toString().padLeft(2, '0')}:${departureDateTime.minute.toString().padLeft(2, '0')}"; // HH:MM

    return map;
  }
}

// @JsonSerializable()
// class Booking {
//   final int id;
//   final int tripId;
//   final int passengerId;
//   final int transactionId;
//   final int seats;
//   final String bookingStatus;
//   final String safetyPin;
//   final DateTime? driverPinVerifiedAt;
//   final String? packageType;
//   final double passengerPickupLat;
//   final double passengerPickupLng;
//   final double passengerDropoffLat;
//   final double passengerDropoffLng;
//   final String? packageSize;
//   final double? packageWeight;
//   final List<String> packageHandlingOptions;
//   final String? packageContent;
//   final double offsetKm;
//   final DateTime createdAt;
//
//   Booking({
//     required this.id,
//     required this.tripId,
//     required this.passengerId,
//     required this.transactionId,
//     required this.seats,
//     required this.bookingStatus,
//     required this.safetyPin,
//     this.driverPinVerifiedAt,
//     this.packageType,
//     required this.passengerPickupLat,
//     required this.passengerPickupLng,
//     required this.passengerDropoffLat,
//     required this.passengerDropoffLng,
//     this.packageSize,
//     this.packageWeight,
//     required this.packageHandlingOptions,
//     this.packageContent,
//     required this.offsetKm,
//     required this.createdAt,
//   });
//
//   factory Booking.fromJson(Map<String, dynamic> json) =>
//       _$BookingFromJson(json);
//
//   Map<String, dynamic> toJson() => _$BookingToJson(this);
// }
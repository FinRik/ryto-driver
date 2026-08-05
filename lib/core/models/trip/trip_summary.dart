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

  // 1. Financial Fields
  final double? totalAmount;
  final double? driverNet;
  final double? commission;
  final double? platformCommissionPercentApplied;
  final double? tripFeeGross;
  final double? platformCommission;
  final double? serviceFee;
  final double? netProfit;
  final double? estimatedEarnings;
  final double? fee;
  final int? commissionPercent;

  // 2. Status and Metadata Fields
  final String? tripPhase;
  final bool? isDeparturePast;
  @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)
  final DateTime? tripReminderSentAt;

  // 3. Nested Lists
  final List<BookingSummary> bookings;
  // final List<PassengerDetail>? passengerDetails;

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

    // Added missing financial & metadata fields
    this.totalAmount,
    this.driverNet,
    this.commission,
    this.platformCommissionPercentApplied,
    this.tripFeeGross,
    this.platformCommission,
    this.serviceFee,
    this.netProfit,
    this.estimatedEarnings,
    this.fee,
    this.commissionPercent,
    this.tripPhase,
    this.isDeparturePast,
    this.tripReminderSentAt,

    required this.bookings,
    // required this.passengerDetails,
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
  static DateTime? _dateTimeNullableFromJson(String? date) => date != null ? DateTime.parse(date) : null;
  static String? _dateTimeNullableToJson(DateTime? date) => date?.toIso8601String();

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

/// Statuses
// PENDING — no paid/accepted passengers yet
// SCHEDULED — no paid/accepted passengers yet
// DRIVER_ACCEPTED -
// COMPLETED -

/// Trip Phase
// SCHEDULED — no paid/accepted passengers yet
// AWAITING_PINS — passengers booked; verify pins before departure
// IN_PROGRESS — all required pins verified (TRIP_STARTED on bookings); start navigation
// COMPLETED / CANCELED
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../utils/helpers/date_formatter_utils.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  final int id;
  final String status;
  final String originCity;
  final String destinationCity;

  @JsonKey(
    readValue: _readDateTimeFields,
    fromJson: _dateTimeFromJson,
    includeToJson: false,
  )
  final DateTime departureDateTime;

  final int passengersBooked;
  final String? packageType;
  final double estimatedEarnings;
  final String? currency;
  final double tripFeeGross;
  final double platformCommission;
  final double serviceFee;
  final double driverNet;
  final double netProfit;
  final double distanceKm;

  Trip({
    required this.id,
    required this.status,
    required this.originCity,
    required this.destinationCity,
    required this.departureDateTime,
    required this.passengersBooked,
    this.packageType,
    required this.estimatedEarnings,
    this.currency,
    required this.tripFeeGross,
    required this.platformCommission,
    required this.serviceFee,
    required this.driverNet,
    required this.netProfit,
    required this.distanceKm,
  });

  // HELPER: Safely extracts and joins 'YYYY-MM-DD' and 'HH:MM' from JSON map
  static Object? _readDateTimeFields(Map json, String key) {
    final date = json['departureDate'] ?? '1970-01-01';
    final time = json['departureTime'] ?? '00:00';
    return '${date}T$time:00'; // Formats into a clean ISO-8601 string
  }
  // Custom converters for DateTime
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();
  bool get isTripCanceled => status == "CANCELED";

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

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  // Map<String, dynamic> toJson() => _$TripToJson(this);
  Map<String, dynamic> toJson() {
    final map = _$TripToJson(this);

    map['departureDate'] = departureDateTime.toIso8601String().split('T').first;
    map['departureTime'] = "${departureDateTime.hour.toString().padLeft(2, '0')}:${departureDateTime.minute.toString().padLeft(2, '0')}";

    return map;
  }
}

class TripUIConfig {
  final String badgeText;
  final Color badgeColor;
  final String actionLabel;
  final bool isGrayscale;
  final bool showRating;
  final bool isLinkButton;

  TripUIConfig({
    required this.badgeText,
    required this.badgeColor,
    required this.actionLabel,
    this.isGrayscale = false,
    this.showRating = false,
    this.isLinkButton = false,
  });

  static TripUIConfig fromStatus(String status) {
    switch (status) {
      case "SCHEDULED":
        return TripUIConfig(
          badgeText: "UPCOMING",
          badgeColor: const Color(0xFF0061FF), // Primary Blue from Screenshot 2
          actionLabel: "Manage Trips",
        );
      case "COMPLETED":
        return TripUIConfig(
          badgeText: "COMPLETED",
          badgeColor: const Color(0xFF4CAF50),
          actionLabel: "Trip Summary",
          showRating: true,
          isGrayscale: true,
        );
      default:
        return TripUIConfig(
          badgeText: "CANCELLED",
          badgeColor: const Color(0xFFD32F2F),
          actionLabel: "View Details",
          isGrayscale: true,
          isLinkButton: true,
        );
    }
  }
}

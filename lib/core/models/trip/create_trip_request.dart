import '../../../utils/helpers/date_formatter_utils.dart';

class CreateTripRequest {
  final String? draftId;

  final String originCity;
  final double? originLat;
  final double? originLng;

  final String destinationCity;
  final double? destinationLat;
  final double? destinationLng;

  final DateTime departureDateTime;
  // final String departureDate; // YYYY-MM-DD
  // final String departureTime; // HH:mm

  final int passengerSeats;
  final bool packagesAllowed;

  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;

  final String notes;
  final int vehicleId;

  final String country;
  final String currency;

  CreateTripRequest({
    this.draftId,
    required this.originCity,
    this.originLat,
    this.originLng,
    required this.destinationCity,
    this.destinationLat,
    this.destinationLng,
    required this.departureDateTime,
    // required this.departureDate,
    // required this.departureTime,
    required this.passengerSeats,
    required this.packagesAllowed,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    this.notes = '',
    required this.vehicleId,
    required this.country,
    required this.currency,
  });

  CreateTripRequest copyWith({
    String? draftId,
    String? originCity,
    double? originLat,
    double? originLng,
    String? destinationCity,
    double? destinationLat,
    double? destinationLng,
    DateTime? departureDateTime,
    int? passengerSeats,
    bool? packagesAllowed,
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    String? notes,
    int? vehicleId,
    String? country,
    String? currency,
  }) {
    return CreateTripRequest(
      draftId: draftId ?? this.draftId,
      originCity: originCity ?? this.originCity,
      originLat: originLat ?? this.originLat,
      originLng: originLng ?? this.originLng,
      destinationCity: destinationCity ?? this.destinationCity,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      passengerSeats: passengerSeats ?? this.passengerSeats,
      packagesAllowed: packagesAllowed ?? this.packagesAllowed,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      notes: notes ?? this.notes,
      vehicleId: vehicleId ?? this.vehicleId,
      country: country ?? this.country,
      currency: currency ?? this.currency,
    );
  }

  factory CreateTripRequest.empty() {
    return CreateTripRequest(
      draftId: '',
      originCity: '',
      destinationCity: '',
      departureDateTime: DateTime.now(),
      passengerSeats: 1,
      packagesAllowed: false,
      pickupLat: 0.0,
      pickupLng: 0.0,
      dropoffLat: 0.0,
      dropoffLng: 0.0,
      notes: '',
      currency: "",
      country: "",
      vehicleId: 0,
      destinationLat: 0.0,
      destinationLng: 0.0,
      originLat: 0.0,
      originLng: 0.0,
    );
  }

  String get departureDate {
    return DateTimeHelper.toBackendFormat(departureDateTime);
  }

  String get departureTime24 {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractTime(departureDateTime!.toString());
  }

  String get departureTime {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractTime12Hour(departureDateTime!.toString());
  }

  factory CreateTripRequest.fromJson(Map<String, dynamic> json) {
    return CreateTripRequest(
      draftId: json['draftId'] ?? '',
      originCity: json['originCity'] ?? '',
      originLat: json['originLat']?.toDouble(),
      originLng: json['originLng']?.toDouble(),
      destinationCity: json['destinationCity'] ?? '',
      destinationLat: json['destinationLat']?.toDouble(),
      destinationLng: json['destinationLng']?.toDouble(),
      departureDateTime: DateTime.parse(json['departureDateTime'] as String),
      passengerSeats: json['passengerSeats'] ?? 1,
      packagesAllowed: json['packagesAllowed'] ?? false,
      pickupLat: (json['pickupLat'] ?? 0.0).toDouble(),
      pickupLng: (json['pickupLng'] ?? 0.0).toDouble(),
      dropoffLat: (json['dropoffLat'] ?? 0.0).toDouble(),
      dropoffLng: (json['dropoffLng'] ?? 0.0).toDouble(),
      notes: json['notes'] ?? '',
      vehicleId: (json["vehicleId"] as num).toInt(),
      country: json["country"] ?? "",
      currency: json["currency"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "draftId": draftId,
      "originCity": originCity,
      "originLat": originLat,
      "originLng": originLng,
      "destinationCity": destinationCity,
      "destinationLat": destinationLat,
      "destinationLng": destinationLng,
      "departureDate": departureDate,
      "departureTime": departureTime24,
      "passengerSeats": passengerSeats,
      "packagesAllowed": packagesAllowed,
      "pickupLat": pickupLat,
      "pickupLng": pickupLng,
      "dropoffLat": dropoffLat,
      "dropoffLng": dropoffLng,
      "notes": notes,
      "currency": currency,
      "vehicleId": vehicleId,
    };
  }
}

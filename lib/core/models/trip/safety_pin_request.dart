class SafetyPinRequest {
  final List<PinVerification> pinVerifications;

  SafetyPinRequest({
    required this.pinVerifications,
  });

  // Factory constructor from JSON
  factory SafetyPinRequest.fromJson(Map<String, dynamic> json) {
    return SafetyPinRequest(
      pinVerifications: (json['pinVerifications'] as List<dynamic>)
          .map((item) => PinVerification.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert to JSON (for sending request)
  Map<String, dynamic> toJson() {
    return {
      'pinVerifications': pinVerifications.map((item) => item.toJson()).toList(),
    };
  }
}

class PinVerification {
  final int bookingId;
  final String safetyPin;

  PinVerification({
    required this.bookingId,
    required this.safetyPin,
  });

  // Factory constructor from JSON
  factory PinVerification.fromJson(Map<String, dynamic> json) {
    return PinVerification(
      bookingId: json['bookingId'] as int,
      safetyPin: json['safetyPin'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'safetyPin': safetyPin,
    };
  }
}
class DriverNotification {
  final String title;
  final String body;
  // trip_payment, booking_verified,
  // ride_request, trip_reminder,
  // new_message
  final String type;
  final String? screen;
  final int? tripId;
  final int? bookingId;
  final int? chatId;
  final double? amount;

  DriverNotification({
    required this.title,
    required this.body,
    required this.type,
    this.screen,
    this.tripId,
    this.bookingId,
    this.chatId,
    this.amount,
  });

  factory DriverNotification.fromJson(Map<String, dynamic> json) {
    return DriverNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      screen: json['screen'],
      tripId: json['trip_id'] != null ? int.tryParse(json['trip_id'].toString()) : null,
      bookingId: json['booking_id'] != null ? int.tryParse(json['booking_id'].toString()) : null,
      chatId: json['chat_id'] != null ? int.tryParse(json['chat_id'].toString()) : null,
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
    );
  }
}
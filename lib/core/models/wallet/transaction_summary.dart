// Enum to handle different icon colors and logic in UI
enum TransactionType {
  tripEarning, // Green Icon, + Amount
  bankWithdrawal, // Blue Icon, - Amount
  commission, // Blue Icon, - Amount
  unknown,
}

class TransactionItem {
  final int id;
  final String typeString;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final TransactionType type;

  TransactionItem({
    required this.id,
    required this.typeString,
    required this.amount,
    required this.currency,
    required this.createdAt,
    required this.type,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    // Mapping logic for your Enum
    TransactionType mapType(String typeStr) {
      switch (typeStr) {
        case 'TRIP_EARNING':
          return TransactionType.tripEarning;
        case 'PAYOUT_SETTLED':
          return TransactionType.bankWithdrawal;
        case 'COMMISSION':
          return TransactionType.commission;
        default:
          return TransactionType.unknown;
      }
    }

    // Extract amount as a double, then call .abs() to strip any negative sign (-)
    final rawAmount = (json['amount'] ?? 0.0).toDouble();
    final absoluteAmount = rawAmount.abs();

    return TransactionItem(
      id: json['id'] ?? 0,
      typeString: json['type'] ?? '',
      amount: absoluteAmount,
      currency: json['currency'] ?? 'NGN',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      type: mapType(json['type'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': typeString,
    'amount': amount,
    'currency': currency,
    'createdAt': createdAt.toIso8601String(),
  };

  // Helper for UI logic
  bool get isCredit => type == TransactionType.tripEarning;

  String get displayTitle {
    switch (type) {
      case TransactionType.tripEarning:
        return "Trip Earning";
      default:
        return typeString.replaceAll('_', ' ');
    }
  }
}

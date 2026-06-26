import 'package:intl/intl.dart';

class WalletSummary {
  final double currentBalance;
  final double totalEarnings;
  final double pendingPayout;
  final String currency;
  final Map<String, double> earningsByWeekday;

  WalletSummary({
    required this.currentBalance,
    required this.totalEarnings,
    required this.pendingPayout,
    required this.currency,
    required this.earningsByWeekday,
  });

  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    // Safely cast and convert the API's inner dynamic values to doubles
    final rawEarnings = json['earningsByWeekday'] as Map<String, dynamic>? ?? {};
    final parsedEarnings = rawEarnings.map(
          (key, value) => MapEntry(key.toLowerCase(), ((value ?? 0.0) as num).toDouble()),
    );

    return WalletSummary(
      // Matching the exact keys from your updated API response
      currentBalance: (json['currentBalance'] ?? 0.0).toDouble(),
      totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
      pendingPayout: (json['pendingPayout'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      earningsByWeekday: parsedEarnings,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentBalance': currentBalance,
    'totalEarnings': totalEarnings,
    'pendingPayout': pendingPayout,
    'currency': currency,
    'earningsByWeekday': earningsByWeekday,
  };

  /// Real-time helper to extract today's earnings dynamically
  double get todayEarnings {
    // DateFormat('EEEE') returns 'Sunday', 'Monday', etc.
    final String currentDay = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    return earningsByWeekday[currentDay] ?? 0.0;
  }
}
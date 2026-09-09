// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../core/models/wallet/wallet_summary.dart';
// import '../../../widgets/currency_formatter_widget.dart';
// import '../../../widgets/graphs/weekly_bar_chart.dart';
//
// // class WeeklyEarningsCard extends StatelessWidget {
// //   final double totalAmount;
// //   final Map<String, double> breakdown; // Explicitly typed to Map<String, double>
// //
// //   const WeeklyEarningsCard({
// //     super.key,
// //     required this.totalAmount,
// //     required this.breakdown,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // Transform the raw API Map ('monday': 40.0) into UI Chart Format ('MON': 40.0)
// //     final Map<String, double> chartData = breakdown.map(
// //           (key, value) => MapEntry(
// //         key.substring(0, 3).toUpperCase(),
// //         value,
// //       ),
// //     );
// //
// //     // Determine the current day to highlight it in the chart (e.g., "TUE")
// //     final String currentDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();
// //
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         border: Border.all(color: const Color(0xFFF0F2F5)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.02),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     "Weekly Earnings",
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF1B2559),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     DateRangeHelper.getWeeklyRange(),
// //                     style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
// //                   ),
// //                 ],
// //               ),
// //               CurrencyFormatterWidget(
// //                 amount: "$totalAmount",
// //                 style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Color(0xFF1B2559),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 30),
// //           if (breakdown.isEmpty)
// //             const SizedBox(
// //               height: 200,
// //               child: Center(child: Text("No earnings data for this week")),
// //             )
// //           else
// //             SizedBox(
// //               height: 200,
// //               child: WeeklyBarChart(
// //                 weeklyData: chartData,
// //                 selectedDay: currentDay,
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class WeeklyEarningsCard extends StatelessWidget {
//   final double? totalAmount;
//   final Map<String, double>? breakdown;
//   final WeekInfo? weekInfo;
//   final String? currency;
//
//   const WeeklyEarningsCard({
//     super.key,
//     this.totalAmount,
//     this.breakdown,
//     this.weekInfo,
//     this.currency,
//   });
//
//   /// Calculates weekly total from breakdown map if `totalAmount` is null
//   double get _calculatedWeekTotal {
//     if (totalAmount != null) return totalAmount!;
//     if (breakdown == null || breakdown!.isEmpty) return 0.0;
//     return breakdown!.values.fold(0.0, (sum, amount) => sum + amount);
//   }
//
//   /// Dynamically formats the week date range (e.g., "Aug 23 - Aug 29, 2026")
//   String _getFormattedDateRange() {
//     if (weekInfo == null ||
//         weekInfo!.startLocalDate.isEmpty ||
//         weekInfo!.endLocalDate.isEmpty) {
//       return '';
//     }
//
//     try {
//       final startDate = DateTime.parse(weekInfo!.startLocalDate);
//       final endDate = DateTime.parse(weekInfo!.endLocalDate);
//
//       final startFormat = DateFormat('MMM d').format(startDate);
//       final endFormat = DateFormat('MMM d, yyyy').format(endDate);
//
//       return '$startFormat - $endFormat';
//     } catch (_) {
//       return '${weekInfo!.startLocalDate} - ${weekInfo!.endLocalDate}';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final safeBreakdown = breakdown ?? {};
//     final safeWeekTotal = _calculatedWeekTotal;
//
//     // Map raw API keys ('monday': 40.0) into UI Chart Format ('MON': 40.0) safely
//     final Map<String, double> chartData = safeBreakdown.map(
//           (key, value) => MapEntry(
//         key.length >= 3 ? key.substring(0, 3).toUpperCase() : key.toUpperCase(),
//         value,
//       ),
//     );
//
//     // Get current day abbreviation for bar highlighting
//     final String currentDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();
//     final String formattedRange = _getFormattedDateRange();
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFFF0F2F5)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Weekly Earnings",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1B2559),
//                     ),
//                   ),
//                   if (formattedRange.isNotEmpty) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       formattedRange,
//                       style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//                     ),
//                   ],
//                 ],
//               ),
//               CurrencyFormatterWidget(
//                 amount: safeWeekTotal.toStringAsFixed(2),
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1B2559),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 30),
//           if (safeBreakdown.isEmpty)
//             const SizedBox(
//               height: 200,
//               child: Center(
//                 child: Text(
//                   "No earnings data for this week",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             )
//           else
//             SizedBox(
//               height: 200,
//               child: WeeklyBarChart(
//                 weeklyData: chartData,
//                 selectedDay: currentDay,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ryto_driver/core/models/wallet/wallet_summary.dart';

import '../../../widgets/currency_formatter_widget.dart';
import '../../../widgets/graphs/weekly_bar_chart.dart';

class WeeklyEarningsCard extends StatelessWidget {
  final WalletSummary walletData;

  const WeeklyEarningsCard({
    super.key,
    required this.walletData,
  });

  /// Formats the API's weekly range (e.g., "Aug 23 - Aug 29, 2026")
  String get _formattedDateRange {
    final week = walletData.week;
    if (week.startLocalDate.isEmpty || week.endLocalDate.isEmpty) {
      return '';
    }

    try {
      final startDate = DateTime.parse(week.startLocalDate);
      final endDate = DateTime.parse(week.endLocalDate);

      final startFormat = DateFormat('MMM d').format(startDate);
      final endFormat = DateFormat('MMM d, yyyy').format(endDate);

      return '$startFormat - $endFormat';
    } catch (_) {
      return '${week.startLocalDate} - ${week.endLocalDate}';
    }
  }

  /// Ensures days are sorted strictly in Sunday -> Saturday sequence for the chart
  Map<String, double> get _orderedChartData {
    const daysOrder = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
    final Map<String, double> chartData = {};

    for (final day in daysOrder) {
      final key = day.toUpperCase();
      // Look up matching key in API response breakdown
      final amount = walletData.earningsByWeekday.entries
          .firstWhere(
            (e) => e.key.toLowerCase().startsWith(day),
        orElse: () => const MapEntry('', 0.0),
      )
          .value;

      chartData[key] = amount;
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    // Current day highlight (e.g., "WED")
    final String currentDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F2F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Weekly Earnings",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2559),
                    ),
                  ),
                  if (_formattedDateRange.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formattedDateRange,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ],
              ),
              CurrencyFormatterWidget(
                amount: walletData.weekEarnings.toStringAsFixed(2), // Current week's total earnings only
                // currencySymbol: walletData.currency,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: WeeklyBarChart(
              weeklyData: _orderedChartData,
              selectedDay: currentDay,
            ),
          ),
        ],
      ),
    );
  }
}
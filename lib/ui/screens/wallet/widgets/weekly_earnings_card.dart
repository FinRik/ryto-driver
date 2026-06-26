import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/helpers/date_range_helper.dart';
import '../../../widgets/currency_formatter_widget.dart';
import '../../../widgets/graphs/weekly_bar_chart.dart';

// class WeeklyEarningsCard extends StatefulWidget {
//   final String dateRange;
//   final double totalAmount;
//   final String currency;
//
//   const WeeklyEarningsCard({
//     super.key,
//     required this.dateRange,
//     required this.totalAmount,
//     required this.currency,
//   });
//
//   @override
//   State<WeeklyEarningsCard> createState() => _WeeklyEarningsCardState();
// }
//
// class _WeeklyEarningsCardState extends State<WeeklyEarningsCard> {
//
//   final Map<String, double> earnings = {
//     "MON": 120,
//     "TUE": 250,
//     "WED": 840,
//     "THU": 550,
//     "FRI": 400,
//     "SAT": 200,
//     "SUN": 180,
//   };
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFFF0F2F5)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Weekly Earnings",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
//                   Text(widget.dateRange, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//                 ],
//               ),
//               Text("\$${widget.totalAmount.toStringAsFixed(2)}",
//                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
//             ],
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             height: 200,
//             child: WeeklyBarChart(
//               weeklyData: earnings,
//               selectedDay: "THU", // Highlights Thursday like in the screenshot
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//iteration 2
// class WeeklyEarningsCard extends StatelessWidget {
//   final double totalAmount;
//   final Map<String, dynamic> breakdown;
//
//   const WeeklyEarningsCard({
//     super.key,
//     required this.totalAmount,
//     required this.breakdown,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // final symbol = currency == "NGN" ? "₦" : "\$";
//
//     // Map the breakdown list to a format the WeeklyBarChart expects
//     // If the list is empty, we provide an empty map to avoid crashes
//     final Map<String, double> chartData = {
//       for (var item in breakdown)
//         item.day.substring(0, 3).toUpperCase(): item.amount,
//     };
//
//     // Determine the current day to highlight it in the chart
//     final String currentDay = DateFormat(
//       'EEE',
//     ).format(DateTime.now()).toUpperCase();
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
//                   const SizedBox(height: 4),
//                   Text(
//                     DateRangeHelper.getWeeklyRange(),
//                     style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//                   ),
//                 ],
//               ),
//               CurrencyFormatterWidget(
//                 amount: "$totalAmount",
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1B2559),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 30),
//           if (breakdown.isEmpty)
//             const SizedBox(
//               height: 200,
//               child: Center(child: Text("No earnings data for this week")),
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

class WeeklyEarningsCard extends StatelessWidget {
  final double totalAmount;
  final Map<String, double> breakdown; // Explicitly typed to Map<String, double>

  const WeeklyEarningsCard({
    super.key,
    required this.totalAmount,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    // Transform the raw API Map ('monday': 40.0) into UI Chart Format ('MON': 40.0)
    final Map<String, double> chartData = breakdown.map(
          (key, value) => MapEntry(
        key.substring(0, 3).toUpperCase(),
        value,
      ),
    );

    // Determine the current day to highlight it in the chart (e.g., "TUE")
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
                  const SizedBox(height: 4),
                  Text(
                    DateRangeHelper.getWeeklyRange(),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
              CurrencyFormatterWidget(
                amount: "$totalAmount",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          if (breakdown.isEmpty)
            const SizedBox(
              height: 200,
              child: Center(child: Text("No earnings data for this week")),
            )
          else
            SizedBox(
              height: 200,
              child: WeeklyBarChart(
                weeklyData: chartData,
                selectedDay: currentDay,
              ),
            ),
        ],
      ),
    );
  }
}
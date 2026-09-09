import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

//previous iteration
// class WeeklyBarChart extends StatelessWidget {
//   final Map<String, double> weeklyData;
//   final String selectedDay;
//
//   const WeeklyBarChart({
//     super.key,
//     required this.weeklyData,
//     this.selectedDay = "WED",
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceBetween,
//         maxY: weeklyData.values.reduce((a, b) => a > b ? a : b) * 1.2, // Add 20% padding to top
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchTooltipData: BarTouchTooltipData(
//             getTooltipColor: (group) => const Color(0xFF7B61FF), // Purple tooltip
//             // tooltipRoundedRadius: 8,
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               return BarTooltipItem(
//                 'Total\n',
//                 const TextStyle(color: Colors.white, fontSize: 10),
//                 children: [
//                   TextSpan(
//                     text: rod.toY.toInt().toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//         titlesData: FlTitlesData(
//           show: true,
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 final day = weeklyData.keys.elementAt(value.toInt());
//                 final isSelected = day == selectedDay;
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     day,
//                     style: TextStyle(
//                       color: isSelected ? const Color(0xFF0061FF) : Colors.grey,
//                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                       fontSize: 12,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//         gridData: const FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//         barGroups: _generateGroups(),
//       ),
//     );
//   }
//
//   List<BarChartGroupData> _generateGroups() {
//     return weeklyData.entries.toList().asMap().entries.map((entry) {
//       final index = entry.key;
//       final data = entry.value;
//       final isSelected = data.key == selectedDay;
//
//       return BarChartGroupData(
//         x: index,
//         barRods: [
//           BarChartRodData(
//             toY: data.value,
//             color: const Color(0xFF0061FF), // Primary Blue
//             width: 32,
//             borderRadius: BorderRadius.circular(8),
//             backDrawRodData: BackgroundBarChartRodData(
//               show: false,
//             ),
//           ),
//         ],
//         // Logic for the tooltip indicator (the small triangle/dot)
//         showingTooltipIndicators: isSelected ? [0] : [],
//       );
//     }).toList();
//   }
// }

class WeeklyBarChart extends StatelessWidget {
  final Map<String, double> weeklyData;
  final String selectedDay;

  const WeeklyBarChart({
    super.key,
    required this.weeklyData,
    this.selectedDay = "WED",
  });

  @override
  Widget build(BuildContext context) {
    // Safety check: prevent crashes if all day values are 0.0
    final maxVal = weeklyData.values.isNotEmpty
        ? weeklyData.values.reduce((a, b) => math.max(a, b))
        : 0.0;

    final computedMaxY = maxVal > 0 ? maxVal * 1.2 : 10.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: computedMaxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => const Color(0xFF7B61FF),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Total\n',
                const TextStyle(color: Colors.white, fontSize: 10),
                children: [
                  TextSpan(
                    text: rod.toY.toStringAsFixed(2), // Keeps cents readable
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= weeklyData.length || value.toInt() < 0) {
                  return const SizedBox.shrink();
                }
                final day = weeklyData.keys.elementAt(value.toInt());
                final isSelected = day == selectedDay;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF0061FF) : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: _generateGroups(),
      ),
    );
  }

  List<BarChartGroupData> _generateGroups() {
    return weeklyData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isSelected = data.key == selectedDay;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.value,
            color: const Color(0xFF0061FF),
            width: 32,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
        showingTooltipIndicators: isSelected ? [0] : [],
      );
    }).toList();
  }
}
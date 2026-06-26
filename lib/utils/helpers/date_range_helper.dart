import 'package:intl/intl.dart';

class DateRangeHelper {
  static String getWeeklyRange() {
    final now = DateTime.now();

    // Find the most recent Monday (assuming week starts on Monday)
    // now.weekday returns 1 for Monday, 7 for Sunday
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    final format = DateFormat('MMM d');
    return "${format.format(firstDayOfWeek)} - ${format.format(lastDayOfWeek)}";
  }
}
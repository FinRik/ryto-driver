import 'package:intl/intl.dart';

class DateTimeHelper {
  static final DateFormat _displayFormat = DateFormat('dd / MM / yyyy');
  static final DateFormat _backendFormat = DateFormat('yyyy-MM-dd');

  // For showing in TextField (e.g., 15 / 01 / 1990)
  static String toDisplayFormat(DateTime date) {
    return _displayFormat.format(date);
  }

  // For backend (yyyy-MM-dd)
  static String toBackendFormat(DateTime date) {
    return _backendFormat.format(date);
  }

  // Parse from display format (15 / 01 / 1990) → DateTime
  static String? parseBackendFormat(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return null;
    }

    final constructDate = dateStr.split("/");
    final day = constructDate.first.trim();
    final month = constructDate[1].trim();
    final year = constructDate.last.trim();
    String formattedDate = "$year-$month-$day";

    try {
      return formattedDate;
    } catch (e) {
      return null;
    }
  }

  /// Extracts the date in 'yyyy-MM-dd' format
  static String extractDate(String isoString) {
    if (isoString.isEmpty) return '';

    DateTime parsedDate = DateTime.parse(isoString).toLocal();
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  /// Extracts the time in 'HH:mm' format (24-hour)
  static String extractTime(String isoString) {
    if (isoString.isEmpty) return '';

    DateTime parsedDate = DateTime.parse(isoString).toLocal();
    return DateFormat('HH:mm').format(parsedDate);
  }

  /// Bonus: Extracts time in 12-hour format with AM/PM (e.g., "12:38 PM")
  static String extractTime12Hour(String isoString) {
    if (isoString.isEmpty) return '';

    DateTime parsedDate = DateTime.parse(isoString).toLocal();
    return DateFormat('hh:mm a').format(parsedDate);
  }
}

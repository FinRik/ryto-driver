import 'package:intl/intl.dart';


class ArrivalEstimate {
  final String durationText; // The raw text from Google (e.g., "1 hour 45 mins")
  final int durationSeconds; // Raw seconds for calculations
  final DateTime destinationTime; // Raw timestamp
  final String source; // 'Google' or 'Haversine'

  ArrivalEstimate({
    required this.durationText,
    required this.durationSeconds,
    required this.destinationTime,
    required this.source,
  });

  /// Getter to format seconds into: 1h 45m, 30m, or 1m
  // Inside ArrivalEstimate model
  String get formattedArrivalTime {
    final timeFormat = DateFormat('h:mm a'); // e.g., 8:28 AM

    // Optional: Check if arrival is on a different day than departure
    // to add a "(+1)" or "Next Day" indicator
    return timeFormat.format(destinationTime);
  }

  String get formattedDuration {
    final duration = Duration(seconds: durationSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '1m'; // Default minimum
    }
  }

  /// Getter to format destination time into: 5:00, 4:30, etc.
  // String get formattedArrivalTime {
  //   // 'jm' provides 5:00 PM, 'Hm' provides 17:00.
  //   // For exactly "5:00" style:
  //   return DateFormat('h:mm').format(destinationTime);
  // }
}
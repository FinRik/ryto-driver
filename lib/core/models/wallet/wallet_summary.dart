import 'package:intl/intl.dart';

class WalletSummary {
  final double totalEarnings;
  final double todayEarnings;
  final DayInfo today;
  final double weekEarnings;
  final WeekInfo week;
  final double pendingPayout;
  final double currentBalance;
  final String currency;
  final Map<String, double> earningsByWeekday;

  WalletSummary({
    required this.totalEarnings,
    required this.todayEarnings,
    required this.today,
    required this.weekEarnings,
    required this.week,
    required this.pendingPayout,
    required this.currentBalance,
    required this.currency,
    required this.earningsByWeekday,
  });

  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    final rawEarnings =
        json['earningsByWeekday'] as Map<String, dynamic>? ?? {};
    final parsedEarnings = rawEarnings.map(
      (key, value) =>
          MapEntry(key.toLowerCase(), (value as num?)?.toDouble() ?? 0.0),
    );

    return WalletSummary(
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      todayEarnings: (json['todayEarnings'] as num?)?.toDouble() ?? 0.0,
      today: DayInfo.fromJson(json['today'] as Map<String, dynamic>? ?? {}),
      weekEarnings: (json['weekEarnings'] as num?)?.toDouble() ?? 0.0,
      week: WeekInfo.fromJson(json['week'] as Map<String, dynamic>? ?? {}),
      pendingPayout: (json['pendingPayout'] as num?)?.toDouble() ?? 0.0,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'NGN',
      earningsByWeekday: parsedEarnings,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalEarnings': totalEarnings,
    'todayEarnings': todayEarnings,
    'today': today.toJson(),
    'weekEarnings': weekEarnings,
    'week': week.toJson(),
    'pendingPayout': pendingPayout,
    'currentBalance': currentBalance,
    'currency': currency,
    'earningsByWeekday': earningsByWeekday,
  };

  /// Helper to get earnings for today based on client's local day name
  double get currentWeekdayEarnings {
    final String currentDay = DateFormat(
      'EEEE',
    ).format(DateTime.now()).toLowerCase();
    return earningsByWeekday[currentDay] ?? 0.0;
  }
}

class DayInfo {
  final String localDate;
  final String timezone;
  final String timezoneSource;

  DayInfo({
    required this.localDate,
    required this.timezone,
    required this.timezoneSource,
  });

  factory DayInfo.fromJson(Map<String, dynamic> json) {
    return DayInfo(
      localDate: json['localDate'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      timezoneSource: json['timezoneSource'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'localDate': localDate,
    'timezone': timezone,
    'timezoneSource': timezoneSource,
  };
}

class WeekInfo {
  final String startsOn;
  final String startLocalDate;
  final String endLocalDate;
  final int weekOffset;
  final bool isCurrentWeek;
  final String timezone;
  final String timezoneSource;

  WeekInfo({
    required this.startsOn,
    required this.startLocalDate,
    required this.endLocalDate,
    required this.weekOffset,
    required this.isCurrentWeek,
    required this.timezone,
    required this.timezoneSource,
  });

  factory WeekInfo.fromJson(Map<String, dynamic> json) {
    return WeekInfo(
      startsOn: json['startsOn'] as String? ?? '',
      startLocalDate: json['startLocalDate'] as String? ?? '',
      endLocalDate: json['endLocalDate'] as String? ?? '',
      weekOffset: json['weekOffset'] as int? ?? 0,
      isCurrentWeek: json['isCurrentWeek'] as bool? ?? false,
      timezone: json['timezone'] as String? ?? '',
      timezoneSource: json['timezoneSource'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'startsOn': startsOn,
    'startLocalDate': startLocalDate,
    'endLocalDate': endLocalDate,
    'weekOffset': weekOffset,
    'isCurrentWeek': isCurrentWeek,
    'timezone': timezone,
    'timezoneSource': timezoneSource,
  };
}

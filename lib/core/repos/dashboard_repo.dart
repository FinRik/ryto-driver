import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../utils/logger/logger.dart';
import '../models/trip/trip.dart';
import '../models/wallet/wallet_summary.dart';
import '../services/api_service.dart';

abstract class DashboardRepo {
  Future<int?> fetchTripsCount(String period);
  Future<WalletSummary?> fetchDailyEarnings({
    DateTime? weekStartDate,
    int weekOffset = 0,
    String? timezone,
  });
  Future<List<Trip>?> fetchCurrentTrips(String status);
}

class DashboardRepoImpl implements DashboardRepo {
  final ApiService _service;

  DashboardRepoImpl({required ApiService service}) : _service = service;

  @override
  Future<List<Trip>?> fetchCurrentTrips(String status) async {
    try {
      final result = await _service.fetchTrips(status);
      debugPrint("Current Trip Data: ${result.data?.toJson()}");
      return result.data?.data;
    } catch (e, stacktrace) {
      AppLogger.e(
        'Failed to fetch current trips',
        'DashboardRepo',
        e,
        stacktrace,
      );
      rethrow;
    }
  }

  @override
  Future<WalletSummary?> fetchDailyEarnings({
    DateTime? weekStartDate,
    int weekOffset = 0,
    String? timezone,
  }) async {
    // Format DateTime dynamically to YYYY-MM-DD string format
    final String? formattedWeekStart = weekStartDate != null
        ? DateFormat('yyyy-MM-dd').format(weekStartDate)
        : null;

    final res = await _service.fetchUserWallet(
      weekStart: formattedWeekStart,
      weekOffset: formattedWeekStart == null
          ? weekOffset
          : null, // weekStart overrides weekOffset
      timezone: timezone,
    );

    debugPrint("Wallet data: ${res.data?.toJson()}");
    return res.data;
  }

  @override
  Future<int?> fetchTripsCount(String period) async {
    final result = await _service.fetchTripsCount(period);
    debugPrint("Trip count data: ${result.data}");
    return result.data["totalCompleted"] ?? 0;
  }
}

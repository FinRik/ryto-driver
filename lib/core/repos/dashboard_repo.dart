import 'package:flutter/cupertino.dart';
import '../../utils/logger/logger.dart';
import '../models/trip/trip.dart';
import '../models/wallet/wallet_summary.dart';
import '../services/api_service.dart';

abstract class DashboardRepo {
  Future<int?> fetchTripsCount(String period);
  Future<WalletSummary?> fetchDailyEarnings();
  Future<List<Trip>?> fetchCurrentTrips(String status);
}

class DashboardRepoImpl implements DashboardRepo {
  final ApiService _service;

  DashboardRepoImpl({required ApiService service}) : _service = service;

  @override
  Future<List<Trip>?> fetchCurrentTrips(String status) async {
    try {
      final result = await _service.fetchTrips(status);
      debugPrint("Trip Stacktrace: ${result.data?.toJson()}");
      return result.data?.data;
    } catch (e, stacktrace) {
      AppLogger.e('Failed to fetch current trips', 'DashboardRepo', e, stacktrace);
      rethrow;
    }
  }

  @override
  Future<WalletSummary?> fetchDailyEarnings() async {
    final res = await _service.fetchUserWallet();
    debugPrint("Trip data: ${res.data?.toJson()}");
    return res.data;
  }

  @override
  Future<int?> fetchTripsCount(String period) async {
    final result = await _service.fetchTripsCount(period);
    debugPrint("Trip data: ${result.data?.toJson()}");
    return result.data["totalCompleted"] ?? 0;
  }
}

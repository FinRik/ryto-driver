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
      return result.data?.data;
    } catch (e, stacktrace){
      print("Trip Stacktrace: $stacktrace");
    }
    return [];
  }

  @override
  Future<WalletSummary?> fetchDailyEarnings() async {
    final res = await _service.fetchUserWallet();
    return res.data;
  }

  @override
  Future<int?> fetchTripsCount(String period) async {
    final result = await _service.fetchTripsCount(period);
    return result.data["totalCompleted"] ?? 0;
  }
}

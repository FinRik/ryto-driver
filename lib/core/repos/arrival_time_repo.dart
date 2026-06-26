import '../models/arrival_estimate.dart';
import '../services/arrival_time_service.dart';

abstract class ArrivalTimeRepo {
  Future<ArrivalEstimate> getArrivalData({
    required double sLat,
    required double sLng,
    required double eLat,
    required double eLng,
    DateTime? departureDateTime,
  });
}

class ArrivalTimeRepoImpl implements ArrivalTimeRepo {
  final ArrivalTimeService _service;

  ArrivalTimeRepoImpl(ArrivalTimeService service) : _service = service;

  @override
  Future<ArrivalEstimate> getArrivalData({
    required double sLat,
    required double sLng,
    required double eLat,
    required double eLng,
    DateTime? departureDateTime,
  }) async => await _service.fetchEstimate(
    sLat: sLat,
    sLng: sLng,
    eLat: eLat,
    eLng: eLng,
    startTime: departureDateTime,
  );
}

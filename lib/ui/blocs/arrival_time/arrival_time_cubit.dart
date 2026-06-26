import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/arrival_estimate.dart';
import '../../../core/repos/arrival_time_repo.dart';

class ArrivalTimeCubit extends Cubit<AsyncSnapshot<ArrivalEstimate>> {
  final ArrivalTimeRepo repo;

  ArrivalTimeCubit(this.repo) : super(const AsyncSnapshot.waiting());

  void fetchArrivalData({
    required double sLat,
    required double sLng,
    required double eLat,
    required double eLng,
    required DateTime departureDateTime,
  }) async {
    try {
      final data = await repo.getArrivalData(
        sLat: sLat,
        sLng: sLng,
        eLat: eLat,
        eLng: eLng,
        departureDateTime: departureDateTime,
      );
      emit(AsyncSnapshot.withData(ConnectionState.done, data));
    } catch (e) {
      emit(AsyncSnapshot.withError(ConnectionState.done, e));
    }
  }
}

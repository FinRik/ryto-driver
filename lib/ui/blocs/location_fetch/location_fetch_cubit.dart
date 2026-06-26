import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/lat_lng.dart';
import '../../../utils/helpers/location_utils.dart';

part 'location_fetch_state.dart';

class LocationFetchCubit extends Cubit<LocationFetchState> {
  LocationFetchCubit() : super(LocationFetchState.initial());

  Future<void> fetchLocation(
    LatLng address, {
    bool forceRefresh = false,
  }) async {
    // Prevent re-fetching if already loading or if data is successfully retrieved
    if (!forceRefresh &&
        (state.status == LocationFetchStatus.loading ||
            state.status == LocationFetchStatus.success)) {
      return;
    }

    emit(state.copyWith(status: LocationFetchStatus.loading));

    try {
      final location = await LocationUtils.getAddressFromCoordinates(address);
      emit(
        state.copyWith(status: LocationFetchStatus.success, location: location),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationFetchStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

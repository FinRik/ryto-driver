import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/lat_lng.dart';
import '../../../../core/models/trip/create_trip_request.dart';
import '../../../../core/models/trip/trip_cost_request.dart';
import '../../../../core/models/trip/trip_cost_summary.dart';
import '../../../../core/repos/booking_repo.dart';

part 'trip_setup_event.dart';
part 'trip_setup_state.dart';

class TripSetupBloc extends Bloc<TripSetupEvent, TripSetupState> {
  final BookingRepo repo;

  TripSetupBloc(this.repo) : super(TripSetupState.initial()) {
    on<UpdateTripDraft>((event, emit) {
      emit(
        state.copyWith(
          draft: event.updatedDraft,
          status: TripSetupStatus.initial,
        ),
      );
    });

    on<FetchBookingCostRequested>(_onFetchCost);
    on<CreateTripRequested>(_onCreateTrip);
    on<ResetTripSetup>((event, emit) => emit(TripSetupState.initial()));
  }

  Future<void> _onFetchCost(
    FetchBookingCostRequested event,
    Emitter<TripSetupState> emit,
  ) async {
    emit(state.copyWith(status: TripSetupStatus.loading));
    try {
      final request = (state.draft.copyWith(passengerSeats: 1));
      final response = await repo.fetchBookingCost(
        _mapDraftToRequest(request),
      );
      if (response != null) {
        emit(
          state.copyWith(
            status: TripSetupStatus.success,
            costSummary: response,
            successMessage: "",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: TripSetupStatus.failure,
            errorMessage: "Failed to calculate trip cost",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TripSetupStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateTrip(
    CreateTripRequested event,
    Emitter<TripSetupState> emit,
  ) async {
    emit(state.copyWith(status: TripSetupStatus.loading));
    try {
      final success = await repo.createTrip(state.draft);
      if (success) {
        emit(
          state.copyWith(
            status: TripSetupStatus.success,
            successMessage: "Trip created successfully!",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: TripSetupStatus.failure,
            errorMessage: "Failed to create trip.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TripSetupStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Helper to keep the BLoC clean
  TripCostRequest _mapDraftToRequest(CreateTripRequest draft) {
    return TripCostRequest(
      vehicleId: draft.vehicleId,
      seats: draft.passengerSeats,
      bookingLocation: draft.country,
      originLocation: LatLng(lat: draft.originLat!, lng: draft.originLng!),
      destinationLocation: LatLng(
        lat: draft.destinationLat!,
        lng: draft.destinationLng!,
      ),
      pickupLocation: LatLng(lat: draft.pickupLat, lng: draft.pickupLng),
      dropoffLocation: LatLng(lat: draft.dropoffLat, lng: draft.dropoffLng),
    );
  }
}
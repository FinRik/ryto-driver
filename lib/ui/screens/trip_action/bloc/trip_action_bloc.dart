import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/trip/safety_pin_request.dart';
import '../../../../core/repos/booking_repo.dart';

part 'trip_action_event.dart';
part 'trip_action_state.dart';

class TripActionsBloc extends Bloc<TripActionEvent, TripActionsState> {
  final BookingRepo repo;

  TripActionsBloc(this.repo) : super(TripActionsState()) {
    on<CompleteTripRequested>((event, emit) async {
      emit(
        state.copyWith(
          status: TripActionStatus.loading,
          processingId: event.tripId,
          lastAction: 'approve_trip',
        ),
      );
      try {
        final success = await repo.completeTrip(
          event.tripId,
          event.totalAmount,
        );
        if (success) {
          emit(
            state.copyWith(
              status: TripActionStatus.success,
              message: "Trip Approved",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: TripActionStatus.failure,
            message: "Failed to approve trip, Please try again later.",
          ),
        );
      }
    });

    on<CancelTripRequested>((event, emit) async {
      emit(
        state.copyWith(
          status: TripActionStatus.loading,
          processingId: event.tripId,
          lastAction: 'decline_trip',
        ),
      );
      try {
        final success = await repo.cancelTrip(event.tripId);
        if (success) {
          emit(
            state.copyWith(
              status: TripActionStatus.success,
              message: "Trip Declined",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: TripActionStatus.failure,
            message: "Failed to decline trip, Please try again later.",
          ),
        );
      }
    });

    on<ApproveBookingConfirmed>((event, emit) async {
      emit(
        state.copyWith(
          status: TripActionStatus.loading,
          processingId: event.bookingId.toString(),
          lastAction: 'approve_booking',
        ),
      );
      try {
        final success = await repo.approveTripBooking(
          event.tripId,
          event.bookingId,
        );
        if (success) {
          emit(
            state.copyWith(
              status: TripActionStatus.success,
              message: "Booking Approved",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: TripActionStatus.failure,
            message: "Failed to approve booking, Please try again later.",
          ),
        );
      }
    });

    on<DeclineBookingConfirmed>((event, emit) async {
      emit(
        state.copyWith(
          status: TripActionStatus.loading,
          processingId: event.bookingId.toString(),
          lastAction: 'decline_booking',
        ),
      );
      try {
        final success = await repo.declineTripBooking(
          event.reason,
          event.bookingId,
        );
        if (success) {
          emit(
            state.copyWith(
              status: TripActionStatus.success,
              message: "Booking Declined",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: TripActionStatus.failure,
            message: "Failed to decline booking, Please try again later.",
          ),
        );
      }
    });

    on<VerifyPassengerPinConfirmed>((event, emit) async {
      emit(
        state.copyWith(
          status: TripActionStatus.loading,
          processingId: event.tripId,
          lastAction: 'verify_pin',
        ),
      );
      try {
        final success = await repo.verifyPassengerPin(
          event.tripId,
          event.request,
        );
        if (success) {
          emit(
            state.copyWith(
              status: TripActionStatus.success,
              message: "Pin Verified",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: TripActionStatus.failure,
            message: "Failed to verify pin, Please try again later.",
          ),
        );
      }
    });

    on<VerifyPassengerPinsConfirmed>((event, emit) async {
      emit(
        state.copyWith(
          status: TripActionStatus.loading,
          processingId: event.tripId,
          lastAction: 'verify_pins',
        ),
      );
      try {
        final success = await repo.verifyPassengerPins(
          event.tripId,
          event.request,
        );
        if (success) {
          emit(
            state.copyWith(
              status: TripActionStatus.success,
              message: "Pins Verified",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: TripActionStatus.failure,
            message: "Failed to verify pins, Please try again later.",
          ),
        );
      }
    });

    on<ResetTripAction>((event, emit) {
      emit(
        TripActionsState(
          status: TripActionStatus.initial,
          message: null,
          processingId: null,
          lastAction: null,
        ),
      );
    });
  }
}

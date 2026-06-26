import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/network_exception.dart';
import '../../../../core/models/bookings/booking_summary.dart';
import '../../../../core/models/trip/trip.dart';
import '../../../../core/models/trip/trip_summary.dart';
import '../../../../core/repos/booking_repo.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final BookingRepo repo;

  TripsBloc(this.repo) : super(TripsState()) {
    // Fetch Trip List
    on<FetchTripsRequested>((event, emit) async {
      emit(state.copyWith(listStatus: TripListStatus.loading));
      try {
        final trips = await repo.fetchTrips(event.status);
        emit(
          state.copyWith(
            listStatus: TripListStatus.success,
            trips: trips ?? [],
          ),
        );
      } on NetworkException catch (e) {
        // Catches typed connection issues automatically
        emit(
          state.copyWith(
            listStatus: TripListStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        // Fallback for everything else (e.g. state assignment bugs)
        emit(
          state.copyWith(
            listStatus: TripListStatus.failure,
            errorMessage: "An unexpected error occurred: $e",
          ),
        );
      }
    });

    // Fetch Trip Details & Bookings
    on<FetchTripDetailsRequested>((event, emit) async {
      // Set both detail-related statuses to loading
      emit(
        state.copyWith(
          summaryStatus: TripSummaryStatus.loading,
          bookingStatus: TripBookingStatus.loading,
        ),
      );

      try {
        // Fetch in parallel
        final results = await Future.wait([
          repo.fetchTripSummary(event.id),
          repo.fetchTripBookings(event.id.toString()),
        ]);

        emit(
          state.copyWith(
            summaryStatus: TripSummaryStatus.success,
            bookingStatus: TripBookingStatus.success,
            selectedTrip: results[0] as TripSummary?,
            bookings: results[1] as List<BookingSummary>? ?? [],
          ),
        );
      } on NetworkException catch (e) {
        emit(
          state.copyWith(
            listStatus: TripListStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e, stacktrace) {
        emit(
          state.copyWith(
            summaryStatus: TripSummaryStatus.failure,
            bookingStatus: TripBookingStatus.failure,
            errorMessage: "An unexpected error occurred",
          ),
        );

        debugPrint("Print Stacktrace");
        debugPrint("$stacktrace");
      }
    });

    on<FetchTripBookingsRequested>((event, emit) async {
      emit(state.copyWith(bookingStatus: TripBookingStatus.loading));

      try {
        final bookings = await repo.fetchTripBookings(
          event.tripId.toString(),
          /// Booking Status includes
          /// 'PENDING', 'DRIVER_ACCEPTED', 'DRIVER_REJECTED', '
          bookingStatus: event.bookingStatus,
        );

        emit(
          state.copyWith(
            bookingStatus: TripBookingStatus.success,
            bookings: bookings ?? [],
          ),
        );
      } on NetworkException catch (e) {
        emit(
          state.copyWith(
            listStatus: TripListStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            bookingStatus: TripBookingStatus.failure,
            errorMessage: "An unexpected error occurred: $e",
          ),
        );
      }
    });
  }
}

part of "trips_bloc.dart";

abstract class TripsEvent extends Equatable {
  const TripsEvent();
  @override
  List<Object?> get props => [];
}

// Still needed to load the lists (Scheduled, Completed, Cancelled)
class FetchTripsRequested extends TripsEvent {
  final String status;
  const FetchTripsRequested(this.status);

  @override
  List<Object?> get props => [status];
}

// Still needed to load the specific summary page
class FetchTripDetailsRequested extends TripsEvent {
  final String id;
  const FetchTripDetailsRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchTripBookingsRequested extends TripsEvent {
  final String tripId;
  final String? bookingStatus;
  const FetchTripBookingsRequested(this.tripId, {this.bookingStatus});

  @override
  List<Object?> get props => [tripId, bookingStatus];
}
part of "trips_bloc.dart";

// Trips States
enum TripListStatus { initial, loading, success, failure }
enum TripSummaryStatus { initial, loading, success, failure }
enum TripBookingStatus { initial, loading, success, failure }

class TripsState {
  // Data
  final List<Trip> trips;
  final TripSummary? selectedTrip;
  final List<BookingSummary> bookings;

  // Statuses
  final TripListStatus listStatus;
  final TripSummaryStatus summaryStatus;
  final TripBookingStatus bookingStatus;

  // Errors
  final String? errorMessage;

  TripsState({
    this.trips = const [],
    this.selectedTrip,
    this.bookings = const [],
    this.listStatus = TripListStatus.initial,
    this.summaryStatus = TripSummaryStatus.initial,
    this.bookingStatus = TripBookingStatus.initial,
    this.errorMessage,
  });

  TripsState copyWith({
    List<Trip>? trips,
    TripSummary? selectedTrip,
    List<BookingSummary>? bookings,
    TripListStatus? listStatus,
    TripSummaryStatus? summaryStatus,
    TripBookingStatus? bookingStatus,
    String? errorMessage,
  }) {
    return TripsState(
      trips: trips ?? this.trips,
      selectedTrip: selectedTrip ?? this.selectedTrip,
      bookings: bookings ?? this.bookings,
      listStatus: listStatus ?? this.listStatus,
      summaryStatus: summaryStatus ?? this.summaryStatus,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
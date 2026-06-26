part of "booking_cost_cubit.dart";

abstract class BookingCostState {}

class BookingCostLoading extends BookingCostState {}

class BookingCostLoaded extends BookingCostState {
  final TripCostSummary summary;
  BookingCostLoaded(this.summary);
}

class BookingCostError extends BookingCostState {
  final String message;
  BookingCostError(this.message);
}
part of 'trip_action_bloc.dart';

abstract class TripActionEvent extends Equatable {
  const TripActionEvent();

  @override
  List<Object?> get props => [];
}

/// 1. Triggered when the user confirms trip approval
class CompleteTripRequested extends TripActionEvent {
  final String tripId;
  final int totalAmount;

  const CompleteTripRequested({
    required this.tripId,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [tripId, totalAmount];
}

/// 2. Triggered when the user confirms declining the trip
class CancelTripRequested extends TripActionEvent {
  final String tripId;

  const CancelTripRequested(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

/// 3. Triggered when a specific bookings is approved
class ApproveBookingConfirmed extends TripActionEvent {
  final int tripId;
  final int bookingId;

  const ApproveBookingConfirmed({
    required this.tripId,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [tripId, bookingId];
}

/// 4. Triggered when a specific bookings is declined
class DeclineBookingConfirmed extends TripActionEvent {
  // final int tripId;
  final int bookingId;
  final String reason;

  const DeclineBookingConfirmed({
    // required this.tripId,
    required this.bookingId,
    required this.reason,

  });

  @override
  List<Object?> get props => [reason, bookingId];
}

/// 5. Triggered when passenger pins are submitted for verification
class VerifyPassengerPinConfirmed extends TripActionEvent {
  final String tripId;
  final PinVerification request;

  const VerifyPassengerPinConfirmed({
    required this.tripId,
    required this.request,
  });

  @override
  List<Object?> get props => [tripId, request];
}

class VerifyPassengerPinsConfirmed extends TripActionEvent {
  final String tripId;
  final SafetyPinRequest request;

  const VerifyPassengerPinsConfirmed({
    required this.tripId,
    required this.request,
  });

  @override
  List<Object?> get props => [tripId, request];
}

/// Use this to reset the state when the bottom sheet or modal is closed
class ResetTripAction extends TripActionEvent {}
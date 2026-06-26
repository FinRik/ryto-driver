part of 'trip_action_bloc.dart';

enum TripActionStatus { initial, loading, success, failure }

class TripActionsState {
  final TripActionStatus status;
  final String? message;
  // Track which specific ID (trip or bookings) is currently being processed
  final String? processingId;
  final String? lastAction; // e.g., 'verify', 'approve_trip', 'decline_booking'

  TripActionsState({
    this.status = TripActionStatus.initial,
    this.message,
    this.processingId,
    this.lastAction,
  });

  TripActionsState copyWith({
    TripActionStatus? status,
    String? message,
    String? processingId,
    String? lastAction,
  }) {
    return TripActionsState(
      status: status ?? this.status,
      message: message ?? this.message,
      processingId: processingId ?? this.processingId,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}
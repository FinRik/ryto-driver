part of "location_fetch_cubit.dart";

enum LocationFetchStatus { initial, loading, success, error }

class LocationFetchState {
  final LocationFetchStatus status;
  final LatLng? location;
  final String? errorMessage;

  const LocationFetchState({
    required this.status,
    this.location,
    this.errorMessage,
  });

  // Factory for the starting state
  factory LocationFetchState.initial() => const LocationFetchState(
    status: LocationFetchStatus.initial,
  );

  // Helper method to easily copy the state with updated values
  LocationFetchState copyWith({
    LocationFetchStatus? status,
    LatLng? location,
    String? errorMessage,
  }) {
    return LocationFetchState(
      status: status ?? this.status,
      location: location ?? this.location,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
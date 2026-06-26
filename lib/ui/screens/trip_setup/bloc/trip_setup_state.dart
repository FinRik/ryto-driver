part of "trip_setup_bloc.dart";

enum TripSetupStatus { initial, loading, success, failure }

class TripSetupState extends Equatable {
  final TripSetupStatus status;
  final CreateTripRequest draft;
  final TripCostSummary? costSummary;
  final String? errorMessage;
  final String? successMessage;

  const TripSetupState({
    this.status = TripSetupStatus.initial,
    required this.draft,
    this.costSummary,
    this.errorMessage,
    this.successMessage,
  });

  factory TripSetupState.initial() =>
      TripSetupState(draft: CreateTripRequest.empty());

  TripSetupState copyWith({
    TripSetupStatus? status,
    CreateTripRequest? draft,
    TripCostSummary? costSummary,
    String? errorMessage,
    String? successMessage,
  }) {
    return TripSetupState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      costSummary: costSummary ?? this.costSummary,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    draft,
    costSummary,
    errorMessage,
    successMessage,
  ];
}

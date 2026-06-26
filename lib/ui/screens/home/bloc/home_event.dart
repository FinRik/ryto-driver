part of "home_bloc.dart";

enum OnboardingStep { verification, vehicle, background, preference, payout }

abstract class HomeEvent extends Equatable {}

class FetchDashboardDataEvent extends HomeEvent {
  final String tripStatus;
  FetchDashboardDataEvent({this.tripStatus = "SCHEDULED"});

  @override
  List<Object?> get props => [tripStatus];
}

class UpdateOnboardingState extends HomeEvent {
  final ActionStatus status;
  final OnboardingStep type;
  UpdateOnboardingState({required this.status, required this.type});

  @override
  List<Object?> get props => [status, type];
}

class StartOnboardingSyncEvent extends HomeEvent {
  StartOnboardingSyncEvent();

  @override
List<Object?> get props => [];
}
class CompleteOnboardingSyncEvent extends HomeEvent {
  CompleteOnboardingSyncEvent();

  @override
List<Object?> get props => [];
}

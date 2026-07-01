part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }
enum OnboardingFetchStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final OnboardingFetchStatus onboardingStatus;
  final int? tripsCount;
  final WalletSummary? dailyEarnings;
  final List<Trip>? currentTrips;
  final String? errorMessage;

  // onboarding status
  final ActionStatus verification;
  final ActionStatus vehicle;
  final ActionStatus background;
  final ActionStatus preference;
  final ActionStatus payout;

  const HomeState({
    this.status = HomeStatus.initial,
    this.onboardingStatus = OnboardingFetchStatus.initial,
    this.tripsCount,
    this.dailyEarnings,
    this.currentTrips,
    this.errorMessage,

    // onboarding status
    this.verification = ActionStatus.notSet,
    this.vehicle = ActionStatus.notSet,
    this.background = ActionStatus.notSet,
    this.preference = ActionStatus.notSet,
    this.payout = ActionStatus.notSet,
  });

  bool isFullyOnboarded(String countryCode) {
    bool base =
        verification == ActionStatus.completed &&
        vehicle == ActionStatus.completed &&
        preference == ActionStatus.completed &&
        payout == ActionStatus.completed;

    if (countryCode == "US") {
      return base && background == ActionStatus.completed;
    }
    return base;
  }

  HomeState copyWith({
    HomeStatus? status,
    OnboardingFetchStatus? onboardingStatus,
    int? tripsCount,
    WalletSummary? dailyEarnings,
    List<Trip>? currentTrips,
    String? errorMessage,

    ActionStatus? verification,
    ActionStatus? vehicle,
    ActionStatus? background,
    ActionStatus? preference,
    ActionStatus? payout,
  }) {
    return HomeState(
      status: status ?? this.status,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      tripsCount: tripsCount ?? this.tripsCount,
      dailyEarnings: dailyEarnings ?? this.dailyEarnings,
      currentTrips: currentTrips ?? this.currentTrips,
      errorMessage: errorMessage ?? this.errorMessage,

      // onboarding status
      verification: verification ?? this.verification,
      vehicle: vehicle ?? this.vehicle,
      background: background ?? this.background,
      preference: preference ?? this.preference,
      payout: payout ?? this.payout,
    );
  }

  @override
  List<Object?> get props => [
    status,
    onboardingStatus,
    tripsCount,
    dailyEarnings,
    currentTrips,
    errorMessage,
    verification,
    vehicle,
    background,
    preference,
    payout,
  ];
}

part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }
enum OnboardingFetchStatus { initial, loading, success, failure }
enum TripsFetchStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final OnboardingFetchStatus onboardingStatus;
  final TripsFetchStatus tripsStatus;
  final int? tripsCount;
  final WalletSummary? dailyEarnings;
  final List<Trip>? currentTrips;
  final String? errorMessage;
  final String? tripsErrorMessage;

  // onboarding status
  final ActionStatus verification;
  final ActionStatus vehicle;
  final ActionStatus background;
  final ActionStatus preference;
  final ActionStatus payout;

  const HomeState({
    this.status = HomeStatus.initial,
    this.onboardingStatus = OnboardingFetchStatus.initial,
    this.tripsStatus = TripsFetchStatus.initial,
    this.tripsCount,
    this.dailyEarnings,
    this.currentTrips,
    this.errorMessage,
    this.tripsErrorMessage,

    // onboarding status
    this.verification = ActionStatus.notSet,
    this.vehicle = ActionStatus.notSet,
    this.background = ActionStatus.notSet,
    this.preference = ActionStatus.notSet,
    this.payout = ActionStatus.notSet,
  });

  bool isFullyOnboarded(String countryCode) {
    bool base =
        verification == ActionStatus.pending &&
        vehicle == ActionStatus.pending &&
        preference == ActionStatus.completed &&
        payout == ActionStatus.completed;

    // if (countryCode == "US") {
    //   return base && background == ActionStatus.completed;
    // }
    return base;
  }

  HomeState copyWith({
    HomeStatus? status,
    OnboardingFetchStatus? onboardingStatus,
    TripsFetchStatus? tripsStatus,
    int? tripsCount,
    WalletSummary? dailyEarnings,
    List<Trip>? currentTrips,
    String? errorMessage,
    String? tripsErrorMessage,

    ActionStatus? verification,
    ActionStatus? vehicle,
    ActionStatus? background,
    ActionStatus? preference,
    ActionStatus? payout,
  }) {
    return HomeState(
      status: status ?? this.status,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      tripsStatus: tripsStatus ?? this.tripsStatus,
      tripsCount: tripsCount ?? this.tripsCount,
      dailyEarnings: dailyEarnings ?? this.dailyEarnings,
      currentTrips: currentTrips ?? this.currentTrips,
      errorMessage: errorMessage ?? this.errorMessage,
      tripsErrorMessage: tripsErrorMessage ?? this.tripsErrorMessage,

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
    tripsStatus,
    tripsCount,
    dailyEarnings,
    currentTrips,
    errorMessage,
    tripsErrorMessage,
    verification,
    vehicle,
    background,
    preference,
    payout,
  ];
}

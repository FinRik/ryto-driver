import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../core/enums/action_status.dart';
import '../../../../core/models/trip/trip.dart';
import '../../../../core/models/wallet/wallet_summary.dart';
import '../../../../core/repos/dashboard_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final DashboardRepo _repo;

  HomeBloc(DashboardRepo repo) : _repo = repo, super(HomeState()) {
    on<FetchDashboardDataEvent>(_onFetchDashboardData);
    on<UpdateOnboardingState>(_onUpdateOnboardingState);

    // Handlers for the initialization barrier
    on<StartOnboardingSyncEvent>((event, emit) => emit(state.copyWith(
      onboardingStatus: OnboardingFetchStatus.loading,
    )));
    on<CompleteOnboardingSyncEvent>((event, emit) => emit(state.copyWith(
      onboardingStatus: OnboardingFetchStatus.success,
    )));
  }

  Future<void> _onFetchDashboardData(
    FetchDashboardDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final results = await Future.wait([
        _repo.fetchTripsCount("day"),
        _repo.fetchDailyEarnings(),
        _repo.fetchCurrentTrips(event.tripStatus),
      ]);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          tripsCount: results[0] as int?,
          dailyEarnings: results[1] as WalletSummary?,
          currentTrips: results[2] as List<Trip>?,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: "Failed to load trips",
        ),
      );
    }
  }

  void _onUpdateOnboardingState(
    UpdateOnboardingState event,
    Emitter<HomeState> emit,
  ) {
    switch (event.type) {
      case OnboardingStep.verification:
        emit(state.copyWith(verification: event.status));
      case OnboardingStep.vehicle:
        emit(state.copyWith(vehicle: event.status));
      case OnboardingStep.background:
        emit(state.copyWith(background: event.status));
      case OnboardingStep.preference:
        emit(state.copyWith(preference: event.status));
      case OnboardingStep.payout:
        emit(state.copyWith(payout: event.status));
    }
  }

  // --- HYDRATION ENGINE OPERATORS ---

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    try {
      // Safely parse individual enum names back out of storage string entries
      return HomeState(
        // We restore onboardingStatus to initial or success so it doesn't get stuck in a locked loading loop
        onboardingStatus: OnboardingFetchStatus.initial,
        status: HomeStatus.initial,

        verification: _parseActionStatus(json['verification']),
        vehicle: _parseActionStatus(json['vehicle']),
        background: _parseActionStatus(json['background']),
        preference: _parseActionStatus(json['preference']),
        payout: _parseActionStatus(json['payout']),
      );
    } catch (_) {
      return null; // If storage parsing breaks due to a structural change, fallback gracefully to initial state
    }
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    // Only serialize the specific onboarding step variables you requested
    return {
      'verification': state.verification.name,
      'vehicle': state.vehicle.name,
      'background': state.background.name,
      'preference': state.preference.name,
      'payout': state.payout.name,
    };
  }

  ActionStatus _parseActionStatus(dynamic jsonValue) {
    if (jsonValue == null) return ActionStatus.notSet;
    return ActionStatus.values.firstWhere(
          (e) => e.name == jsonValue,
      orElse: () => ActionStatus.notSet,
    );
  }
}

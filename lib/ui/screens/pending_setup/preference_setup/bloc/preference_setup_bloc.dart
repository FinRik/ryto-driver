import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/preference.dart';
import '../../../../../core/repos/pending_setup_repo.dart';

part 'preference_setup_event.dart';
part 'preference_setup_state.dart';

class PreferenceSetupBloc
    extends Bloc<PreferenceSetupEvent, PreferenceSetupState> {
  final PendingSetupRepo repo;

  PreferenceSetupBloc(this.repo) : super(PreferenceInitial()) {
    // Fetch Preferences
    on<FetchPreferences>((event, emit) async {
      emit(PreferenceLoading());
      try {
        // Updated: Repository should now return Future<PreferenceSetup?>
        final preferenceData = await repo.fetchDriverPreference();

        if (preferenceData != null) {
          emit(PreferenceLoaded(preferenceData));
        } else {
          emit(const PreferenceFailure("No preferences found"));
        }
      } catch (e) {
        emit(PreferenceFailure(e.toString()));
      }
    });

    // Set/Update Preferences
    on<SetPreferenceRequested>((event, emit) async {
      emit(SetPreferenceLoading());
      try {
        final success = await repo.setDriverPreference(
          idCheckRequired: event.idCheckRequired,
          packagesAllowed: event.packagesAllowed,
          smokingAllowed: event.smokingAllowed,
          musicAllowed: event.musicAllowed,
          petsAllowed: event.petsAllowed,
        );

        if (success) {
          emit(const PreferenceSuccess("Preferences updated successfully"));
        } else {
          emit(const PreferenceFailure("Failed to update preferences"));
        }
      } catch (e) {
        emit(PreferenceFailure(e.toString()));
      }
    });
  }
}

part of 'preference_setup_bloc.dart';

abstract class PreferenceSetupEvent extends Equatable {
  const PreferenceSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Fetches current profile from the server
class FetchPreferences extends PreferenceSetupEvent {}

/// Submits new toggle states to the server
class SetPreferenceRequested extends PreferenceSetupEvent {
  final bool idCheckRequired;
  final bool packagesAllowed;
  final bool smokingAllowed;
  final bool musicAllowed;
  final bool petsAllowed;

  const SetPreferenceRequested({
    required this.idCheckRequired,
    required this.packagesAllowed,
    required this.smokingAllowed,
    required this.musicAllowed,
    required this.petsAllowed,
  });

  @override
  List<Object?> get props => [
    idCheckRequired,
    packagesAllowed,
    smokingAllowed,
    musicAllowed,
    petsAllowed,
  ];
}
part of 'preference_setup_bloc.dart';

abstract class PreferenceSetupState extends Equatable {
  const PreferenceSetupState();
  @override
  List<Object?> get props => [];
}

class PreferenceInitial extends PreferenceSetupState {}
class PreferenceLoading extends PreferenceSetupState {}
class SetPreferenceLoading extends PreferenceSetupState {}

// New: Carries the actual data for the UI
class PreferenceLoaded extends PreferenceSetupState {
  final Preferences data;
  const PreferenceLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class PreferenceSuccess extends PreferenceSetupState {
  final String message;
  const PreferenceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PreferenceFailure extends PreferenceSetupState {
  final String error;
  const PreferenceFailure(this.error);

  @override
  List<Object?> get props => [error];
}
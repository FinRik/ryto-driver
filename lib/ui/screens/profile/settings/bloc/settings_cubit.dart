import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void togglePushNotifications(bool value) => emit(state.copyWith(pushNotifications: value));
  void toggleSound(bool value) => emit(state.copyWith(soundEnabled: value));
  void toggleEmailAlerts(bool value) => emit(state.copyWith(emailAlerts: value));
  void toggleHighQualityMaps(bool value) => emit(state.copyWith(highQualityMaps: value));
  void changeLanguage(String language) => emit(state.copyWith(selectedLanguage: language));

  // Automatically called by HydratedBloc to read saved data from storage
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromMap(json);
  }

  // Automatically called by HydratedBloc to write data whenever state emits
  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toMap();
  }
}
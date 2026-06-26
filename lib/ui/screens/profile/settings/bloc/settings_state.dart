part of 'settings_cubit.dart';

class SettingsState {
  final bool pushNotifications;
  final bool soundEnabled;
  final bool emailAlerts;
  final bool highQualityMaps;
  final String selectedLanguage;

  const SettingsState({
    this.pushNotifications = true,
    this.soundEnabled = true,
    this.emailAlerts = false,
    this.highQualityMaps = false,
    this.selectedLanguage = "English (US)",
  });

  // Create a copyWith method to safely mutate specific properties
  SettingsState copyWith({
    bool? pushNotifications,
    bool? soundEnabled,
    bool? emailAlerts,
    bool? highQualityMaps,
    String? selectedLanguage,
  }) {
    return SettingsState(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      highQualityMaps: highQualityMaps ?? this.highQualityMaps,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  // Convert State -> Map (To save into Hydrated Storage)
  Map<String, dynamic> toMap() {
    return {
      'pushNotifications': pushNotifications,
      'soundEnabled': soundEnabled,
      'emailAlerts': emailAlerts,
      'highQualityMaps': highQualityMaps,
      'selectedLanguage': selectedLanguage,
    };
  }

  // Convert Map -> State (To read from Hydrated Storage)
  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      pushNotifications: map['pushNotifications'] ?? true,
      soundEnabled: map['soundEnabled'] ?? true,
      emailAlerts: map['emailAlerts'] ?? false,
      highQualityMaps: map['highQualityMaps'] ?? false,
      selectedLanguage: map['selectedLanguage'] ?? "English (US)",
    );
  }
}
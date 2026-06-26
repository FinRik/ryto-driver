// theme_modes.dart
enum ThemeModeX { light, dark, system }

extension ThemeModeXHelpers on ThemeModeX {
  bool get isDark => this == ThemeModeX.dark;
  bool get isLight => this == ThemeModeX.light;
  String get storageKey => name;
}
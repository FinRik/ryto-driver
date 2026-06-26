// // theme_provider.dart
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ui/styles/app_colors.dart';
// import '../../ui/styles/app_dimensions.dart';
// import '../../ui/styles/app_text_styles.dart';
// import 'theme_modes.dart';
//
// final themeProvider = ChangeNotifierProvider<ThemeController>((ref) {
//   return ThemeController();
// });
//
// class ThemeController extends ChangeNotifier {
//   ThemeModeX _mode = ThemeModeX.system;
//   ThemeModeX get mode => _mode;
//
//   ThemeData get currentTheme => _mode.isDark ? darkTheme : lightTheme;
//
//   ThemeData get lightTheme => ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       brightness: Brightness.light,
//       dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
//     ),
//     fontFamily: 'HostGrotesk',
//     scaffoldBackgroundColor: Colors.white,
//     // appBarTheme, cardTheme, elevatedButtonTheme, etc. can be customized here
//   );
//
//   ThemeData get darkTheme => ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       brightness: Brightness.dark,
//       dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
//     ),
//     fontFamily: 'HostGrotesk',
//     scaffoldBackgroundColor: const Color(0xFF0F0F0F),
//   );
//
//   late AppColors colors;
//   late AppTextStyles text;
//   late AppDimensions dims;
//
//   ThemeController() {
//     colors = AppColors(this);
//     text = AppTextStyles(this);
//     dims = AppDimensions(this);
//     _loadFromStorage();
//   }
//
//   Future<void> _loadFromStorage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString('theme_mode');
//     if (saved != null) {
//       try {
//         _mode = ThemeModeX.values.byName(saved);
//       } catch (_) {}
//     }
//     notifyListeners();
//   }
//
//   Future<void> setMode(ThemeModeX newMode) async {
//     if (_mode == newMode) return;
//     _mode = newMode;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('theme_mode', newMode.storageKey);
//     colors = AppColors(this); // refresh
//     text = AppTextStyles(this);
//     dims = AppDimensions(this);
//     notifyListeners();
//   }
//
//   Future<void> toggle() async {
//     if (_mode.isLight) {
//       await setMode(ThemeModeX.dark);
//     } else if (_mode.isDark) {
//       await setMode(ThemeModeX.system);
//     } else {
//       await setMode(ThemeModeX.light);
//     }
//   }
//
//   bool get isDark => _mode.isDark;
// }
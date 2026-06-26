import 'package:flutter/material.dart';

import '../../core/theme_manager/theme_provider.dart';

class AppColors {
  AppColors();

  // final ThemeController _theme;
  // AppColors(this._theme);

  static const int primaryColorValue = 0xff0060EB;
  static const int secondaryColorValue = 0xffE3FB20;
  static const int tertiaryColorValue = 0xff838794;

  static const Color primary = Color(primaryColorValue);
  static const Color secondary = Color(secondaryColorValue);
  static const Color tertiary = Color(tertiaryColorValue);

  static const Color error = Color(0xFFE52836);
  static const Color warning = Color(0xFFF6A609);
  static const Color success = Color(0xFF2AC769);


  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFC);
  static const Color grey100 = Color(0xFFEFF1F5);
  static const Color grey200 = Color(0xFFDDE1E6);
  static const Color grey300 = Color(0xFFCBD2D9);
  static const Color grey600 = Color(0xFF475467);
  static const Color grey900 = Color(0xFF101828);
  static const Color inactiveGrey = Color(0xFFCBD2D9);

  static const MaterialColor primarySwatch =
      MaterialColor(primaryColorValue, <int, Color>{
        50: Color(0xffe6effd),
        100: Color(0xffd9e7fc),
        200: Color(0xffb0cef9),
        300: Color(primaryColorValue),
        400: Color(0xff0056d4),
        500: Color(0xff004dbc),
        600: Color(0xff0048b0),
        700: Color(0xff003a8d),
        800: Color(0xff002b6a),
        900: Color(0xff002252),
      });

  static const MaterialColor secondarySwatch =
      MaterialColor(secondaryColorValue, <int, Color>{
        50: Color(0xfffcffe9),
        100: Color(0xfffbfede),
        200: Color(0xfff6feba),
        300: Color(secondaryColorValue),
        400: Color(0xffcce21d),
        500: Color(0xffb6c91a),
        600: Color(0xffaabc18),
        700: Color(0xff889713),
        800: Color(0xff66710e),
        900: Color(0xff4f580b),
      });

  static const MaterialColor tertiarySwatch =
      MaterialColor(tertiaryColorValue, <int, Color>{
        50: Color(0xffF9F9F9),
        100: Color(0xffE7E8E9),
        200: Color(0xffE4E7EC),
        300: Color(0xffE4E7EC),
        400: Color(0xff838794),
        500: Color(0xffE4E7EC),
        600: Color(0xff475467),
        700: Color(0xff344054),
        800: Color(0xff222328),
        900: Color(0xff101828),
      });

  static const LinearGradient primaryButtonGradient = LinearGradient(
    end: Alignment.bottomRight,
    begin: Alignment.topLeft,
    stops: [0.3, 0.7, 1],
    colors: [
      Color(0xFFFF5C00),
      Color(0xFFFF9F69),
      Color(0xFFCFFF81),
    ],
  );

  static const LinearGradient primaryTextGradient = LinearGradient(
    end: Alignment.bottomRight,
    begin: Alignment.topLeft,
    stops: [0.5, 0.9, 1.5],
    colors: [
      Color(0xFFFF5C00),
      Color(0xFFFF9F69),
      Color(0xFFCFFF81),
    ],
  );

  // ── Dynamic depending on current theme ──────────────────────────────────
  // Color get background => _theme.isDark ? const Color(0xFF0F0F0F) : white;
  // Color get surface => _theme.isDark ? const Color(0xFF1A1A1A) : grey50;
  // Color get surfaceVariant => _theme.isDark ? grey900 : grey100;
  // Color get textPrimary => _theme.isDark ? white : grey900;
  // Color get textSecondary => _theme.isDark ? grey300 : grey600;
  // Color get textTertiary => _theme.isDark ? grey600 : grey300;
  // Color get divider => _theme.isDark ? grey600 : grey200;

  Color get primaryTextOnPrimary => white;
  Color get primaryTextOnDark => white;

//   static const Color bgColor = Color(0xffFFFFFF);
//   static const Color secondaryBgColor = Color(primaryColorValue);
//   static const Color borderColor = Color(0xffE4E7EC);
//
//   static const background = Color(0xFF000000);
//   static const card = Color(0xFFF7F7F7);
//   static const textPrimary = Color(0xff676767);
//   static const textSecondary = Color(0xFF8E8E93);
//   static const destructive = Color(0xffB11010);
// }
}

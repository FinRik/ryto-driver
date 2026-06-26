import 'package:flutter/material.dart';

import '../../core/theme_manager/theme_provider.dart';
import 'app_colors.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles();

  // final ThemeController _theme;
  // late final AppColors _colors;
  // AppTextStyles(this._theme) : _colors = AppColors(_theme);

    static const TextStyle displayLarge = TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0F172A),
    );
    static const TextStyle displayMedium = TextStyle();
    static const TextStyle displaySmall = TextStyle();

    static const TextStyle headlineLarge = TextStyle();
    static const TextStyle headlineMedium = TextStyle();
    static const TextStyle headlineSmall = TextStyle();

    static const TextStyle titleLarge = TextStyle();
    static const TextStyle titleMedium = TextStyle();
    static const TextStyle titleSmall = TextStyle();

    static const TextStyle bodyLarge = TextStyle();
    static const TextStyle bodyMedium = TextStyle();
    static const TextStyle bodySmall = TextStyle();

    static const TextStyle labelLarge = TextStyle();
    static const TextStyle labelMedium = TextStyle();
    static const TextStyle labelSmall = TextStyle();

  // TextStyle get displayLarge => TextStyle(
  //   fontSize: 36,
  //   fontWeight: FontWeight.w700,
  //   height: 1.2,
  //   letterSpacing: -0.5,
  //   color: _colors.textPrimary,
  // );
  //
  // TextStyle get headlineLarge => TextStyle(
  //   fontSize: 32,
  //   fontWeight: FontWeight.w700,
  //   height: 1.25,
  //   color: _colors.textPrimary,
  // );
  //
  // TextStyle get titleLarge => TextStyle(
  //   fontSize: 22,
  //   fontWeight: FontWeight.w600,
  //   height: 1.3,
  //   color: _colors.textPrimary,
  // );
  //
  // TextStyle get bodyLarge => TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w400,
  //   height: 1.5,
  //   color: _colors.textPrimary,
  // );
  //
  // TextStyle get bodyMedium => TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w400,
  //   height: 1.43,
  //   color: _colors.textSecondary,
  // );
  //
  // TextStyle get labelLarge => TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w600,
  //   height: 1.43,
  //   color: _colors.textPrimary,
  // );

  // Add more styles as needed...
}

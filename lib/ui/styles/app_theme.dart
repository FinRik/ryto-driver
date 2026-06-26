import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const String primaryFont = 'HostGrotesk';

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
      brightness: Brightness.light,
      // Optional: tune contrast & appearance
      // or tonalSpot, expressive, etc.
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: primaryFont,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      primarySwatch: AppColors.primarySwatch,
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: primaryFont,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
    );
  }
}

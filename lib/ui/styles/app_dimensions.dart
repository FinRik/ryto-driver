import 'package:flutter/material.dart';

import '../../core/theme_manager/theme_provider.dart';

class AppDimensions {
  AppDimensions();

  // final ThemeController _theme;
  // AppDimensions(this._theme);

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const double paddingSm = 8;
  static const double paddingMd = 16;
  static const double paddingLg = 24;

  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;

  static const double buttonHeight = 52;

  // You can make some values theme-dependent in the future
  // double get cardElevation => _theme.isDark ? 0.5 : 1.0;
}
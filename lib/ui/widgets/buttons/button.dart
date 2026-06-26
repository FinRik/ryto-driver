import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_dimensions.dart';

class Button extends StatelessWidget {
  final void Function()? onTap;
  final IconData? icon;
  final bool showPrefixIcon;
  final bool showSuffixIcon;
  final Color? buttonColor;
  final String text;
  final TextStyle? textStyle;
  final BoxShape? borderShape;
  final double multiplyingFactor;
  final EdgeInsets? padding;
  final Color? iconColor;
  final bool isBusy;
  final bool fullWidth, enabled;
  final double? height;
  final Border? border;
  final IconData? suffixIcon;
  final Color? textColor;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final _ButtonType _type;

  const Button({
    super.key,
    this.multiplyingFactor = 1,
    this.fullWidth = true,
    this.icon,
    required this.text,
    this.buttonColor,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.borderShape,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.iconColor,
    this.isBusy = false,
    this.enabled = true,
    this.height = AppDimensions.buttonHeight,
    this.border,
    this.textColor,
    this.prefixWidget,
    this.suffixWidget,
  }) : _type = _ButtonType.primary;

  const Button.secondary({
    super.key,
    this.multiplyingFactor = 1,
    this.fullWidth = true,
    this.icon,
    required this.text,
    this.buttonColor = Colors.white,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.borderShape,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.iconColor,
    this.isBusy = false,
    this.enabled = true,
    this.height = AppDimensions.buttonHeight,
    this.border,
    this.textColor,
    this.prefixWidget,
    this.suffixWidget,
  }) : _type = _ButtonType.secondary;

  const Button.gradient({
    super.key,
    this.multiplyingFactor = 1,
    this.fullWidth = true,
    this.icon,
    required this.text,
    this.buttonColor = Colors.white,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.borderShape,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.iconColor,
    this.isBusy = false,
    this.enabled = true,
    this.height = 50,
    this.border,
    this.textColor,
    this.prefixWidget,
    this.suffixWidget,
  }) : _type = _ButtonType.gradient;

  const Button.outline({
    super.key,
    this.multiplyingFactor = 1,
    this.fullWidth = true,
    this.icon,
    required this.text,
    this.buttonColor = Colors.transparent,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.borderShape,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.iconColor = AppColors.primary,
    this.isBusy = false,
    this.enabled = true,
    this.height = AppDimensions.buttonHeight,
    this.border,
    this.textColor,
    this.prefixWidget,
    this.suffixWidget,
  }) : _type = _ButtonType.outline;

  const Button.cancel({
    super.key,
    this.multiplyingFactor = 1,
    this.fullWidth = true,
    this.icon,
    this.text = "Cancel",
    this.buttonColor = Colors.transparent,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.borderShape,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.iconColor = AppColors.primary,
    this.isBusy = false,
    this.enabled = true,
    this.height = AppDimensions.buttonHeight,
    this.border,
    this.textColor,
    this.prefixWidget,
    this.suffixWidget,
  }) : _type = _ButtonType.discard;

  @override
  Widget build(BuildContext context) {
    // final theme = ref.watch(themeProvider);
    return SizedBox(
      height: height,
      // width: MediaQuery.of(context).size.width * multiplyingFactor,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: !enabled
              ? AppColors.inactiveGrey
              // : buttonColor ?? intrinsicButtonColor(theme),
              : buttonColor ?? intrinsicButtonColor(),
          borderRadius: BorderRadius.circular(30),
          shape: borderShape ?? BoxShape.rectangle,
          // border: border ?? intrinsicBorderSide(theme),
          border: border ?? intrinsicBorderSide(),
          gradient: _type == _ButtonType.gradient
              ? AppColors.primaryButtonGradient
              : null,
        ),
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          radius: 30,
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (prefixWidget != null || showPrefixIcon && !isBusy) ...[
                  prefixWidget != null
                      ? prefixWidget!
                      : Icon(icon, color: textColor ?? Colors.white),
                  SizedBox(width: 11.08),
                ],
                Builder(
                  builder: (context) {
                    if (isBusy) {
                      return Transform.scale(
                        scale: .5,
                        child: CircularProgressIndicator(
                          color: textColor ?? Colors.white,
                          strokeWidth: 3.0,
                        ),
                      );
                    }
                    return Text(
                      text,
                      style: TextStyle(
                        // color: textColor ?? intrinsicTextColor(theme),
                        color: textColor ?? intrinsicTextColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ).merge(textStyle),
                    );
                  },
                ),
                // if (prefixWidget != null || showPrefixIcon && !isBusy) ...[
                if (suffixWidget != null || showSuffixIcon && !isBusy) ...[
                  SizedBox(width: 11.08),
                  suffixWidget != null
                      ? suffixWidget!
                      : Icon(
                          suffixIcon,
                          color: textColor ?? Colors.white,
                          // size: 32,
                        ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Color? intrinsicTextColor(ThemeNotifier theme) {
  Color? intrinsicTextColor() {
    switch (_type) {
      case _ButtonType.primary:
        // return theme.colors.primaryButtonTextColor;
        return AppColors.white;
      case _ButtonType.secondary:
        // return theme.colors.secondaryButtonTextColor;
        return AppColors.white;
      case _ButtonType.discard:
        return Colors.red;
      case _ButtonType.outline:
      case _ButtonType.gradient:
        return AppColors.primary;
    }
    // return theme.colors.textColor;
    return AppColors.grey100;
  }

  // Border? intrinsicBorderSide(ThemeNotifier theme) {
  Border? intrinsicBorderSide() {
    switch (_type) {
      case _ButtonType.discard:
        return Border.all(color: Colors.red);
      case _ButtonType.outline:
        return Border.all(color: AppColors.primary);
      case _ButtonType.secondary:
      case _ButtonType.gradient:
      case _ButtonType.primary:
        return null;
    }
  }

  // Color? intrinsicButtonColor(ThemeNotifier theme) {
  Color? intrinsicButtonColor() {
    switch (_type) {
      case _ButtonType.secondary:
      case _ButtonType.discard:
      case _ButtonType.gradient:
      case _ButtonType.primary:
        return AppColors.primary;
      case _ButtonType.outline:
        return Colors.transparent;
      default:
        return Color(0xFFE5E5E5);
    }
  }
}

enum _ButtonType { primary, secondary, gradient, discard, outline }

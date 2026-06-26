import 'package:flutter/material.dart';

import '../enums/bottom_sheet_type.dart';
import '../routes/router.dart';

/// [D] is data to be passed into the bottom sheet while
/// [R] is the response type expected from the bottom sheet
typedef SheetBuilder<D, R> =
    Widget Function(
      SheetRequest<D> request,
      void Function(SheetResponse<R?> response) completer,
    );

class BottomSheetService {
  Map<BottomSheetType, SheetBuilder>? _sheetBuilders;

  void setCustomSheetBuilders(Map<BottomSheetType, SheetBuilder> builders) {
    _sheetBuilders = {...?_sheetBuilders, ...builders};
  }

  Future<SheetResponse<R>?> showCustomBottomSheet<D, R>({
    D? data,
    String? title,
    String? desc,
    String? btnText,
    String? svgIcon,
    required BottomSheetType variant,
  }) async {
    final context = router.configuration.navigatorKey.currentContext;

    if (context == null) {
      debugPrint("Error: Navigator context is null. Sheet cannot be shown.");
      return null;
    }

    final builder = _sheetBuilders?[variant];
    if (builder == null) {
      throw Exception("No builder registered for BottomSheetType: $variant");
    }

    final result = await showModalBottomSheet<SheetResponse<R>>(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      useRootNavigator: true,
      builder: (context) => builder(
        SheetRequest<D>(
          data: data,
          desc: desc,
          title: title,
          btnText: btnText,
          svgIcon: svgIcon,
        ),
        (response) => _completeSheet(context, response),
      ),
    );
    return result ?? SheetResponse<R>(confirmed: false);
  }

  /// Completes the dialog and passes the [response] denoted by [R]to the caller
  void _completeSheet<R>(BuildContext context, SheetResponse<R> response) {
    Navigator.pop(context, response);
  }
}

class SheetResponse<R> {
  final bool confirmed;
  final R? data;

  SheetResponse({this.confirmed = false, this.data});
}

class SheetRequest<D> {
  final D? data;
  final String? title;
  final String? desc;
  final String? btnText;
  final String? svgIcon;

  SheetRequest({
    required this.data,
    this.title,
    this.desc,
    this.btnText,
    this.svgIcon,
  });
}

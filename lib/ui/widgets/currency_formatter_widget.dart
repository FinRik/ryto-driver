import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../app/app_setup_locator.dart';
import '../../core/setups/region_identity_setup.dart';

// typedef CurrencyBuilder = Widget Function(BuildContext, String);
//
// class CurrencyFormatterWidget extends StatelessWidget {
//   const CurrencyFormatterWidget({
//     super.key,
//     required this.amount,
//     this.symbolStyle,
//     this.style,
//     this.textColor,
//     this.builder,
//   });
//
//   final String amount;
//   final TextStyle? symbolStyle, style;
//   final Color? textColor;
//   final CurrencyBuilder? builder;
//
//   @override
//   Widget build(BuildContext context) {
//     final region = sl<RegionIdentity>();
//     final double value = double.tryParse(amount) ?? 0.0;
//
//     // 1. Initialize the formatter
//     final formatter = NumberFormat.currency(
//       locale: Localizations.localeOf(context).toString(),
//       symbol: region.currencySymbol, // e.g., "USD" or "$"
//       decimalDigits: 2,
//     );
//
//     // 2. Format the full string
//     final formattedValue = formatter.format(value);
//
//     // 3. Extract parts if you want to style them separately
//     // We find where the numbers start to separate symbol from digits
//     final numberRegex = RegExp(r'[0-9]');
//     final firstDigitIndex = formattedValue.indexOf(numberRegex);
//
//     final symbolPart = formattedValue.substring(0, firstDigitIndex);
//     final valuePart = formattedValue.substring(firstDigitIndex);
//
//     if (builder != null) {
//       return builder!(context, "$symbolPart $valuePart");
//     } else {
//       return Text.rich(
//         TextSpan(
//           text: "$symbolPart ",
//           style: TextStyle(
//             fontFamily: "Roboto",
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//             color: textColor,
//           ), // Lighter symbol
//           children: [
//             TextSpan(
//               text: valuePart,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: textColor,
//               ).merge(style),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../app/app_setup_locator.dart';
import '../../core/setups/region_identity_setup.dart';

typedef CurrencyBuilder = Widget Function(BuildContext context, String formattedAmount, double rawAmount);

class CurrencyFormatterWidget extends StatelessWidget {
  const CurrencyFormatterWidget({
    super.key,
    required this.amount,
    this.symbolStyle,
    this.style,
    this.textColor,
    this.builder,
  });

  final String amount;
  final TextStyle? symbolStyle, style;
  final Color? textColor;
  final CurrencyBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final region = sl<RegionIdentity>();

    final cleanAmountString = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    final value = double.tryParse(cleanAmountString) ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: region.currencySymbol,
      decimalDigits: 2,
    );

    final formattedValue = formatter.format(value);

    if (builder != null) {
      return builder!(context, formattedValue, value);
    }

    final numberRegex = RegExp(r'[0-9]');
    final firstDigitIndex = formattedValue.indexOf(numberRegex);

    if (firstDigitIndex == -1) {
      return Text(formattedValue, style: style);
    }

    final symbolPart = formattedValue.substring(0, firstDigitIndex);
    final valuePart = formattedValue.substring(firstDigitIndex);

    return Text.rich(
      TextSpan(
        text: "$symbolPart ",
        style: TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor,
        ).merge(symbolStyle),
        children: [
          TextSpan(
            text: valuePart,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ).merge(style),
          ),
        ],
      ),
    );
  }
}
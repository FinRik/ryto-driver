import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';


typedef OnChanged = Function(String, bool)?;

class OtpInputField extends StatefulWidget {
  final OtpFieldController? controller;
  final void Function()? onResendToken;
  final OnChanged? onChanged;
  final int fieldLength;

  const OtpInputField({
    super.key,
    this.controller,
    this.onResendToken,
    this.onChanged,
    this.fieldLength = 6,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final OtpFieldController fieldController;
  // String _value = '';

  @override
  void initState() {
    super.initState();
    fieldController = widget.controller ?? OtpFieldController();

    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return OTPTextField(
      length: widget.fieldLength,
      width: MediaQuery.of(context).size.width,
      textFieldAlignment: MainAxisAlignment.spaceBetween,
      fieldWidth: 70,
      obscureText: false,
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: 8,
      otpFieldStyle: OtpFieldStyle(
        borderColor: Color(0xffDBDBDC),
        backgroundColor: Color(0xffF6F7F9),
        enabledBorderColor: Color(0xffDBDBDC),
        focusBorderColor: Color(0xffDBDBDC),
        disabledBorderColor: Colors.red,
      ),
      spaceBetween: 8,
      contentPadding: const EdgeInsets.symmetric(vertical: 21),
      hasError: false,
      keyboardType: TextInputType.number,
      controller: fieldController,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      onChanged: (val) {
        _onOtpValidated(val, val.length == widget.fieldLength);
      },
      onCompleted: (val) {},
    );
  }

  void _onOtpValidated(String code, bool isValid) {
    setState(() => widget.onChanged!(code, isValid));
  }
}

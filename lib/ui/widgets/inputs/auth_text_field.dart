import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final TextInputType textInputType;
  final String? prefixSvg;
  final Widget? suffixIcon;
  final String? labelTip;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final double? bottomMargin;
  final TextStyle? labelStyle;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    this.onChanged,
    this.labelTip,
    required this.controller,
    this.prefixIcon = Icons.text_increase_rounded,
    required this.textInputType,
    this.prefixSvg,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
    this.bottomMargin,
    this.labelStyle,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  DateTime selectedDate = DateTime.now();
  bool hidePassword = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialEntryMode: DatePickerEntryMode.calendar,
      firstDate: DateTime(1920, 8),
      lastDate: selectedDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text =
            "${selectedDate.month} / ${selectedDate.day} / ${selectedDate.year}";
      });
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ).merge(widget.labelStyle ?? const TextStyle()),
            ),
            if (widget.labelTip != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tooltip(
                  message: widget.labelTip,
                  child: const Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.textInputType,
          obscureText:
              widget.textInputType == TextInputType.visiblePassword &&
              hidePassword,
          validator:
              widget.validator ??
              (val) {
                if (val?.isEmpty ?? true) return "This field cannot be empty";
                return null;
              },
          onChanged: (val) {
            if (widget.onChanged != null) {
              setState(() {
                widget.onChanged!(val);
              });
            }
          },
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          decoration: InputDecoration(
            filled: false,
            // fillColor: const Color(0xFF3E3E3E),
            hintText: widget.hint ?? "************",
            prefixIconConstraints: const BoxConstraints(minWidth: 64),
            hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            // prefixIcon: widget.prefixIcon != null
            //     ? Container(
            //         margin: const EdgeInsets.only(
            //           top: 8.0,
            //           bottom: 8.0,
            //           right: 16,
            //         ),
            //         decoration: const BoxDecoration(
            //           border: Border(
            //             right: BorderSide(color: Color(0xFF797979), width: 1),
            //           ),
            //         ),
            //         child: widget.prefixSvg != null
            //             ? SvgPicture.asset(widget.prefixSvg!)
            //             : Icon(widget.prefixIcon),
            //       )
            //     : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
            ),
            suffixIcon: widget.suffixIcon ?? suffixIcon(context),
          ),
        ),
        SizedBox(height: widget.bottomMargin ?? 16),
      ],
    );
  }

  Widget? suffixIcon(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.textInputType == TextInputType.datetime) {
      return InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: theme.splashColor,
        onTap: () => _selectDate(context),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.calendar_month),
        ),
      );
    } else if (widget.textInputType == TextInputType.visiblePassword) {
      return InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: theme.splashColor,
        onTap: () => togglePasswordVisibility(),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            hidePassword ? Icons.visibility : Icons.visibility_off,
            color: theme.colorScheme.secondary,
          ),
        ),
      );
    }
    return null;
  }
}

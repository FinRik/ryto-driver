import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final TextInputType? textInputType;
  final String? prefixSvg;
  final Widget? suffixIcon;
  final String? labelTip;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? margin;
  final TextStyle? labelStyle;
  final bool? filled, readOnly;
  final Color? fillColor;

  const GeneralTextField({
    super.key,
    required this.label,
    this.hint,
    this.onChanged,
    this.labelTip,
    required this.controller,
    this.prefixIcon = Icons.text_increase_rounded,
    this.textInputType,
    this.prefixSvg,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
    this.margin,
    this.labelStyle,
    this.filled,
    this.readOnly,
    this.fillColor,
  });

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  DateTime selectedDate = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Text(
                widget.label!,
                style: const TextStyle(
                  color: Color(0xff696E7E),
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
        SizedBox(height: 4.0),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.textInputType ?? TextInputType.text,
          readOnly: widget.readOnly ?? false,
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
            filled: widget.filled ?? false,
            fillColor: widget.fillColor,

            // const Color(0xFF3E3E3E),
            hintText: widget.hint ?? "Hint text",
            // prefixIconConstraints: const BoxConstraints(minWidth: 64),
            hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            prefixIcon: widget.prefixIcon != null
                ? Container(
                    margin: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 12,
                    ),
                    child: widget.prefixSvg != null
                        ? SvgPicture.asset(widget.prefixSvg!)
                        : Icon(widget.prefixIcon),
                  )
                : null,
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
        SizedBox(height: 12),
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
          child: Icon(Icons.keyboard_arrow_down_sharp),
        ),
      );
    }
    return null;
  }
}

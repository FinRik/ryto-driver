import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpiryDateField extends StatefulWidget {
  final String label;
  final bool isFullDate; // true = DD/MM/YYYY, false = MM/YY
  final TextEditingController? controller;
  final String? labelTip;
  final TextStyle? labelStyle;

  const ExpiryDateField({
    super.key,
    required this.label,
    this.isFullDate = false,
    this.controller,
    this.labelTip,
    this.labelStyle,
  });

  @override
  State<ExpiryDateField> createState() => _ExpiryDateFieldState();
}

class _ExpiryDateFieldState extends State<ExpiryDateField> {
  late TextEditingController _controller;
  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,           // The picker starts focused on today
      firstDate: now,             // This prevents selecting any date BEFORE today
      lastDate: DateTime(2101),   // The furthest possible expiry date
    );

    if (picked != null) {
      String formatted;
      if (widget.isFullDate) {
        // DD/MM/YYYY
        formatted =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      } else {
        // MM/YY
        formatted =
            "${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}";
      }

      setState(() {
        _controller.text = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ).merge(widget.labelStyle),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            // 8 digits for DDMMYYYY, 4 digits for MMYY
            LengthLimitingTextInputFormatter(widget.isFullDate ? 8 : 4),
            DateInputFormatter(isFullDate: widget.isFullDate),
          ],
          decoration: InputDecoration(
            hintText: widget.isFullDate ? 'DD/MM/YYYY' : 'MM/YY',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined, size: 20),
              onPressed: () => _selectDate(context),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  final bool isFullDate;
  DateInputFormatter({required this.isFullDate});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      int index = i + 1;

      if (isFullDate) {
        // Place slash after DD (2) and MM (4)
        if ((index == 2 || index == 4) && index != text.length) {
          buffer.write('/');
        }
      } else {
        // Place slash after MM (2)
        if (index == 2 && index != text.length) {
          buffer.write('/');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

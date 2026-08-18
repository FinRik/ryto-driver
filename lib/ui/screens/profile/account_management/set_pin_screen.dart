import 'package:flutter/material.dart';

import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';

class SetPinScreen extends StatelessWidget {
  const SetPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackArrowHeader(
            title: "Set Security PIN",
            subText: "This PIN will be required for all wallet withdrawals.",
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_PinBox(), _PinBox(), _PinBox(), _PinBox()],
                    ),
                  ),
                ),
                const Text(
                  "Avoid using obvious sequences like 1234 or your birth year.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF637381), fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Button(height: 56, text: "SET PIN", onTap: () {}),
          ),
        ],
      ),
    );
  }
}

class _PinBox extends StatelessWidget {
  const _PinBox();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E5F2)),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(counterText: "", border: InputBorder.none),
      ),
    );
  }
}

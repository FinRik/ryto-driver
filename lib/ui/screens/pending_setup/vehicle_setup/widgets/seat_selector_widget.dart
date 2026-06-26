import 'package:flutter/material.dart';

import '../../../../styles/app_decorations.dart';

class SeatSelectorWidget extends StatefulWidget {
  const SeatSelectorWidget({super.key, required this.onChanged});

  final void Function(int) onChanged;

  @override
  State<SeatSelectorWidget> createState() => _SeatSelectorWidgetState();
}

class _SeatSelectorWidgetState extends State<SeatSelectorWidget> {
  int _value = 1;

  increment() {
    setState(() => _value = _value + 1);
    widget.onChanged(_value);
  }

  decrement() {
    if (_value == 1) {
      return;
    } else {
      setState(() => _value--);
    }
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: AppDecoration.roundedOutlinedRadius100.copyWith(
        border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
            ),
            child: IconButton(onPressed: decrement, icon: Icon(Icons.remove)),
          ),
          Text(
            _value.toString(),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
            ),
            child: IconButton(onPressed: increment, icon: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}

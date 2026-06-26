import 'package:flutter/material.dart';

class AppDecoration {
  AppDecoration._();

  static const Decoration dashboardDeco = BoxDecoration(
    color: Color(0xFF1565D8),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(60),
      bottomRight: Radius.circular(60),
    ),
  );

  static BoxDecoration bookingOverlayDeco = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );

  static BoxDecoration roundedOutlinedRadius8 = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
  );
  static BoxDecoration roundedOutlinedRadius16 = BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(16),
    // border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
  );
  static BoxDecoration roundedOutlinedRadius100 = BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(100),
    // border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
  );
}

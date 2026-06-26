import 'package:flutter/material.dart';

enum ActionStatus {
  notSet,
  pending,
  completed,
  failed;

  // Helper for UI colors
  Color get color {
    switch (this) {
      case ActionStatus.completed: return Colors.green;
      case ActionStatus.pending: return const Color(0xffD97706);
      case ActionStatus.failed: return Colors.red;
      case ActionStatus.notSet: return Colors.black;
      // default: return const Color(0xff838794);
    }
  }

  String get label {
    switch (this) {
      case ActionStatus.completed: return "Completed";
      case ActionStatus.pending: return "Pending";
      case ActionStatus.failed: return "Failed";
      default: return "Not Set";
    }
  }
}
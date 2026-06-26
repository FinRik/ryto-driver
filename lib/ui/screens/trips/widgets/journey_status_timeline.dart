// journey_status_timeline.dart

import 'package:flutter/material.dart';

/// Defines each step in the journey timeline.
class _JourneyStep {
  final String label;
  final IconData icon;

  const _JourneyStep({required this.label, required this.icon});
}

/// Maps a raw [bookingStatus] string to a 0-based active step index.
/// Returns -1 if status is unrecognised (renders all steps as pending).
int journeyStepIndexFromStatus(String? status) {
  switch (status?.toUpperCase()) {
    case 'PENDING':
      return 0; // RECEIVED is active
    case 'BOOKED':
    case 'DRIVER_ACCEPTED':
      return 1; // ACCEPTED is active
    case 'TRIP_STARTED':
    case 'DRIVER_REJECTED': // still show checkin step as current even on reject
      return 2; // CHECKIN is active
    case 'TRIP_COMPLETED':
      return 3; // All complete (past the last step)
    default:
      return 0;
  }
}

/// A reusable horizontal journey-status timeline.
///
/// Usage:
/// ```dart
/// JourneyStatusTimeline(
///   bookingStatus: bookingSummary.bookingStatus,
/// )
/// ```
///
/// Optionally provide custom [steps] to override the defaults.
class JourneyStatusTimeline extends StatelessWidget {
  final String? bookingStatus;

  /// Override default steps for different journey types.
  final List<_JourneyStep>? steps;

  static const _defaultSteps = [
    _JourneyStep(label: 'RECEIVED', icon: Icons.inbox_outlined),
    _JourneyStep(label: 'ACCEPTED', icon: Icons.check_circle_outline),
    _JourneyStep(label: 'CHECKIN', icon: Icons.navigation_outlined),
  ];

  const JourneyStatusTimeline({
    super.key,
    required this.bookingStatus,
    this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSteps = steps ?? _defaultSteps;
    final activeIndex = journeyStepIndexFromStatus(bookingStatus);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JOURNEY STATUS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8F9BBA),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: _buildStepRow(resolvedSteps, activeIndex),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepRow(List<_JourneyStep> steps, int activeIndex) {
    final items = <Widget>[];

    for (int i = 0; i < steps.length; i++) {
      final isDone = i < activeIndex;
      final isActive = i == activeIndex;

      items.add(
        _StepNode(
          step: steps[i],
          isDone: isDone,
          isActive: isActive,
        ),
      );

      // Add connector between steps
      if (i < steps.length - 1) {
        final isConnectorFilled = i < activeIndex;
        items.add(
          Expanded(
            child: _StepConnector(isFilled: isConnectorFilled),
          ),
        );
      }
    }

    return items;
  }
}

class _StepNode extends StatelessWidget {
  final _JourneyStep step;
  final bool isDone;
  final bool isActive;

  const _StepNode({
    required this.step,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color circleBg;
    final Color iconColor;
    final Color labelColor;

    if (isDone) {
      circleBg = const Color(0xFF0061FF);
      iconColor = Colors.white;
      labelColor = const Color(0xFF8F9BBA);
    } else if (isActive) {
      circleBg = const Color(0xFF0061FF);
      iconColor = Colors.white;
      labelColor = const Color(0xFF0061FF);
    } else {
      circleBg = Colors.white;
      iconColor = const Color(0xFFBCC5E8);
      labelColor = const Color(0xFFBCC5E8);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: circleBg,
            shape: isDone || isActive ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isDone || isActive ? BorderRadius.circular(12) : null,
            boxShadow: isActive
                ? [
              BoxShadow(
                color: const Color(0xFF0061FF).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ]
                : null,
          ),
          child: isDone
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Icon(step.icon, color: iconColor, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          step.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: labelColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isFilled;

  const _StepConnector({required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: isFilled
          ? Container(height: 2, color: const Color(0xFF0061FF))
          : Row(
        children: List.generate(
          6,
              (_) => Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFBCC5E8),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Usage Example
// JourneyStatusTimeline(
// bookingStatus: _booking.bookingStatus,
// ),
// JourneyStatusTimeline(
// bookingStatus: _booking.bookingStatus,
// steps: const [
// _JourneyStep(label: 'PICKED UP',  icon: Icons.inventory_2_outlined),
// _JourneyStep(label: 'EN ROUTE',   icon: Icons.directions_car_outlined),
// _JourneyStep(label: 'DELIVERED',  icon: Icons.done_all),
// ],
// ),
import 'package:flutter/material.dart';

import '../../core/models/trip/trip.dart';
import '../../core/routes/router.dart';
import '../../core/routes/routes.dart';
import 'confirm_booking_action_bottom_sheet.dart';

class BookingActionBottomSheet extends StatelessWidget {
  const BookingActionBottomSheet({
    super.key,
    required this.trip,
    required this.status,
  });

  final Trip trip;
  final String status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == "COMPLETED" || trip.status == "COMPLETED";
    final isCanceled = status == "CANCELED" || trip.status == "CANCELED";

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Grab handle indicator
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // ── TERMINAL VIEW: COMPLETED ─────────────────────────
              if (isCompleted) ...[
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Trip Completed Successfully",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                ),
                const SizedBox(height: 10),
                const Text(
                  "This journey has been brought to a close. All financials have processed and no further action is required from you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                _buildCloseButton(context),
              ]

              // ── TERMINAL VIEW: CANCELED ──────────────────────────
              else if (isCanceled) ...[
                const Icon(
                  Icons.cancel,
                  color: Color(0xFFD32F2F),
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Trip Canceled",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                ),
                const SizedBox(height: 10),
                const Text(
                  "This trip booking was voided or canceled. No validation checks can be run on this journey timeline configuration.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                _buildCloseButton(context),
              ]

              // ── ACTIVE/SCHEDULED VIEW (Original UI Elements) ──────
              else ...[
                  // 1. Verify Pins Action
                  ListTile(
                    leading: const Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFF0061FF),
                    ),
                    title: const Text("Verify Passenger Pins", style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      router.push(Paths.BULKVERIFYPINS, extra: trip.id.toString());
                    },
                  ),
                  const Divider(height: 1),

                  // 2. Mark Complete Action (Safely falls back to 0.0 with your logic check verification)
                  if ((trip.tripFeeGross ?? 0.0) > 0.0) ...[
                    ListTile(
                      leading: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      title: const Text("Mark Trip Complete", style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        _showDecisionSheet(context, trip, TripDecisionMode.complete);
                      },
                    ),
                    const Divider(height: 1),
                  ],

                  // 3. Cancel Trip Action
                  ListTile(
                    leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                    title: const Text("Cancel Trip", style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _showDecisionSheet(context, trip, TripDecisionMode.cancel);
                    },
                  ),
                ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Common Close Action button for the terminal views
  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4F7FE),
          foregroundColor: const Color(0xFF1B2559),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Close",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showDecisionSheet(
      BuildContext context,
      Trip trip,
      TripDecisionMode mode,
      ) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) => ConfirmBookingActionBottomSheet(trip: trip, mode: mode),
  );
}

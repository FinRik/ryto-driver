import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/bookings/booking_summary.dart';
import '../../../core/models/trip/safety_pin_request.dart';
import '../../dialogs/trip_success_dialog.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/loaders/circular_indicator.dart';
import '../trip_action/bloc/trip_action_bloc.dart';
import 'bloc/trips_bloc.dart';

class TripBulkPinVerificationScreen extends StatefulWidget {
  final String tripId;

  const TripBulkPinVerificationScreen({super.key, required this.tripId});

  @override
  State<TripBulkPinVerificationScreen> createState() =>
      _TripBulkPinVerificationScreenState();
}

class _TripBulkPinVerificationScreenState
    extends State<TripBulkPinVerificationScreen> {
  final List<PinVerification> _pinVerifications = [];

  @override
  void initState() {
    super.initState();
    context.read<TripsBloc>().add(FetchTripBookingsRequested(widget.tripId));
  }

  PinVerification? _getVerificationFor(int bookingId) {
    try {
      return _pinVerifications.firstWhere((p) => p.bookingId == bookingId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener for Action success (The Pins verification call)
        BlocListener<TripActionsBloc, TripActionsState>(
          listenWhen: (p, c) =>
              p.status != c.status && c.status == TripActionStatus.success,
          listener: (context, state) {
            if (state.lastAction == 'verify_pin') {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => TripSuccessDialog(
                  title: "Verification Complete",
                  message:
                      state.message ??
                      "All pins have been verified successfully.",
                  onDone: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to trip details
                  },
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Verify Passengers",
            style: TextStyle(color: Color(0xFF1B2559)),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Color(0xFF1B2559)),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<TripsBloc, TripsState>(
                builder: (context, state) {
                  // 2. Handle Loading State
                  if (state.bookingStatus == TripBookingStatus.loading) {
                    return const Center(child: CircularIndicator());
                  }

                  // 3. Handle Error State
                  if (state.bookingStatus == TripBookingStatus.failure) {
                    return _buildCenteredMessage(
                      state.errorMessage ?? "Failed to load bookings",
                      isError: true,
                    );
                  }

                  // Filter for accepted bookings only for this screen
                  final acceptedBookings = state.bookings
                      .where(
                        (b) =>
                            b.bookingStatus.toUpperCase() == "PENDING" ||
                            b.bookingStatus.toUpperCase() == "DRIVER_ACCEPTED",
                      )
                      .toList();

                  // 4. Handle Empty State
                  if (acceptedBookings.isEmpty) {
                    return _buildCenteredMessage(
                      "No accepted bookings found for this trip.",
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: acceptedBookings.length,
                    itemBuilder: (context, index) {
                      final booking = acceptedBookings[index];
                      final verification = _getVerificationFor(booking.id);
                      final bool hasPin = verification != null;

                      return _buildPassengerCard(booking, hasPin, verification);
                    },
                  );
                },
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(
    BookingSummary booking,
    bool hasPin,
    PinVerification? verification,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E5F2)),
        borderRadius: BorderRadius.circular(12),
        color: hasPin ? const Color(0xFFF4F7FE) : Colors.white,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF0061FF),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.passenger.firstName +
                      " " +
                      booking.passenger.lastName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (hasPin)
                  Text(
                    "PIN Added: ****${verification!.safetyPin.substring(verification.safetyPin.length - 1)}",
                    style: const TextStyle(
                      color: Color(0xFF48BB78),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showPinDialog(booking),
            child: Text(
              hasPin ? "Edit PIN" : "Add PIN",
              style: TextStyle(
                color: hasPin ? Colors.orange : const Color(0xFF0061FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<TripActionsBloc, TripActionsState>(
        builder: (context, state) {
          final isBusy =
              state.status == TripActionStatus.loading &&
              state.lastAction == 'verify_pin';

          return Button(
            text: "Confirm & Verify All",
            onTap: (isBusy || _pinVerifications.isEmpty)
                ? null
                : () {
                    context.read<TripActionsBloc>().add(
                      VerifyPassengerPinsConfirmed(
                        tripId: widget.tripId,
                        request: SafetyPinRequest(
                          pinVerifications: _pinVerifications,
                        ),
                      ),
                    );
                  },
            isBusy: isBusy,
            buttonColor: _pinVerifications.isEmpty
                ? Colors.grey[300]!
                : const Color(0xFF0061FF),
          );
        },
      ),
    );
  }

  Widget _buildCenteredMessage(String message, {bool isError = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.people_outline,
              size: 48,
              color: isError ? Colors.red : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (isError)
              TextButton(
                onPressed: () => context.read<TripsBloc>().add(
                  FetchTripBookingsRequested(widget.tripId),
                ),
                child: const Text("Retry"),
              ),
          ],
        ),
      ),
    );
  }

  void _showPinDialog(BookingSummary booking) {
    final existing = _getVerificationFor(booking.id);
    final TextEditingController pinController = TextEditingController(
      text: existing?.safetyPin ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Verify ${booking.passenger.firstName}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the safety pin provided by the passenger."),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                hintText: "Enter 4-digit PIN",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (pinController.text.isNotEmpty) {
                setState(() {
                  // Remove old entry if editing, then add new one
                  _pinVerifications.removeWhere(
                    (p) => p.bookingId == booking.id,
                  );
                  _pinVerifications.add(
                    PinVerification(
                      bookingId: booking.id,
                      safetyPin: pinController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

// class TripBulkPinVerificationScreen extends StatefulWidget {
//   final String tripId;
//
//   const TripBulkPinVerificationScreen({super.key, required this.tripId});
//
//   @override
//   State<TripBulkPinVerificationScreen> createState() =>
//       _TripBulkPinVerificationScreenState();
// }
//
// class _TripBulkPinVerificationScreenState
//     extends State<TripBulkPinVerificationScreen> {
//   // Local list to store the pins as they are added/edited
//   final List<PinVerification> _pinVerifications = [];
//
//   // Helper to check if a bookings already has a pin in our list
//   PinVerification? _getVerificationFor(int bookingId) {
//     try {
//       return _pinVerifications.firstWhere((p) => p.bookingId == bookingId);
//     } catch (_) {
//       return null;
//     }
//   }
//
//   @override
//   void initState() {
//     context.read<TripsBloc>().add(
//       FetchTripBookingsRequested(widget.tripId, bookingStatus: "ACCEPTED"),
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<TripActionsBloc, TripActionsState>(
//       listenWhen: (p, c) =>
//           p.status != c.status && c.status == TripActionStatus.success,
//       listener: (context, state) {
//         if (state.lastAction == 'verify_pin') {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => TripSuccessDialog(
//               title: "Verification Complete",
//               message:
//                   state.message ?? "All pins have been verified successfully.",
//               onDone: () {
//                 Navigator.pop(context); // Close dialog
//                 Navigator.pop(context); // Return to trip details
//               },
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Verify Passengers",
//             style: TextStyle(color: Color(0xFF1B2559)),
//           ),
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: const BackButton(color: Color(0xFF1B2559)),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(20),
//                 itemCount: widget.acceptedBookings.length,
//                 itemBuilder: (context, index) {
//                   final bookings = widget.acceptedBookings[index];
//                   final verification = _getVerificationFor(bookings.id);
//                   final bool hasPin = verification != null;
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: const Color(0xFFE0E5F2)),
//                       borderRadius: BorderRadius.circular(12),
//                       color: hasPin ? const Color(0xFFF4F7FE) : Colors.white,
//                     ),
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundColor: Color(0xFF0061FF),
//                           child: Icon(Icons.person, color: Colors.white),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "${bookings.passenger.firstName} ${bookings.passenger.lastName}",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               if (hasPin)
//                                 Text(
//                                   "PIN Added: ****${verification.safetyPin.characters.last}",
//                                   style: const TextStyle(
//                                     color: Color(0xFF48BB78),
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => _showPinDialog(bookings),
//                           child: Text(
//                             hasPin ? "Edit PIN" : "Add PIN",
//                             style: TextStyle(
//                               color: hasPin
//                                   ? Colors.orange
//                                   : const Color(0xFF0061FF),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Bottom Action Bar
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: BlocBuilder<TripActionsBloc, TripActionsState>(
//                 builder: (context, state) {
//                   final isBusy =
//                       state.status == TripActionStatus.loading &&
//                       state.lastAction == 'verify_pin';
//
//                   return Button(
//                     text: "Confirm & Verify All",
//                     onTap: (isBusy || _pinVerifications.isEmpty)
//                         ? null
//                         : () {
//                             context.read<TripActionsBloc>().add(
//                               VerifyPassengerPinsConfirmed(
//                                 tripId: widget.tripId,
//                                 request: SafetyPinRequest(
//                                   pinVerifications: _pinVerifications,
//                                 ),
//                               ),
//                             );
//                           },
//                     isBusy: isBusy,
//                     buttonColor: _pinVerifications.isEmpty
//                         ? Colors.grey[300]!
//                         : const Color(0xFF0061FF),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/trip/safety_pin_request.dart';
import '../../../widgets/buttons/button.dart';
import '../../trip_action/bloc/trip_action_bloc.dart';

class VerifyIdentityCard extends StatefulWidget {
  final int bookingId;
  final int tripId;
  final VoidCallback onSuccess;

  const VerifyIdentityCard({
    super.key,
    required this.bookingId,
    required this.tripId,
    required this.onSuccess,
  });

  @override
  State<VerifyIdentityCard> createState() => _VerifyIdentityCardState();
}

class _VerifyIdentityCardState extends State<VerifyIdentityCard> {
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (_pinController.text.length < 4) return;
    _showPinConfirmationBottomSheet(context);
  }

  void _executeVerification() {
    context.read<TripActionsBloc>().add(
      VerifyPassengerPinsConfirmed(
        tripId: "${widget.tripId}",
        request: SafetyPinRequest(
          pinVerifications: [
            PinVerification(
              safetyPin: _pinController.text,
              bookingId: widget.bookingId,
            ),
          ],
        ),
      ),
    );
  }

  void _showPinConfirmationBottomSheet(BuildContext screenContext) {
    showModalBottomSheet(
      context: screenContext,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Confirm Passenger PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
              ),
              const SizedBox(height: 12),
              const Text(
                "Ensure this code matches the digits provided by the passenger.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _pinController.text,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8, color: Color(0xFF0061FF)),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF8F9BBA)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(modalContext),
                      child: const Text("Edit PIN", style: TextStyle(color: Color(0xFF1B2559), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0061FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(modalContext);
                        _executeVerification();
                      },
                      child: const Text("Confirm & Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripActionsBloc, TripActionsState>(
      listenWhen: (prev, curr) => prev.status != curr.status && curr.lastAction == 'verify_pin',
      listener: (context, state) {
        if (state.status == TripActionStatus.success) {
          _pinController.clear();
          widget.onSuccess();
        }
      },
      buildWhen: (prev, curr) => prev.status != curr.status && curr.lastAction == 'verify_pin',
      builder: (context, state) {
        final isBusy = state.status == TripActionStatus.loading;
        final hasError = state.status == TripActionStatus.failure;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF0F2F5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Verify Passenger Identity",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 4),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: "Enter 4-Digit Code",
                  hintStyle: const TextStyle(color: Color(0xFF8F9BBA), fontSize: 14, letterSpacing: 0),
                  fillColor: const Color(0xFFF4F7FE),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              // if (hasError) ...[
              //   const SizedBox(height: 8),
              //   Row(
              //     children: [
              //       const Icon(Icons.error_outline, color: Color(0xFFFF5B5B), size: 14),
              //       const SizedBox(width: 6),
              //       Expanded(
              //         child: Text(
              //           state.message ?? "Invalid PIN. Please try again.",
              //           style: const TextStyle(color: Color(0xFFFF5B5B), fontSize: 12),
              //         ),
              //       ),
              //     ],
              //   ),
              // ],
              const SizedBox(height: 20),
              Button(
                onTap: _onVerifyPressed,
                text: isBusy ? "Processing..." : "Verify Trip",
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/trip/trip.dart';
import '../dialogs/trip_success_dialog.dart';
import '../widgets/buttons/button.dart';
import '../screens/trip_action/bloc/trip_action_bloc.dart';

enum TripDecisionMode { complete, cancel }

class ConfirmBookingActionBottomSheet extends StatelessWidget {
  final Trip trip;
  final TripDecisionMode mode;

  const ConfirmBookingActionBottomSheet({super.key, required this.trip, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripActionsBloc, TripActionsState>(
      listenWhen: (p, c) =>
          p.status != c.status && c.status == TripActionStatus.success,
      listener: (context, state) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => TripSuccessDialog(
            title: "Success",
            message: state.message ?? "Trip updated successfully",
            onDone: () {
              if (mode == TripDecisionMode.cancel ||
                  mode == TripDecisionMode.complete) {
                Navigator.pop(context);
              }
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mode == TripDecisionMode.complete
                  ? "Complete Trip"
                  : "Cancel Trip",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Route Summary
            _buildMiniRouteInfo(),
            const SizedBox(height: 24),

            // Dynamic Buttons
            BlocBuilder<TripActionsBloc, TripActionsState>(
              builder: (context, state) {
                final isBusy = state.status == TripActionStatus.loading;

                if (mode == TripDecisionMode.complete) {
                  return Button(
                    text: "Confirm Completion",
                    buttonColor: const Color(0xFF0061FF),
                    isBusy: isBusy && state.lastAction == 'approve_trip',
                    onTap: () => _handleComplete(context),
                  );
                } else {
                  return Button(
                    text: "Confirm Cancellation",
                    buttonColor: const Color(0xFFFFF1F1),
                    textColor: const Color(0xFFFF5B5B),
                    isBusy: isBusy && state.lastAction == 'decline_trip',
                    onTap: () => _handleCancel(context),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniRouteInfo() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.circle, color: Colors.blue, size: 16),
          title: Text(trip.originCity, style: const TextStyle(fontSize: 14)),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.location_on, color: Colors.red, size: 16),
          title: Text(
            trip.destinationCity,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _handleComplete(BuildContext context) {
    context.read<TripActionsBloc>().add(
      CompleteTripRequested(
        tripId: trip.id.toString(),
        totalAmount: trip.tripFeeGross!.toInt(),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    context.read<TripActionsBloc>().add(
      CancelTripRequested(trip.id.toString()),
    );
  }
}

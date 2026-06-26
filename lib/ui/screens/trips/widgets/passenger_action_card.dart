import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/enums/bottom_sheet_type.dart';
import '../../../../core/models/bookings/booking_summary.dart';
import '../../../../core/models/trip/trip_summary.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/bottom_sheet_service.dart';
import '../../../../utils/helpers/call_service_util.dart';
import '../../../bottom_sheets/passenger_action_bottom_sheet.dart';
import '../bloc/trips_bloc.dart';

class PassengerActionCard extends StatelessWidget {
  final int tripId;
  final BookingSummary bookingSummary;
  final TripSummary tripSummary;
  final String pickupPoint;

  const PassengerActionCard({
    super.key,
    required this.bookingSummary,
    required this.pickupPoint,
    required this.tripSummary,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E5F2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bookingSummary.passenger.fullname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2559),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bookingSummary.formattedStatus.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      bookingSummary.cleanRawStatus,
                      style: TextStyle(
                        color: bookingSummary.formattedStatus,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF8F9BBA),
                  ),
                  Text(
                    pickupPoint,
                    style: const TextStyle(
                      color: Color(0xFF8F9BBA),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (bookingSummary.getFriendlyStatus == true) {
                      router.push(
                        Paths.APPROVEDPASSENGER,
                        extra: PassengerDetailsArgs(
                          tripSummary: tripSummary,
                          bookingSummary: bookingSummary
                        ),
                      );
                    } else {
                      final res = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        builder: (context) => PassengerActionBottomSheet(
                          bookingSummary: bookingSummary,
                          tripSummary: tripSummary,
                        ),
                      );
                      if (res == true) {
                        context.read<TripsBloc>().add(
                          FetchTripBookingsRequested(tripId.toString(),),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6FEBA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  child: const Text(
                    "Passenger details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // _buildIconButton(
              //   Icons.share_location_outlined,
              //   const Color(0xFFF4F7FE),
              //   onTap: () {},
              // ),
              const SizedBox(width: 8),
              _buildIconButton(
                Icons.chat_bubble_outline,
                const Color(0xFFF4F7FE),
                hasNotification: true,
                onTap: () async {
                  await sl<BottomSheetService>()
                      .showCustomBottomSheet<Map<String, dynamic>, void>(
                        variant: BottomSheetType.chat,
                        data: {
                          "tripId": tripId,
                          'participantId': bookingSummary.passenger.id,
                        },
                      );
                },
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                Icons.phone_outlined,
                const Color(0xFFE2FFD9),
                iconColor: const Color(0xFF2FB344),
                onTap: () => CallServiceUtil.makePhoneCall(
                  bookingSummary.passenger.phone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    Color bgColor, {
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF0061FF),
    bool hasNotification = false,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(48),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ),
        if (hasNotification)
          const Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
          ),
      ],
    );
  }
}

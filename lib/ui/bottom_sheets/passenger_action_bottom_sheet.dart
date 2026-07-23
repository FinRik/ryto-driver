import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../app/app_setup_locator.dart';
import '../../core/enums/bottom_sheet_type.dart';
import '../../core/models/bookings/booking_summary.dart';
import '../../core/models/lat_lng.dart';
import '../../core/models/trip/trip_summary.dart';
import '../../core/routes/router.dart';
import '../../core/routes/routes.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../widgets/arrival_time_widget.dart';
import '../widgets/build_route_card.dart';
import '../widgets/buttons/button.dart';
import '../screens/trip_action/bloc/trip_action_bloc.dart';
import '../widgets/currency_formatter_widget.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class PassengerActionBottomSheet extends StatelessWidget {
  final BookingSummary bookingSummary;
  final TripSummary tripSummary;

  const PassengerActionBottomSheet({
    super.key,
    required this.tripSummary,
    required this.bookingSummary,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripActionsBloc, TripActionsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == TripActionStatus.success,
      listener: (context, state) {
        // 1. Close the BottomSheet first
        router.pop(true);

        // 2. Navigate to the appropriate success screen based on the action performed
        if (state.lastAction == 'approve_booking') {
          router.push(
            Paths.PASSENGERBOOKINGAPPROVED,
            extra: PassengerDetailsArgs(
              bookingSummary: bookingSummary,
              tripSummary: tripSummary,
            ),
          );
        } else if (state.lastAction == 'decline_booking') {
          router.push(Paths.PASSENGERBOOKINGDECLINED, extra: bookingSummary);
        }
      },
      child: BaseBottomSheet(
        multiplier: .85,
        showHandleBar: false,
        hasScrollableChild: true,
        builder: (ctx, size) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Status and Fare
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "NEW REQUEST",
                    style: TextStyle(
                      color: Color(0xFF8F9BBA),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${bookingSummary.cleanRawStatus} Request",
                      style: TextStyle(
                        color: Color(0xFFF6AD55),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.baseline,
              //   textBaseline: TextBaseline.alphabetic,
              //   children: [
              //     CurrencyFormatterWidget(
              //       amount: "${bookingSummary.pricePaid}",
              //       textColor: Color(0xFF0061FF),
              //       style: const TextStyle(
              //         fontSize: 32,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     const SizedBox(width: 8),
              //     const Text(
              //       "Est. Fare",
              //       style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 14),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 24),

              // 2. Passenger Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: Text(bookingSummary.passenger.initials),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookingSummary.passenger.fullname,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B2559),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${bookingSummary.passenger.rating} • ${bookingSummary.passenger.tripCount} trips",
                                style: const TextStyle(
                                  color: Color(0xFF8F9BBA),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Route Details (Simplified FareRouteCard)
              // _buildRouteNode(
              //   Icons.circle,
              //   const Color(0xFF0061FF),
              //   "PICKUP",
              //   LatLng(
              //     lat: bookingSummary.passengerPickupLat,
              //     lng: bookingSummary.passengerDropoffLat,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 11),
              //   child: Container(
              //     height: 30,
              //     width: 2,
              //     color: const Color(0xFFE0E5F2),
              //   ),
              // ),
              // _buildRouteNode(
              //   Icons.square,
              //   Colors.red,
              //   "DROP-OFF",
              //   LatLng(
              //     lat: bookingSummary.passengerDropoffLat,
              //     lng: bookingSummary.passengerDropoffLng,
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF0061FF), width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0061FF),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "TOTAL FARE",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CurrencyFormatterWidget(
                            amount: "${bookingSummary.pricePaid}",
                            textColor: Colors.white,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: BuildRouteCard(
                        startCoord: LatLng(
                          lat: bookingSummary.passengerPickupLat,
                          lng: bookingSummary.passengerPickupLng,
                        ),
                        stopCoord: LatLng(
                          lat: bookingSummary.passengerDropoffLat,
                          lng: bookingSummary.passengerDropoffLng,
                        ),
                        departureDateTime: tripSummary.departureDateTime,
                        title: "PICKUP",
                        subtitle: "DROP-OFF",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4. Trip Stats (Distance & Time)
              Row(
                children: [
                  Expanded(
                    child: _buildStatTile(
                      Icons.location_on_outlined,
                      "DISTANCE",
                      "${bookingSummary.offsetKm.roundToDouble()} km",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ArrivalTimeWidget(
                      sourceLat: bookingSummary.passengerPickupLat,
                      sourceLng: bookingSummary.passengerPickupLng,
                      destLat: bookingSummary.passengerDropoffLat,
                      destLng: bookingSummary.passengerDropoffLng,
                      departureDateTime: tripSummary.departureDateTime,
                      builder: (ctx, p2) => _buildStatTile(
                        Icons.access_time,
                        "EST. TIME",
                        p2.formattedDuration,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 5. Price Paid & Transaction Status (conditional)
              Row(
                children: [
                  Expanded(
                    child: _buildStatTile(
                      Icons.airline_seat_recline_normal_outlined,
                      "SEAT(s) BOOKED",
                      "${bookingSummary.seats}",
                    ),
                  ),
                  if (bookingSummary.pricePaid != null &&
                      bookingSummary.transactionStatus != null)
                    const SizedBox(width: 16),
                  if (bookingSummary.transactionStatus != null)
                    Expanded(
                      child: _buildTransactionStatusTile(
                        bookingSummary.transactionStatus!,
                      ),
                    ),
                ],
              ),

              // 6. Package / Recipient Details (conditional)
              if (bookingSummary.packageType != null &&
                  bookingSummary.packageRecipientName != null &&
                  bookingSummary.packageRecipientPhone != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 16,
                            color: Color(0xFF8F9BBA),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "PACKAGE DETAILS",
                            style: TextStyle(
                              color: Color(0xFF8F9BBA),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (bookingSummary.packageType != null) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                bookingSummary.packageType!,
                                style: const TextStyle(
                                  color: Color(0xFF0061FF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (bookingSummary.packageRecipientName != null ||
                          bookingSummary.packageRecipientPhone != null) ...[
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFE0E5F2), height: 1),
                        const SizedBox(height: 12),
                        if (bookingSummary.packageRecipientName != null)
                          _buildRecipientRow(
                            Icons.person_outline,
                            "Recipient",
                            bookingSummary.packageRecipientName!,
                          ),
                        if (bookingSummary.packageRecipientName != null &&
                            bookingSummary.packageRecipientPhone != null)
                          const SizedBox(height: 8),
                        if (bookingSummary.packageRecipientPhone != null)
                          _buildRecipientRow(
                            Icons.phone_outlined,
                            "Phone",
                            bookingSummary.packageRecipientPhone!,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // 7. Action Buttons integrated with Bloc
              BlocBuilder<TripActionsBloc, TripActionsState>(
                builder: (context, state) {
                  // Check if this specific booking is being processed
                  final bool isProcessing =
                      state.status == TripActionStatus.loading &&
                      state.processingId == bookingSummary.id.toString();

                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Button(
                          text: "Decline",
                          buttonColor: const Color(0xFFFFF1F1),
                          textColor: const Color(0xFFFF5B5B),
                          icon: Icons.close,
                          showPrefixIcon: true,
                          isBusy:
                              isProcessing &&
                              state.lastAction == 'decline_booking',
                          onTap: isProcessing
                              ? null
                              : () async {
                                  final res = await sl<BottomSheetService>()
                                      .showCustomBottomSheet<void, String>(
                                        variant: BottomSheetType.cancelTrip,
                                      );
                                  if (res?.confirmed == true) {
                                    context.read<TripActionsBloc>().add(
                                      DeclineBookingConfirmed(
                                        // tripId: tripSummary.id,
                                        reason: res!.data!,
                                        bookingId: bookingSummary.id,
                                      ),
                                    );
                                  }
                                },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Button(
                          text: "Accept Request",
                          buttonColor: const Color(0xFF0061FF),
                          textColor: Colors.white,
                          icon: Icons.check_circle_outline,
                          showPrefixIcon: true,
                          padding: EdgeInsets.zero,
                          isBusy:
                              isProcessing &&
                              state.lastAction == 'approve_booking',
                          onTap: () {
                            context.read<TripActionsBloc>().add(
                              ApproveBookingConfirmed(
                                tripId: tripSummary.id,
                                bookingId: bookingSummary.id,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionStatusTile(String status) {
    final Color bgColor;
    final Color textColor;
    final IconData icon;

    switch (status.toUpperCase()) {
      case 'PAID':
      case 'SUCCESS':
      case 'COMPLETED':
        bgColor = const Color(0xFFEBFAF0);
        textColor = const Color(0xFF48BB78);
        icon = Icons.check_circle_outline;
        break;
      case 'PENDING':
        bgColor = const Color(0xFFFFF7ED);
        textColor = const Color(0xFFF6AD55);
        icon = Icons.hourglass_empty_outlined;
        break;
      case 'FAILED':
      case 'DECLINED':
        bgColor = const Color(0xFFFFF1F1);
        textColor = const Color(0xFFFF5B5B);
        icon = Icons.cancel_outlined;
        break;
      default:
        bgColor = const Color(0xFFF4F7FE);
        textColor = const Color(0xFF8F9BBA);
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRANSACTION",
            style: TextStyle(
              // color: Color(0xFF8F9BBA),
              color: Color(0xFF1B2559).withOpacity(.5),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8F9BBA)),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(color: Color(0xFF8F9BBA), fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1B2559),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1B2559), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF1B2559).withOpacity(.5),
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

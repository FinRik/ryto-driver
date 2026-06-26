import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/bookings/booking_summary.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/models/trip/trip_summary.dart';
import '../../../core/routes/router.dart';
import '../../dialogs/trip_success_dialog.dart';
import '../../widgets/arrival_time_widget.dart';
import '../../widgets/build_route_card.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/currency_formatter_widget.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../trips/widgets/journey_status_timeline.dart';
import '../trips/widgets/passenger_header_section.dart';
import '../trips/widgets/verification_identity_card.dart';
import 'bloc/trip_action_bloc.dart';

class ApprovedPassengerScreen extends StatefulWidget {
  final PassengerDetailsArgs args;

  const ApprovedPassengerScreen({super.key, required this.args});

  @override
  State<ApprovedPassengerScreen> createState() =>
      _ApprovedPassengerScreenState();
}

class _ApprovedPassengerScreenState extends State<ApprovedPassengerScreen> {
  final _pinController = TextEditingController();
  BookingSummary get _booking => widget.args.bookingSummary;
  TripSummary get _trip => widget.args.tripSummary;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripActionsBloc, TripActionsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.status == TripActionStatus.success &&
          curr.lastAction == 'verify_pin',
      listener: (context, state) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TripSuccessDialog(
            title: "Identity Verified",
            message:
                state.message ??
                "The passenger's identity has been confirmed. You can proceed with the journey.",
            onDone: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      },
      child: BaseScaffoldWidget(
        bgColor: const Color(0xFFF8F9FB),
        removePadding: true,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: BackArrowButton(),
          ),
          // title: Text(
          //   _booking.passenger.fullname,
          //   style: TextStyle(
          //     color: Color(0xFF1B2559),
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          backgroundColor: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PassengerHeaderSection(
                name: _booking.passenger.fullname,
                initials: _booking.passenger.initials,
                rating: _booking.passenger.rating,
                status: _booking.cleanRawStatus,
                bookingSummary: _booking,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // ── Fare + Route Card ──────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF0061FF),
                          width: 2,
                        ),
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
                                  amount: "${_booking.pricePaid}",
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
                                lat: _booking.passengerPickupLat,
                                lng: _booking.passengerPickupLng,
                              ),
                              stopCoord: LatLng(
                                lat: _booking.passengerDropoffLat,
                                lng: _booking.passengerDropoffLng,
                              ),
                              departureDateTime: _trip.departureDateTime,
                              title: "PICKUP POINT",
                              subtitle: "DROP-OFF POINT",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    JourneyStatusTimeline(
                      bookingStatus: _booking.bookingStatus,
                    ),
                    const SizedBox(height: 16),
                    // 4. Trip Stats (Distance & Time)
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatTile(
                            Icons.location_on_outlined,
                            "DISTANCE",
                            "${_booking.offsetKm.roundToDouble()} km",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ArrivalTimeWidget(
                            sourceLat: _booking.passengerPickupLat,
                            sourceLng: _booking.passengerPickupLng,
                            destLat: _booking.passengerDropoffLat,
                            destLng: _booking.passengerDropoffLng,
                            departureDateTime: _trip.departureDateTime,
                            builder: (ctx, p2) => _buildStatTile(
                              Icons.access_time,
                              "EST. TIME",
                              p2.formattedDuration,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 5. Price Paid & Transaction Status (conditional)
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatTile(
                            Icons.airline_seat_recline_normal_outlined,
                            "SEATS(s) BOOKED",
                            "${_booking.seats}",
                          ),
                        ),
                        if (_booking.pricePaid != null &&
                            _booking.transactionStatus != null)
                          const SizedBox(width: 16),
                        if (_booking.transactionStatus != null)
                          Expanded(
                            child: _buildTransactionStatusTile(
                              _booking.transactionStatus!,
                            ),
                          ),
                      ],
                    ),

                    // ── Package / Recipient Details (conditional) ─────
                    if (_booking.packageType != null &&
                        _booking.packageRecipientName != null &&
                        _booking.packageRecipientPhone != null) ...[
                      const SizedBox(height: 16),
                      _buildPackageDetailsCard(),
                    ],

                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerifyIdentityCard(
                          bookingId: _booking.id,
                          tripId: _trip.id,
                          onSuccess: () {
                            // The card verified everything! The screen's top listener will trigger
                            // your custom 'TripSuccessDialog' and pop cleanly.
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
          const SizedBox(width: 8),
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

  Widget _buildPackageDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E5F2)),
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
              if (_booking.packageType != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _booking.packageType!,
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
          if (_booking.packageRecipientName != null ||
              _booking.packageRecipientPhone != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE0E5F2), height: 1),
            const SizedBox(height: 12),
            if (_booking.packageRecipientName != null)
              _buildInfoRow(
                Icons.person_outline,
                "Recipient",
                _booking.packageRecipientName!,
              ),
            if (_booking.packageRecipientName != null &&
                _booking.packageRecipientPhone != null)
              const SizedBox(height: 10),
            if (_booking.packageRecipientPhone != null)
              _buildInfoRow(
                Icons.phone_outlined,
                "Phone",
                _booking.packageRecipientPhone!,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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
}

import 'package:flutter/material.dart';

import '../../../../core/models/bookings/booking_summary.dart';
import '../../../../core/models/trip/trip.dart';
import '../../../widgets/currency_formatter_widget.dart';

class TripBreakdownCard extends StatelessWidget {
  final Trip trip;
  final List<BookingSummary> bookings;

  const TripBreakdownCard({
    super.key,
    required this.trip,
    this.bookings = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111C44),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TRIP BREAKDOWN",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          _PriceRow(label: "Trip Fee Gross", value: "${trip.tripFeeGross}"),
          const SizedBox(height: 20),
          Column(
            children: bookings
                .where((booking) => booking.bookingStatus == "DRIVER_ACCEPTED")
                .map(
                  (booking) => _PriceRow(
                    label: "Passenger ${booking.id}",
                    value: "${booking.pricePaid ?? 0.0}",
                  ),
                )
                .toList(),
          ),
          // const SizedBox(height: 12),
          // _PriceRow(label: "Service Fee", value: "${trip.serviceFee}"),
          const SizedBox(height: 12),
          _PriceRow(
            label: "Platform Commission",
            value: "${trip.platformCommission}",
          ),
          // const SizedBox(height: 12),
          // _PriceRow(label: "Driver Net", value: "${trip.driverNet}"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white24),
          ),
          _PriceRow(label: "Net Profit", value: "${trip.netProfit}"),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAmount;
  const _PriceRow({
    required this.label,
    required this.value,
    this.isAmount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        if (isAmount)
          CurrencyFormatterWidget(
            amount: value,
            builder: (ctx, value, rawAmount) => Text(
              value,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

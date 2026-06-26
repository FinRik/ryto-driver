import 'package:flutter/material.dart';

import '../../../../core/models/trip/trip.dart';
import '../../../widgets/currency_formatter_widget.dart';

enum TripType { scheduled, courier }

class DailyTripCard extends StatelessWidget {
  final Trip trip;
  final TripType type;

  const DailyTripCard({super.key, required this.trip, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(),
              Text(
                trip.departureTime,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1B2559),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (type == TripType.scheduled) ...[
            _buildRouteRow(trip.originCity, isOrigin: true),
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: SizedBox(height: 12, child: VerticalDivider(width: 1)),
            ),
            _buildRouteRow(trip.destinationCity, isOrigin: false),
          ] else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF0061FF),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Intercity Delivery",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff94A3B8),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${trip.originCity} ➔ ${trip.destinationCity}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    bool isScheduled = type == TripType.scheduled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isScheduled ? const Color(0xFFE2FFD9) : const Color(0xFFD9E8FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isScheduled ? "SCHEDULED" : "COURIER TRIP",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isScheduled
              ? const Color(0xFF2FB344)
              : const Color(0xFF0061FF),
        ),
      ),
    );
  }

  Widget _buildRouteRow(String text, {required bool isOrigin}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              isOrigin ? Icons.circle : Icons.radio_button_off,
              size: 10,
              color: const Color(0xFF0061FF),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOrigin ? "From" : "To",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8F9BBA),
                    ),
                  ),
                  Text(
                    text,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    if (type == TripType.scheduled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF1B2559),
              ),
              // const SizedBox(width: -8),
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF2D3748),
              ),
              const SizedBox(width: 8),
              Text(
                "+${trip.passengersBooked}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF8F9BBA)),
              ),
            ],
          ),
          CurrencyFormatterWidget(
            amount: "${trip.estimatedEarnings}",
            builder: (ctx, amount, rawAmount) => Text(
              "$amount Est.",
              style: const TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
                color: Color(0xFF0061FF),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        "${trip.passengersBooked} Packages • ${trip.passengersBooked}",
        style: const TextStyle(fontSize: 12, color: Color(0xFF8F9BBA)),
      );
    }
  }
}

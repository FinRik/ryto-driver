import 'package:flutter/material.dart';

import '../../../../core/models/bookings/booking_summary.dart';
import '../../../widgets/trip_route_map.dart';

class PassengerHeaderSection extends StatelessWidget {
  final String name;
  final String initials;
  final double rating;
  final String status;
  final BookingSummary bookingSummary;

  const PassengerHeaderSection({
    super.key,
    required this.name,
    required this.initials,
    required this.rating,
    required this.status,
    required this.bookingSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ListTile(
            leading: Stack(
              children: [
                CircleAvatar(radius: 30, child: Text(initials)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 10, color: Colors.orange),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2559),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue.withOpacity(0.1),
            ), // Map Placeholder
            child: Stack(
              children: [
                TripRouteMap(
                  hasRoundedEdges: true,
                  olat: bookingSummary.passengerPickupLat,
                  olng: bookingSummary.passengerPickupLng,
                  dlat: bookingSummary.passengerDropoffLat,
                  dlng: bookingSummary.passengerDropoffLng,
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0061FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.white, size: 8),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

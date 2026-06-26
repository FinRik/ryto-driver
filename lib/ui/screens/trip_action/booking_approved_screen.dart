import 'package:flutter/material.dart';

import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/trip_route_map.dart';

class BookingApprovedScreen extends StatelessWidget {
  final PassengerDetailsArgs args;

  const BookingApprovedScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // 1. Success Illustration & Header
              const Center(
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Color(0xFF0061FF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Booking Confirmed",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
              const Text(
                "Your schedule has been updated.",
                style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 16),
              ),
              const SizedBox(height: 40),

              // 2. Passenger Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(args.bookingSummary.passenger.initials),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              args.bookingSummary.passenger.fullname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2559),
                              ),
                            ),
                            // const Text(
                            //   "ELITE MEMBER",
                            //   style: TextStyle(
                            //     color: Color(0xFF8F9BBA),
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF0F2F5)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTripDetail(
                          Icons.access_time,
                          "PICKUP TIME",
                          args.tripSummary.departureTime,
                        ),
                        _buildTripDetail(
                          Icons.location_on_outlined,
                          "TRIP TYPE",
                          args.bookingSummary.packageType ?? "",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Route Map Preview
              Stack(
                children: [
                  TripRouteMap(
                    height: 120,
                    hasRoundedEdges: true,
                    olat: args.bookingSummary.passengerPickupLat,
                    olng: args.bookingSummary.passengerPickupLng,
                    dlat: args.bookingSummary.passengerDropoffLat,
                    dlng: args.bookingSummary.passengerDropoffLng,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.8),
                        ],
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ROUTE",
                          style: TextStyle(
                            color: Color(0xFF8F9BBA),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   "routeName",
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xFF1B2559),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // 4. Primary Actions
              Button(
                onTap: () => router.replace(
                  Paths.APPROVEDPASSENGER,
                  extra: PassengerDetailsArgs(
                    bookingSummary: args.bookingSummary,
                    tripSummary: args.tripSummary,
                  ),
                ),
                text: "View Passenger Details",
                textColor: Colors.white,
                iconColor: Colors.white,
                showSuffixIcon: true,
                suffixIcon: Icons.chevron_right,
              ),
              const SizedBox(height: 12),
              Button.outline(
                onTap: () => router.go(Paths.HOME),
                textColor: Color(0xFF0061FF),
                text: "Go to Dashboard",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetail(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8F9BBA),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF0061FF)),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2559),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

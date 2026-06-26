import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/bottom_nav/cubit/bottom_nav_cubit.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../bloc/home_bloc.dart';
import 'daily_trip_card.dart';

class DailyTripsWidget extends StatelessWidget {
  const DailyTripsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (ctx, state) {
        final currentTrips = state.currentTrips ?? [];
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Trips",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<BottomNavCubit>().moveTo(1),
                  child: const Text(
                    "View All",
                    style: TextStyle(color: Color(0xFF0061FF)),
                  ),
                ),
              ],
            ),

            // 4. List of Daily Trips handled cleanly via Enum Status
            if (state.status == HomeStatus.loading && currentTrips.isEmpty)
              const Center(child: CircularIndicator())
            else if (state.status == HomeStatus.failure && currentTrips.isEmpty)
              Center(
                child: Text(
                  "${state.errorMessage}",
                  textAlign: TextAlign.center,
                ),
              )
            else if (currentTrips.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "No trips scheduled for today.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              // Map your List<Trip> data into DailyTripCards dynamically
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentTrips.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final trip = currentTrips[index];

                  return DailyTripCard(
                    trip: trip,
                    type: trip.packageType != null
                        ? TripType.courier
                        : TripType.scheduled,
                  );
                },
              ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

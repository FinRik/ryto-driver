import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../bottom_sheets/booking_action_bottom_sheet.dart';
import '../../styles/app_colors.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/app_bars/profile_app_bar.dart';
import '../../../core/models/trip/trip.dart';
import '../../widgets/loaders/circular_indicator.dart';
import 'bloc/trips_bloc.dart';
import 'widgets/trip_card.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch initial data
    _fetchTrips(0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fetchTrips(_tabController.index);
      }
    });
  }

  void _fetchTrips(int index) {
    final statuses = ["SCHEDULED", "COMPLETED", "CANCELED"];
    context.read<TripsBloc>().add(FetchTripsRequested(statuses[index]));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      appBar: ProfileAppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          dividerHeight: 0,
          tabs: const [
            Tab(text: "Scheduled"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      fab: FloatingActionButton.small(
        onPressed: () => _fetchTrips(_tabController.index),
        backgroundColor: Colors.white,
        child: Icon(Icons.refresh, color: AppColors.primary),
      ),
      child: BlocBuilder<TripsBloc, TripsState>(
        buildWhen: (previous, current) =>
            previous.listStatus != current.listStatus ||
            previous.trips != current.trips,
        builder: (context, state) {
          // 1. Handle Loading (Initial or empty list)
          if (state.listStatus == TripListStatus.loading &&
              state.trips.isEmpty) {
            return const Center(child: CircularIndicator());
          }

          // 2. Handle Failure (Only if we have no data to show)
          if (state.listStatus == TripListStatus.failure &&
              state.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Something went wrong'),
                  TextButton(
                    onPressed: () => _fetchTrips(_tabController.index),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // 3. Success State (or loading in background with existing data)
          return Stack(
            children: [
              TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _TripList(trips: state.trips, status: "SCHEDULED"),
                  _TripList(trips: state.trips, status: "COMPLETED"),
                  _TripList(trips: state.trips, status: "CANCELED"),
                ],
              ),

              // Optional: Show a linear progress bar at the top if refreshing
              if (state.listStatus == TripListStatus.loading &&
                  state.trips.isNotEmpty)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  final List<Trip> trips;
  final String status;

  const _TripList({required this.trips, required this.status});

  @override
  Widget build(BuildContext context) {
    // 3. Implement Empty State
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_filled_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              "No trips found in this category.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final sortedTrips = List<Trip>.from(trips)
      ..sort((a, b) => b.departureDateTime.compareTo(a.departureDateTime));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sortedTrips.length,
      itemBuilder: (context, index) {
        final trip = sortedTrips[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TripCard(
            status: trip.status,
            title: "${trip.originCity} to ${trip.destinationCity}",
            dateTime: "${trip.departureDate} • ${trip.departureTime}",
            earnings: "${trip.estimatedEarnings}",
            seats: trip.passengersBooked,
            packages: 0,
            rating: 0.0,
            onManage: () => router.push(Paths.TRIPDETAILS, extra: trip),
            onMoreOption: () => _onMoreOptionSelected(context, trip, status),
          ),
        );
      },
    );
  }

  void _onMoreOptionSelected(BuildContext context, Trip trip, String status) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BookingActionBottomSheet(trip: trip, status: status),
    );
  }
}

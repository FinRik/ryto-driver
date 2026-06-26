import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/models/trip/trip.dart';
import '../../widgets/arrival_time_widget.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/customs/event_state_widgets.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/loaders/circular_indicator.dart';
import '../../widgets/trip_info_card.dart';
import '../../widgets/trip_route_map.dart';
import 'bloc/trips_bloc.dart';
import 'widgets/passenger_action_card.dart';
import 'widgets/passengers_expandable_section.dart';
import 'widgets/trip_breakdown_card.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTripDetail());
  }

  void _fetchTripDetail() {
    context.read<TripsBloc>().add(
      FetchTripDetailsRequested(widget.trip.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      removePadding: true,
      child: BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) {
          if (state.summaryStatus == TripSummaryStatus.loading) {
            return const Center(child: CircularIndicator());
          }

          if (state.summaryStatus == TripSummaryStatus.failure) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ErrorStateWidget(
                message: state.errorMessage ?? "Failed to load details",
                onRetry: () {
                  context.read<TripsBloc>().add(
                    FetchTripDetailsRequested(widget.trip.id.toString()),
                  );
                },
              ),
            );
          }

          final summary = state.selectedTrip;
          if (summary == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EmptyStateWidget(
                title: "Trip details not found",
                onTap: () {
                  context.read<TripsBloc>().add(
                    FetchTripDetailsRequested(widget.trip.id.toString()),
                  );
                },
              ),
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    TripRouteMap(
                      height: 225,
                      olat: summary.originLat,
                      olng: summary.originLng,
                      dlat: summary.destinationLat,
                      dlng: summary.destinationLng,
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId("trip_route"),
                          color: Colors.blue, // Gives the line a clear color
                          width: 5, // Thickness of the path line
                          points: [
                            LatLng(summary.originLat, summary.originLng),
                            LatLng(summary.pickupLat, summary.pickupLng),
                            LatLng(summary.dropoffLat, summary.dropoffLng),
                            LatLng(
                              summary.destinationLat,
                              summary.destinationLng,
                            ),
                          ],
                        ),
                      },
                    ),
                    // Back button
                    Positioned(
                      top: 12,
                      left: 8,
                      right: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const BackArrowButton()],
                      ),
                    ),

                    // Bottom trip info panel
                    Positioned(
                      bottom: 0,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                          SizedBox(height: 17.8),
                          ArrivalTimeWidget(
                            sourceLat: summary.originLat,
                            sourceLng: summary.originLng,
                            destLat: summary.destinationLat,
                            destLng: summary.destinationLng,
                            departureDateTime: widget.trip.departureDateTime,
                            builder: (ctx, eta) => TripInfoCard(
                              tripInfos: [
                                TripInfo(
                                  title: "Departure",
                                  value: summary.departureTime,
                                ),
                                TripInfo(
                                  title: "Estimated arrival",
                                  value: eta.formattedArrivalTime,
                                  alignment: Alignment.center,
                                ),
                                TripInfo(
                                  title: "Distance",
                                  value: "${summary.distanceKm} km",
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Opacity(
                    opacity: widget.trip.isTripCanceled ? 0.4 : 1.0,
                    child: AbsorbPointer(
                      absorbing: widget.trip.isTripCanceled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PassengersExpandableSection(
                            passengers: state.bookings,
                            selectedTrip: state.selectedTrip,
                            builder: (passenger) {
                              if (state.bookingStatus ==
                                  TripBookingStatus.loading) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(child: CircularIndicator()),
                                );
                              }

                              if (state.bookingStatus ==
                                  TripBookingStatus.failure) {
                                return ErrorStateWidget(
                                  message: "${state.errorMessage}",
                                  title: "Error loading bookings",
                                  onRetry: _fetchTripDetail,
                                );
                              }

                              if (state.bookings.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "No passengers found for this trip.",
                                  ),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.bookings.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final booking = state.bookings[index];
                                  return PassengerActionCard(
                                    pickupPoint: summary.destinationCity,
                                    tripId: summary.id,
                                    tripSummary: summary,
                                    bookingSummary: booking,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TripBreakdownCard(
                              trip: widget.trip,
                              bookings: state.bookings,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

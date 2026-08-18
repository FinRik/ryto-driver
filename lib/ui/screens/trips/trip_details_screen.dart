import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/enums/bottom_sheet_type.dart';
import '../../../core/models/arrival_estimate.dart';
import '../../../core/models/trip/trip.dart';
import '../../../core/models/trip/trip_summary.dart';
import '../../../core/services/bottom_sheet_service.dart';
import '../../widgets/arrival_time_widget.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/buttons/button.dart';
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
  bool _hasOpenedNavigationSheet = false;
  StreamSubscription<Position>? _positionStream;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTripDetail());
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void _fetchTripDetail() {
    context.read<TripsBloc>().add(
      FetchTripDetailsRequested(widget.trip.id.toString()),
    );
  }

  /// Starts streaming the driver's live position once the trip is in
  /// progress, so trip progress can reflect actual distance covered.
  Future<void> _startLiveLocationTracking() async {
    if (_positionStream != null) return;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      if (mounted) setState(() => _currentPosition = position);
    });
  }

  /// Fraction of the trip completed. While in progress, prefers live GPS
  /// distance-to-destination and falls back to elapsed time until a fix
  /// arrives.
  double _calculateTripProgress(TripSummary summary, ArrivalEstimate eta) {
    if (summary.tripPhase == "COMPLETED") return 1.0;
    if (summary.tripPhase != "IN_PROGRESS") return 0.0;

    final position = _currentPosition;
    if (position != null && summary.distanceKm > 0) {
      final remainingMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        summary.destinationLat,
        summary.destinationLng,
      );
      final totalMeters = summary.distanceKm * 1000;
      return (1 - (remainingMeters / totalMeters)).clamp(0.0, 1.0);
    }

    if (eta.durationSeconds <= 0) return 0.0;
    final elapsedSeconds = DateTime.now()
        .difference(summary.departureDateTime)
        .inSeconds;
    return (elapsedSeconds / eta.durationSeconds).clamp(0.0, 1.0);
  }

  void _openNavigationBottomSheet(TripSummary summary) {
    sl<BottomSheetService>().showCustomBottomSheet<TripSummary, void>(
      variant: BottomSheetType.mapNavigation,
      data: summary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      removePadding: true,
      child: BlocConsumer<TripsBloc, TripsState>(
        // 1. LISTEN FOR STATE CHANGES (SIDE-EFFECTS)
        listenWhen: (previous, current) {
          final prevPhase = previous.selectedTrip?.tripPhase;
          final currPhase = current.selectedTrip?.tripPhase;

          // Trigger listener whenever phase transitions to IN_PROGRESS or initial state has IN_PROGRESS
          return currPhase == "IN_PROGRESS" && prevPhase != "IN_PROGRESS";
        },
        listener: (context, state) {
          final summary = state.selectedTrip;
          if (summary == null) return;

          _startLiveLocationTracking();

          if (!_hasOpenedNavigationSheet) {
            _hasOpenedNavigationSheet = true;
            _openNavigationBottomSheet(summary);
          }
        },
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
                    TripRouterMap(
                      height: 225,
                      olat: summary.originLat,
                      olng: summary.originLng,
                      dlat: summary.destinationLat,
                      dlng: summary.destinationLng,
                      passengers: summary.bookings,
                      polylines: {
                        // 1. Dynamic passenger paths
                        ...(summary.bookings).map((e) {
                          final String id = e.passenger.fullname;
                          return Polyline(
                            polylineId: PolylineId("passenger_path_$id"),
                            color: Colors.amber,
                            width: 4,
                            points: [
                              LatLng(
                                e.passengerPickupLat,
                                e.passengerPickupLng,
                              ),
                              LatLng(
                                e.passengerDropoffLat,
                                e.passengerDropoffLng,
                              ),
                            ],
                          );
                        }).toSet(),

                        // 2. Global Driver Route Track
                        Polyline(
                          polylineId: const PolylineId("trip_route"),
                          color: Colors.blue,
                          width: 5,
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
                          CircleAvatar(
                            child: IconButton(
                              onPressed: () async =>
                                  await sl<BottomSheetService>()
                                      .showCustomBottomSheet<TripSummary, void>(
                                        variant: BottomSheetType.mapNavigation,
                                        data: summary,
                                      ),
                              icon: Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                          SizedBox(height: 17.8),
                          ArrivalTimeWidget(
                            sourceLat: summary.originLat,
                            sourceLng: summary.originLng,
                            destLat: summary.destinationLat,
                            destLng: summary.destinationLng,
                            departureDateTime: widget.trip.departureDateTime,
                            builder: (ctx, eta) => TripInfoCard(
                              progress: _calculateTripProgress(summary, eta),
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
                            child: Column(
                              children: [
                                TripBreakdownCard(
                                  trip: widget.trip,
                                  bookings: state.bookings,
                                ),
                                const SizedBox(height: 20),
                                Button.outline(
                                  buttonColor: Color(0xffECF3FE),
                                  onTap: () => sl<BottomSheetService>()
                                      .showCustomBottomSheet(
                                    variant: BottomSheetType.contactSupport,
                                  ),
                                  text: "Contact Support",
                                ),
                              ],
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

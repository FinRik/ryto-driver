import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:ryto_driver/ui/widgets/buttons/button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/trip/trip_summary.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class InAppNavigationBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const InAppNavigationBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<InAppNavigationBottomSheet> createState() =>
      _InAppNavigationSheetState();
}

class _InAppNavigationSheetState extends State<InAppNavigationBottomSheet> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  StreamSubscription<Position>? _positionStream;

  Position? _currentDriverPosition;
  List<Polyline> _activeRouteLines = [];
  MapsRoutes _routeEngine = MapsRoutes();
  Set<Marker> _markers = {};

  // Replace with your secure Google Maps API credential key
  final String _googleApiKey = "${dotenv.env['GOOGLE_MAP_KEY_ANDROID']}";
  TripSummary get summary => widget.request.data as TripSummary;

  @override
  void initState() {
    super.initState();
    _initializeStaticMarkers();
    _startLiveLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  /// 1. Initialize Passenger Pins & Target Destinations
  void _initializeStaticMarkers() {
    final List<dynamic> bookings = summary.bookings;

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("final_destination"),
          position: LatLng(summary.destinationLat, summary.destinationLng),
          infoWindow: const InfoWindow(title: "Final Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Dynamic Passenger Pickups and Drop-offs
      for (var i = 0; i < bookings.length; i++) {
        final b = bookings[i];
        final String name = b.passenger?.fullname ?? "Passenger #${i + 1}";

        if (b.passengerPickupLat != null && b.passengerPickupLng != null) {
          _markers.add(
            Marker(
              markerId: MarkerId("p_pickup_${b.id ?? i}"),
              position: LatLng(b.passengerPickupLat, b.passengerPickupLng),
              infoWindow: InfoWindow(title: "$name (Pickup)"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange,
              ),
            ),
          );
        }

        if (b.passengerDropoffLat != null && b.passengerDropoffLng != null) {
          _markers.add(
            Marker(
              markerId: MarkerId("p_dropoff_${b.id ?? i}"),
              position: LatLng(b.passengerDropoffLat, b.passengerDropoffLng),
              infoWindow: InfoWindow(title: "$name (Drop-off)"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow,
              ),
            ),
          );
        }
      }
    });
  }

  /// 2. Active Geolocator Stream Pipeline
  void _startLiveLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Updates every 10 meters displacement
          ),
        ).listen((Position position) {
          _updateDriverPositionOnMap(position);
        });
  }

  /// 3. Update Driver UI Marker & Manage Re-routing Checkpoints
  void _updateDriverPositionOnMap(Position position) async {
    _currentDriverPosition = position;
    final driverLatLng = LatLng(position.latitude, position.longitude);

    // Dynamic rotation styling mirroring custom heading telemetry
    final Marker driverMarker = Marker(
      markerId: const MarkerId("driver_location"),
      position: driverLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      rotation: position.heading,
      infoWindow: const InfoWindow(title: "You (Driver)"),
    );

    setState(() {
      _markers.removeWhere(
        (m) => m.markerId == const MarkerId("driver_location"),
      );
      _markers.add(driverMarker);
    });

    // Animate camera perspective tracking driver movement
    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: driverLatLng,
            zoom: 16,
            bearing: position.heading,
          ),
        ),
      );
    }

    // Process path tracking/re-routing updates
    if (_activeRouteLines.isNotEmpty) {
      _processNavigationPathTracking();
    } else {
      _fetchFreshRouteFromAPI();
    }
  }

  /// 4. In-flight Route Parsing & Live Segment Trimming
  void _processNavigationPathTracking() {
    if (_currentDriverPosition == null || _routeEngine.routes.isEmpty) return;

    List<mtk.LatLng> routePoints = _routeEngine.routes.first.points
        .map((p) => mtk.LatLng(p.latitude, p.longitude))
        .toList();

    mtk.LatLng driverPos = mtk.LatLng(
      _currentDriverPosition!.latitude,
      _currentDriverPosition!.longitude,
    );

    // Match path index tracking (12-meter off-track threshold check)
    int currentIndex = mtk.PolygonUtil.locationIndexOnPath(
      driverPos,
      routePoints,
      true,
      tolerance: 12.0,
    );

    if (currentIndex == -1) {
      log("Driver drifted off course! Fetching new route segment...");
      _fetchFreshRouteFromAPI();
    } else {
      // Dynamic route cleanup: Trim segments already completed behind the driver
      routePoints[currentIndex] = driverPos;
      routePoints.removeRange(0, currentIndex);

      setState(() {
        _activeRouteLines.first.points.clear();
        _activeRouteLines.first.points.addAll(
          routePoints.map((p) => LatLng(p.latitude, p.longitude)),
        );
      });
    }
  }

  /// 5. Global API Multi-Waypoint Polyline Generation
  void _fetchFreshRouteFromAPI() async {
    if (_currentDriverPosition == null) return;

    if (_routeEngine.routes.isNotEmpty) _routeEngine.routes.clear();
    _activeRouteLines.clear();

    List<LatLng> navigationSequence = [];

    // Add current dynamic driver starting point
    navigationSequence.add(
      LatLng(
        _currentDriverPosition!.latitude,
        _currentDriverPosition!.longitude,
      ),
    );

    // Add intermediate passenger waypoint constraints dynamically
    for (var b in summary.bookings) {
      navigationSequence.add(
        LatLng(b.passengerPickupLat, b.passengerPickupLng),
      );
    }

    // Target final destination endpoint termination
    navigationSequence.add(
      LatLng(summary.destinationLat, summary.destinationLng),
    );

    if (navigationSequence.length < 2) return;

    try {
      await _routeEngine.drawRoute(
        navigationSequence,
        'live_navigation_route',
        const Color(0xFF2196F3),
        _googleApiKey,
        travelMode: TravelModes.driving,
      );

      setState(() {
        if (_routeEngine.routes.isNotEmpty) {
          _activeRouteLines.add(_routeEngine.routes.first);
        }
      });
    } catch (e) {
      log("Error processing directions fetch API: $e");
    }
  }

  Future<void> _openExternalMaps() async {
    double? destLat = summary.destinationLat;
    double? destLng = summary.destinationLng;

    // Fall back to the first active passenger pickup/drop-off if available
    if (summary.bookings != null && summary.bookings.isNotEmpty) {
      final firstBooking = summary.bookings.first;
      destLat ??= firstBooking.passengerPickupLat;
      destLng ??= firstBooking.passengerPickupLng;
    }

    if (destLat == null || destLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No destination coordinates available.')),
      );
      return;
    }

    // Google Maps navigation URI format (works on both Android and iOS)
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving',
    );

    // Apple Maps fallback URI for iOS devices
    final Uri appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$destLat,$destLng&dirflg=d',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open external map app.')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error launching map app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackCenter = LatLng(summary.originLat, summary.originLng);

    return BaseBottomSheet(
      showHandleBar: true,
      hasScrollableChild: true,
      multiplier: .98,
      padding: EdgeInsets.only(top: 14),
      builder: (context, size) {
        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: fallbackCenter,
                  zoom: 14,
                ),
                padding: EdgeInsets.zero,
                mapToolbarEnabled: false,
                markers: _markers,
                polylines: Set<Polyline>.from(_activeRouteLines),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
                  }
                },
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Text(
                  //       "In-App Navigation Active",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     Text(
                  //       "Tracking active shared passenger route",
                  //       style: TextStyle(color: Colors.grey, fontSize: 12),
                  //     ),
                  //   ],
                  // ),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.blue.shade700),
                      ),
                      onPressed: _openExternalMaps,
                      icon: Icon(Icons.navigation_rounded, color: Colors.blue.shade700),
                      label: Text(
                        "Google Maps",
                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Exit Map", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

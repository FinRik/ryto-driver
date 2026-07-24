import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/helpers/location_utils.dart';

class TripRouteMap extends StatefulWidget {
  final double? olat, olng, dlat, dlng;
  final Set<Polyline> polylines;
  final double? height;
  final bool hasRoundedEdges;

  const TripRouteMap({
    super.key,
    required this.olat,
    required this.olng,
    required this.dlat,
    required this.dlng,
    this.polylines = const {},
    this.height,
    this.hasRoundedEdges = false,
  });

  @override
  State<TripRouteMap> createState() => _TripRouteMapState();
}

class _TripRouteMapState extends State<TripRouteMap> {
  final Completer<GoogleMapController> _controller = Completer();

  // Default fallback center (e.g., Downtown NYC or 0,0) until location loads
  LatLng _currentLocation = const LatLng(0, 0);
  bool _isLocationLoaded = false;

  // Helper getters to safely check if coordinates are provided
  bool get _hasOrigin => widget.olat != null && widget.olng != null;
  bool get _hasDestination => widget.dlat != null && widget.dlng != null;
  bool get _hasBothPoints => _hasOrigin && _hasDestination;

  @override
  void initState() {
    super.initState();
    _fetchCurrentCoordinates();
  }

  @override
  void didUpdateWidget(covariant TripRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.olat != widget.olat || oldWidget.dlat != widget.dlat) &&
        _controller.isCompleted) {
      _fitToScreen();
    }
  }

  Future<void> _fetchCurrentCoordinates() async {
    try {
      final latLng = await LocationUtils.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(latLng.lat, latLng.lng);
          _isLocationLoaded = true;
        });
      }
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Set<Marker> _getMarkers() {
    final Set<Marker> markers = {};

    if (_hasOrigin) {
      markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(widget.olat!, widget.olng!),
          infoWindow: const InfoWindow(title: 'Pickup Point'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    if (_hasDestination) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(widget.dlat!, widget.dlng!),
          infoWindow: const InfoWindow(title: 'Drop-off Point'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return markers;
  }

  Future<void> _fitToScreen() async {
    if (!_hasBothPoints) return;

    final GoogleMapController controller = await _controller.future;

    final double oLat = widget.olat!;
    final double oLng = widget.olng!;
    final double dLat = widget.dlat!;
    final double dLng = widget.dlng!;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(oLat < dLat ? oLat : dLat, oLng < dLng ? oLng : dLng),
      northeast: LatLng(oLat > dLat ? oLat : dLat, oLng > dLng ? oLng : dLng),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialTarget = _hasOrigin
        ? LatLng(widget.olat!, widget.olng!)
        : _currentLocation;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.hasRoundedEdges ? 16 : 0),
      child: SizedBox(
        height: widget.height,
        child: GoogleMap(
          key: ValueKey('${initialTarget.latitude}_${initialTarget.longitude}'),
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 12,
          ),
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          trafficEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          markers: _getMarkers(),
          polylines: widget.polylines,
          onMapCreated: (controller) => _fitToScreen(),
        ),
      ),
    );
  }
}


class TripRouterMap extends StatefulWidget {
  final double? olat, olng, dlat, dlng;
  final Set<Polyline> polylines;
  final List<dynamic> passengers;
  final double? height;
  final bool hasRoundedEdges;

  const TripRouterMap({
    super.key,
    required this.olat,
    required this.olng,
    required this.dlat,
    required this.dlng,
    this.polylines = const {},
    this.passengers = const [],
    this.height,
    this.hasRoundedEdges = false,
  });

  @override
  State<TripRouterMap> createState() => _TripRouterMapState();
}

class _TripRouterMapState extends State<TripRouterMap> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng _currentLocation = const LatLng(0, 0);
  bool _isLocationLoaded = false;

  bool get _hasOrigin => widget.olat != null && widget.olng != null;
  bool get _hasDestination => widget.dlat != null && widget.dlng != null;

  @override
  void initState() {
    super.initState();
    _fetchCurrentCoordinates();
  }

  @override
  void didUpdateWidget(covariant TripRouterMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.olat != widget.olat ||
        oldWidget.dlat != widget.dlat ||
        oldWidget.passengers.length != widget.passengers.length) &&
        _controller.isCompleted) {
      _fitToScreen();
    }
  }

  Future<void> _fetchCurrentCoordinates() async {
    try {
      final latLng = await LocationUtils.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(latLng.lat, latLng.lng);
          _isLocationLoaded = true;
        });
      }
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Set<Marker> _getMarkers() {
    final Set<Marker> markers = {};

    // 1. Driver's Start Point
    if (_hasOrigin) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_origin'),
          position: LatLng(widget.olat!, widget.olng!),
          infoWindow: const InfoWindow(title: 'Driver Start (Origin)'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // 2. Dynamic Passenger Intermediate Pinpoints
    for (var i = 0; i < widget.passengers.length; i++) {
      final p = widget.passengers[i];
      final String name = p.passenger?.fullname ?? "Passenger #${i + 1}";

      if (p.passengerPickupLat != null && p.passengerPickupLng != null) {
        markers.add(
          Marker(
            markerId: MarkerId('p_pickup_${p.id ?? i}'),
            position: LatLng(p.passengerPickupLat, p.passengerPickupLng),
            infoWindow: InfoWindow(title: "$name (Pickup)"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          ),
        );
      }

      if (p.passengerDropoffLat != null && p.passengerDropoffLng != null) {
        markers.add(
          Marker(
            markerId: MarkerId('p_dropoff_${p.id ?? i}'),
            position: LatLng(p.passengerDropoffLat, p.passengerDropoffLng),
            infoWindow: InfoWindow(title: "$name (Drop-off)"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          ),
        );
      }
    }

    // 3. Driver's Route Target Final Destination
    if (_hasDestination) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_destination'),
          position: LatLng(widget.dlat!, widget.dlng!),
          infoWindow: const InfoWindow(title: 'Final Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return markers;
  }

  Future<void> _fitToScreen() async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;

    List<LatLng> allPoints = [];

    // Add driver baseline track coordinates
    if (_hasOrigin) allPoints.add(LatLng(widget.olat!, widget.olng!));
    if (_hasDestination) allPoints.add(LatLng(widget.dlat!, widget.dlng!));

    // Append passenger mid-route waypoints dynamically to avoid layout truncation
    for (var p in widget.passengers) {
      if (p.passengerPickupLat != null && p.passengerPickupLng != null) {
        allPoints.add(LatLng(p.passengerPickupLat, p.passengerPickupLng));
      }
      if (p.passengerDropoffLat != null && p.passengerDropoffLng != null) {
        allPoints.add(LatLng(p.passengerDropoffLat, p.passengerDropoffLng));
      }
    }

    if (allPoints.isEmpty) return;

    // Calculate bounding box metrics to encapsulate all array targets cleanly
    double minLat = allPoints.first.latitude;
    double maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude;
    double maxLng = allPoints.first.longitude;

    for (var point in allPoints) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Update screen frame smoothly
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialTarget = _hasOrigin
        ? LatLng(widget.olat!, widget.olng!)
        : _currentLocation;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.hasRoundedEdges ? 16 : 0),
      child: SizedBox(
        height: widget.height,
        child: GoogleMap(
          key: ValueKey('${initialTarget.latitude}_${initialTarget.longitude}_${widget.passengers.length}'),
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 11,
          ),
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          trafficEnabled: true,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,

          markers: _getMarkers(),
          polylines: widget.polylines,
          onMapCreated: (controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
            _fitToScreen();
          },
        ),
      ),
    );
  }
}
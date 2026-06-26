import 'dart:async';

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
          markers: _getMarkers(),
          polylines: widget.polylines,
          onMapCreated: (controller) => _fitToScreen(),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'
    hide LocationServiceDisabledException;

import '../../core/config/custom_dio_exception.dart';
import '../../core/models/lat_lng.dart';

class LocationUtils {
  /// Permissions
  static Future<bool> getPermissionStatus() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionPermanentlyDeniedException();
    }

    return true;
  }

  /// Fetches users current location
  static Future<LatLng> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 30),
        ),
      );

      // Get position with high accuracy
      return LatLng(lat: position.latitude, lng: position.longitude);
    } on TimeoutException {
      throw LocationTimeoutException();
    } catch (e) {
      if (e is LocationServiceDisabledException ||
          e is LocationPermissionDeniedException ||
          e is LocationPermissionPermanentlyDeniedException) {
        rethrow;
      }
      throw Exception('Failed to get current position: $e');
    }
  }

  /// Converts an address string into latitude & longitude
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        return LatLng(
          lat: locations.first.latitude,
          lng: locations.first.longitude,
          address: address,
        );
      }
      return null;
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }

  static Future<LatLng?> getAddressFromCoordinates(LatLng coord) async {
    try {
      final addresses = await placemarkFromCoordinates(coord.lat, coord.lng);

      if (addresses.isNotEmpty) {
        return LatLng(
          lat: coord.lat,
          lng: coord.lng,
          address: addresses.first.name,
        );
      }
      return null;
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }
}

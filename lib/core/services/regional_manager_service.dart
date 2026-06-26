import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/lat_lng.dart';

abstract class RegionalManagerService {
  Future<String?> getAutoDetectedCountry();
  Future<LatLng?> getCurrentPosition();
  Future<String?> getUserCountryCode(double latitude, double longitude);
}

class RegionalManagerServiceImpl implements RegionalManagerService {
  final Dio _dio;

  RegionalManagerServiceImpl(Dio dio) : _dio = dio;

  Future<Position?> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      return position;
    }
    return null;
  }

  @override
  Future<LatLng?> getCurrentPosition() async {
    final position = await _checkPermission();
    if (position != null) {
      return LatLng(lat: position.latitude, lng: position.longitude);
    }
    return null;
  }

  /// Attempts to get country code via GPS, then IP as fallback.
  /// Returns null if user denies permission or network fails.
  @override
  Future<String?> getAutoDetectedCountry() async {
    try {
      final position = await _checkPermission();

      if (position != null) {
        return await getUserCountryCode(position.latitude, position.longitude);
      }

      // Fallback if permission is denied
      return await _fetchCountryByIP();
    } catch (e) {
      // If GPS times out or fails, try IP as the final safety net
      return await _fetchCountryByIP();
    }
  }

  @override
  Future<String?> getUserCountryCode(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      return placemarks.first.isoCountryCode; // Returns 'NG', 'US', etc.
    } catch (e) {
      return null; // Handle errors/denials
    }
  }

  Future<String?> _fetchCountryByIP() async {
    try {
      // Note: Always use https for mobile to avoid Cleartext restrictions
      final response = await _dio.get('https://ipapi.co/json/');

      if (response.statusCode == 200) {
        // Dio usually decodes JSON automatically, so data['country_code'] is likely ready
        return response.data['country_code'];
      }
    } catch (e) {
      debugPrint("IP Location Error: $e");
    }
    return null;
  }
}

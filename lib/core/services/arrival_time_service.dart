import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../models/arrival_estimate.dart';

class ArrivalTimeService {
  final Dio _dio;

  ArrivalTimeService(Dio dio) : _dio = dio;

  final String? _apiKey = dotenv.env['LOCATION_PREDICTION_KEY'];

  Future<ArrivalEstimate> fetchEstimate({
    required double sLat,
    required double sLng,
    required double eLat,
    required double eLng,
    DateTime? startTime,
  }) async {
    final start = startTime ?? DateTime.now();

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/distancematrix/json',
        queryParameters: {
          'origins': '$sLat,$sLng',
          'destinations': '$eLat,$eLng',
          'key': _apiKey,
        },
        options: Options(

          extra: {'isPublic': true},
        )
      );

      if (response.data['status'] == 'OK') {
        final element = response.data['rows'][0]['elements'][0];
        final seconds = element['duration']['value'] as int;

        return ArrivalEstimate(
          durationText: element['duration']['text'],
          durationSeconds: seconds,
          destinationTime: start.add(Duration(seconds: seconds)),
          source: 'Google API',
        );
      }
      return _calculateHaversine(sLat, sLng, eLat, eLng, start);
    } catch (_) {
      return _calculateHaversine(sLat, sLng, eLat, eLng, start);
    }
  }

  ArrivalEstimate _calculateHaversine(
    double sLat,
    double sLng,
    double eLat,
    double eLng,
    DateTime start,
  ) {
    // 1. Calculate distance
    double distanceInMeters = Geolocator.distanceBetween(
      sLat,
      sLng,
      eLat,
      eLng,
    );

    // 2. Adjust for real-world road winding (20% buffer) and speed (approx 45km/h)
    double roadDistance = distanceInMeters * 1.2;
    int seconds = (roadDistance / 12.5).round();

    return ArrivalEstimate(
      durationText: '${(seconds / 60).round()} mins',
      durationSeconds: seconds,
      destinationTime: start.add(Duration(seconds: seconds)),
      source: 'Haversine Fallback',
    );
  }
}

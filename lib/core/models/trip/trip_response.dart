import 'package:json_annotation/json_annotation.dart';

import '../../../utils/logger/logger.dart';
import '../meta.dart';
import 'trip.dart';

part 'trip_response.g.dart';

@JsonSerializable()
class TripResponse {
  final List<Trip> data;
  final Meta? meta;

  TripResponse({required this.data, this.meta});

  // Parses each trip individually so one malformed record doesn't discard
  // the whole list (the generated `_$TripResponseFromJson` maps the list in
  // one shot, so a single bad entry would throw and lose every trip).
  factory TripResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? const [];
    final trips = <Trip>[];

    for (final item in rawList) {
      try {
        trips.add(Trip.fromJson(item as Map<String, dynamic>));
      } catch (e, s) {
        AppLogger.e('Skipping malformed trip entry', 'TripResponse', e, s);
      }
    }

    return TripResponse(
      data: trips,
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$TripResponseToJson(this);
}

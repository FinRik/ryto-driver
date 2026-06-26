import 'package:json_annotation/json_annotation.dart';

import '../meta.dart';
import 'trip.dart';

part 'trip_response.g.dart';

@JsonSerializable()
class TripResponse {
  final List<Trip> data;
  final Meta? meta;

  TripResponse({required this.data, this.meta});

  factory TripResponse.fromJson(Map<String, dynamic> json) =>
      _$TripResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TripResponseToJson(this);
}

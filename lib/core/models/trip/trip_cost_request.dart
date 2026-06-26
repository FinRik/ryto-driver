import 'package:json_annotation/json_annotation.dart';

import '../lat_lng.dart';

part 'trip_cost_request.g.dart';

@JsonSerializable()
class TripCostRequest {
  final int? tripId;

  final String? bookingLocation;
  final int? vehicleId;
  final int? seats;

  // start package
  final String? packageSize;
  final int? packageWeight;
  final List<String>? packageHandlingOptions;
  final String? packageContent;
  // end package

  final LatLng? originLocation;
  final LatLng? pickupLocation;
  final LatLng? dropoffLocation;
  final LatLng? destinationLocation;

  TripCostRequest({
    this.tripId,
    this.bookingLocation,
    this.vehicleId,
    this.seats,
    this.packageSize,
    this.packageWeight,
    this.packageHandlingOptions,
    this.packageContent,
    this.originLocation,
    this.pickupLocation,
    this.dropoffLocation,
    this.destinationLocation,
  });

  TripCostRequest copyWith({
    int? tripId,
    String? bookingLocation,
    int? vehicleId,
    int? seats,
    String? packageSize,
    int? packageWeight,
    List<String>? packageHandlingOptions,
    String? packageContent,
    LatLng? originLocation,
    LatLng? pickupLocation,
    LatLng? dropoffLocation,
    LatLng? destinationLocation,
  }) {
    return TripCostRequest(
      tripId: tripId ?? this.tripId,
      bookingLocation: bookingLocation ?? this.bookingLocation,
      vehicleId: vehicleId ?? this.vehicleId,
      seats: seats ?? this.seats,
      packageSize: packageSize ?? this.packageSize,
      packageWeight: packageWeight ?? this.packageWeight,
      packageHandlingOptions:
      packageHandlingOptions ?? this.packageHandlingOptions,
      packageContent: packageContent ?? this.packageContent,
      originLocation: originLocation ?? this.originLocation,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
    );
  }

  factory TripCostRequest.fromJson(Map<String, dynamic> json) =>
      _$TripCostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TripCostRequestToJson(this);
}
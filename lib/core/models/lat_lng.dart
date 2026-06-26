class LatLng {
  final double lat;
  final double lng;
  final String? address;

  LatLng({required this.lat, required this.lng, this.address});

  factory LatLng.fromJson(Map<String, dynamic> json) => LatLng(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
    address: json['address'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'address': address,
    // "latitude": lat,
    // "longitude": lng,
    // "address": address,
  };
}

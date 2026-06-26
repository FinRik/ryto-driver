class VehicleDetailsRequest {
  final String type;
  final String makeModel;
  final int year;
  final String color;
  final String plateNumber;

  VehicleDetailsRequest({
    required this.type,
    required this.makeModel,
    required this.year,
    required this.color,
    required this.plateNumber,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "makeModel": makeModel,
    "year": year,
    "color": color,
    "plateNumber": plateNumber,
  };
}

class VehicleCapacityRequest {
  final int passengerSeats;
  final bool frontSeatAvailable;
  final bool loadSmallPackages;
  final bool loadMediumLoads;
  final bool loadLargeLoads;
  final String storageLocation;

  VehicleCapacityRequest({
    required this.passengerSeats,
    required this.frontSeatAvailable,
    required this.loadSmallPackages,
    required this.loadMediumLoads,
    required this.loadLargeLoads,
    required this.storageLocation,
  });

  Map<String, dynamic> toJson() => {
    "passengerSeats": passengerSeats,
    "frontSeatAvailable": frontSeatAvailable,
    "loadSmallPackages": loadSmallPackages,
    "loadMediumLoads": loadMediumLoads,
    "loadLargeLoads": loadLargeLoads,
    "storageLocation": storageLocation,
  };
}

class VehicleDocsRequest {
  final String license;
  final String roadworthiness;
  final String insurance;
  final String photoFront;
  final String photoBack;
  final String photoSide;
  final String photoInterior;
  final String photoOther;

  VehicleDocsRequest({
    required this.license,
    required this.roadworthiness,
    required this.insurance,
    required this.photoFront,
    required this.photoBack,
    required this.photoSide,
    required this.photoInterior,
    required this.photoOther,
  });

  Map<String, dynamic> toJson() => {
    "license": license,
    "roadworthiness": roadworthiness,
    "insurance": insurance,
    "photoFront": photoFront,
    "photoBack": photoBack,
    "photoSide": photoSide,
    "photoInterior": photoInterior,
    "photoOther": photoOther,
  };
}

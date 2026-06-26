part of "vehicle_setup_bloc.dart";

abstract class VehicleSetupEvent extends Equatable {
  const VehicleSetupEvent();

  @override
  List<Object?> get props => [];
}

class AddVehicleDetailsRequested extends VehicleSetupEvent {
  final VehicleDetailsRequest request;
  const AddVehicleDetailsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class AddVehicleCapacityRequested extends VehicleSetupEvent {
  final VehicleCapacityRequest request;
  const AddVehicleCapacityRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class AddVehicleDocumentsRequested extends VehicleSetupEvent {
  final File license;
  final File roadworthiness;
  final File insurance;
  final File photoFront;
  final File photoBack;
  final File photoSide;
  final File photoInterior;
  final File photoOther;

  const AddVehicleDocumentsRequested({
    required this.license,
    required this.roadworthiness,
    required this.insurance,
    required this.photoFront,
    required this.photoBack,
    required this.photoSide,
    required this.photoInterior,
    required this.photoOther,
  });

  @override
  List<Object?> get props => [
    license, roadworthiness, insurance, photoFront,
    photoBack, photoSide, photoInterior, photoOther
  ];
}

class FetchVehicleDetails extends VehicleSetupEvent {}
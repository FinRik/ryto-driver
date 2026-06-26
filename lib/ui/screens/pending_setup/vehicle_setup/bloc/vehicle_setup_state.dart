part of "vehicle_setup_bloc.dart";

// abstract class VehicleSetupState extends Equatable {
//   const VehicleSetupState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class VehicleInitial extends VehicleSetupState {}
//
// class VehicleLoading extends VehicleSetupState {}
//
// class VehicleSuccess extends VehicleSetupState {
//   final String? message;
//   const VehicleSuccess({this.message});
// }
//
// class VehicleFailure extends VehicleSetupState {
//   final String error;
//   const VehicleFailure(this.error);
//
//   @override
//   List<Object?> get props => [error];
// }
//
// class VehicleDetailsLoaded extends VehicleSetupState {
//   final VehicleDetail vehicle;
//   const VehicleDetailsLoaded(this.vehicle);
//
//   @override
//   List<Object?> get props => [vehicle];
// }

enum VehicleStatus { initial, loading, success, failure, loaded }

class VehicleSetupState extends Equatable {
  final VehicleStatus status;
  final String? message;
  final String? error;
  final VehicleDetail? vehicleDetails;

  const VehicleSetupState({
    this.status = VehicleStatus.initial,
    this.message,
    this.error,
    this.vehicleDetails,
  });

  VehicleSetupState copyWith({
    VehicleStatus? status,
    String? message,
    String? error,
    VehicleDetail? vehicleDetails,
  }) {
    return VehicleSetupState(
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
    );
  }

  // Conversion factory for HydratedBloc persistence
  factory VehicleSetupState.fromMap(Map<String, dynamic> map) {
    return VehicleSetupState(
      status: VehicleStatus.values[map['status'] ?? 0],
      message: map['message'] as String?,
      error: map['error'] as String?,
      vehicleDetails: map['vehicleDetails'] != null
          ? VehicleDetail.fromJson(
              map['vehicleDetails'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.index,
      'message': message,
      'error': error,
      'vehicleDetails': vehicleDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [status, message, error, vehicleDetails];
}

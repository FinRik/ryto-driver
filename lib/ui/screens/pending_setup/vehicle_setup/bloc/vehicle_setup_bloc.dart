import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../../core/models/vehicle_setup/vehicle_detail.dart';
import '../../../../../core/models/vehicle_setup/vehicle_setup_request.dart';
import '../../../../../core/repos/pending_setup_repo.dart';

part 'vehicle_setup_event.dart';
part 'vehicle_setup_state.dart';

// class VehicleSetupBloc extends Bloc<VehicleSetupEvent, VehicleSetupState> {
//   final PendingSetupRepo _repo;
//
//   VehicleSetupBloc(this._repo) : super(VehicleInitial()) {
//     // 1. Add Vehicle Basic Details
//     on<AddVehicleDetailsRequested>((event, emit) async {
//       emit(VehicleLoading());
//       try {
//         final success = await _repo.addVehicleDetails(event.request);
//         success
//             ? emit(const VehicleSuccess(message: "Details saved successfully"))
//             : emit(const VehicleFailure("Failed to save vehicle details"));
//       } catch (e) {
//         emit(VehicleFailure(e.toString()));
//       }
//     });
//
//     // 2. Add Vehicle Capacity
//     on<AddVehicleCapacityRequested>((event, emit) async {
//       emit(VehicleLoading());
//       try {
//         final success = await _repo.addVehicleCapacity(event.request);
//         success
//             ? emit(const VehicleSuccess(message: "Capacity updated"))
//             : emit(const VehicleFailure("Failed to update capacity"));
//       } catch (e) {
//         emit(VehicleFailure(e.toString()));
//       }
//     });
//
//     // 3. Upload All Vehicle Documents
//     on<AddVehicleDocumentsRequested>((event, emit) async {
//       emit(VehicleLoading());
//       try {
//         final success = await _repo.addVehicleDocument(
//           license: event.license,
//           roadworthiness: event.roadworthiness,
//           insurance: event.insurance,
//           photoFront: event.photoFront,
//           photoBack: event.photoBack,
//           photoSide: event.photoSide,
//           photoInterior: event.photoInterior,
//           photoOther: event.photoOther,
//         );
//         success
//             ? emit(
//                 const VehicleSuccess(
//                   message: "Documents uploaded successfully",
//                 ),
//               )
//             : emit(const VehicleFailure("Document upload failed"));
//       } catch (e) {
//         emit(VehicleFailure(e.toString()));
//       }
//     });
//
//     // 4. Fetch Existing Vehicle Info
//     on<FetchVehicleDetails>((event, emit) async {
//       emit(VehicleLoading());
//       try {
//         final success = await _repo.fetchVehicleDetails();
//         success != null
//             ? emit(VehicleDetailsLoaded(success))
//             : emit(const VehicleFailure("Could not fetch vehicle details"));
//       } catch (e) {
//         emit(VehicleFailure(e.toString()));
//       }
//     });
//   }
// }

class VehicleSetupBloc
    extends HydratedBloc<VehicleSetupEvent, VehicleSetupState> {
  final PendingSetupRepo _repo;

  VehicleSetupBloc(this._repo) : super(const VehicleSetupState()) {
    // 1. Add Vehicle Basic Details
    on<AddVehicleDetailsRequested>((event, emit) async {
      emit(state.copyWith(status: VehicleStatus.loading));
      try {
        final success = await _repo.addVehicleDetails(event.request);
        if (success) {
          emit(
            state.copyWith(
              status: VehicleStatus.success,
              message: "Details saved successfully",
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: VehicleStatus.failure,
              error: "Failed to save vehicle details",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: VehicleStatus.failure,
            error: "Failed to save vehicle details, Please try again later",
          ),
        );
      }
    });

    // 2. Add Vehicle Capacity
    on<AddVehicleCapacityRequested>((event, emit) async {
      emit(state.copyWith(status: VehicleStatus.loading));
      try {
        final success = await _repo.addVehicleCapacity(event.request);
        if (success) {
          emit(
            state.copyWith(
              status: VehicleStatus.success,
              message: "Capacity updated",
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: VehicleStatus.failure,
              error: "Failed to update capacity",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: VehicleStatus.failure,
            error: "Failed to update vehicle capacity",
          ),
        );
      }
    });

    // 3. Upload All Vehicle Documents
    on<AddVehicleDocumentsRequested>((event, emit) async {
      emit(state.copyWith(status: VehicleStatus.loading));
      try {
        final success = await _repo.addVehicleDocument(
          license: event.license,
          roadworthiness: event.roadworthiness,
          insurance: event.insurance,
          photoFront: event.photoFront,
          photoBack: event.photoBack,
          photoSide: event.photoSide,
          photoInterior: event.photoInterior,
          photoOther: event.photoOther,
        );
        if (success) {
          emit(
            state.copyWith(
              status: VehicleStatus.success,
              message: "Documents uploaded successfully",
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: VehicleStatus.failure,
              error: "Document upload failed",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: VehicleStatus.failure,
            error: "Failed to upload vehicle documents, Please try again",
          ),
        );
      }
    });

    // 4. Fetch Existing Vehicle Info
    on<FetchVehicleDetails>((event, emit) async {
      emit(state.copyWith(status: VehicleStatus.loading));
      try {
        final vehicle = await _repo.fetchVehicleDetails();
        if (vehicle != null) {
          emit(
            state.copyWith(
              status: VehicleStatus.loaded,
              vehicleDetails: vehicle,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: VehicleStatus.failure,
              error: "Could not fetch vehicle details",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: VehicleStatus.failure,
            error: "Failed to fetch vehicle details",
          ),
        );
      }
    });
  }

  // HydratedBloc: Restore state from storage
  @override
  VehicleSetupState? fromJson(Map<String, dynamic> json) {
    try {
      return VehicleSetupState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  // HydratedBloc: Persist state to storage
  @override
  Map<String, dynamic>? toJson(VehicleSetupState state) {
    try {
      return state.toMap();
    } catch (_) {
      return null;
    }
  }
}

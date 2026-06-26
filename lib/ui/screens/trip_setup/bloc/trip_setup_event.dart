part of 'trip_setup_bloc.dart';

abstract class TripSetupEvent extends Equatable {
  const TripSetupEvent();
  @override
  List<Object?> get props => [];
}

class UpdateTripDraft extends TripSetupEvent {
  final CreateTripRequest updatedDraft;
  const UpdateTripDraft(this.updatedDraft);

  @override
  List<Object?> get props => [updatedDraft];
}

class FetchBookingCostRequested extends TripSetupEvent {}

class CreateTripRequested extends TripSetupEvent {
  final CreateTripRequest request;
  const CreateTripRequested(this.request);
}

class ResetTripSetup extends TripSetupEvent {
  const ResetTripSetup();

  @override
  List<Object?> get props => [];
}
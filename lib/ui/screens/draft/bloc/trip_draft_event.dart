part of "trip_draft_bloc.dart";

abstract class TripDraftEvent {}

// Saves a new draft or updates an existing one if it matches a draftId
class SaveOrUpdateDraft extends TripDraftEvent {
  final CreateTripRequest draft;
  SaveOrUpdateDraft(this.draft);
}

// Removes a draft from the list (e.g., after successful publication or manual deletion)
class DeleteDraft extends TripDraftEvent {
  final String draftId;
  DeleteDraft(this.draftId);
}
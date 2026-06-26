import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../../core/models/trip/create_trip_request.dart';

part 'trip_draft_event.dart';
part 'trip_draft_state.dart';

class TripDraftBloc extends HydratedBloc<TripDraftEvent, TripDraftState> {
  TripDraftBloc() : super(TripDraftState()) {
    on<SaveOrUpdateDraft>(_onSaveOrUpdateDraft);
    on<DeleteDraft>(_onDeleteDraft);
  }

  void _onSaveOrUpdateDraft(
    SaveOrUpdateDraft event,
    Emitter<TripDraftState> emit,
  ) {
    final updatedList = List<CreateTripRequest>.from(state.drafts);

    // Check if the draft already has an ID and exists in our list
    if (event.draft.draftId != null) {
      final index = updatedList.indexWhere(
        (d) => d.draftId == event.draft.draftId,
      );

      if (index != -1) {
        // Update existing draft
        updatedList[index] = event.draft;
      } else {
        // Edge case: ID exists but isn't in list, append it
        updatedList.add(event.draft);
      }
    } else {
      // It's a completely new draft! Generate a unique draftId using timestamp
      final newDraft = event.draft.copyWith(
        draftId: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      updatedList.add(newDraft);
    }

    emit(TripDraftState(drafts: updatedList));
  }

  void _onDeleteDraft(DeleteDraft event, Emitter<TripDraftState> emit) {
    final updatedList = List<CreateTripRequest>.from(state.drafts)
      ..removeWhere((draft) => draft.draftId == event.draftId);

    emit(TripDraftState(drafts: updatedList));
  }

  // --- HydratedBloc Storage Deserialization ---
  @override
  TripDraftState? fromJson(Map<String, dynamic> json) {
    try {
      final draftsList = json['drafts'] as List;
      final loadedDrafts = draftsList
          .map(
            (item) => CreateTripRequest.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return TripDraftState(drafts: loadedDrafts);
    } catch (_) {
      return null;
    }
  }

  // --- HydratedBloc Storage Serialization ---
  @override
  Map<String, dynamic>? toJson(TripDraftState state) {
    return {'drafts': state.drafts.map((draft) => draft.toJson()).toList()};
  }
}

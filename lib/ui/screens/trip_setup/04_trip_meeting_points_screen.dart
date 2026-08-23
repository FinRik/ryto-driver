import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;

import '../../../core/models/lat_lng.dart';
import '../../widgets/inputs/place_suggestion_widget.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/texts/header_text.dart';

import '../../widgets/trip_route_map.dart';
import 'bloc/trip_setup_bloc.dart';

class SetMeetingPointsScreen extends StatefulWidget {
  const SetMeetingPointsScreen({super.key});

  @override
  State<SetMeetingPointsScreen> createState() => _SetMeetingPointsScreenState();
}

class _SetMeetingPointsScreenState extends State<SetMeetingPointsScreen> {
  final _noteController = TextEditingController();
  final _scrollController = ScrollController();
  final _noteFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final draft = context.read<TripSetupBloc>().state.draft;
    _noteController.text = draft.notes;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateMeetingPointsInBloc({
    double? pLat,
    double? pLng,
    double? dLat,
    double? dLng,
    String? note,
  }) {
    final bloc = context.read<TripSetupBloc>();

    final newDraft = bloc.state.draft.copyWith(
      pickupLat: pLat,
      pickupLng: pLng,
      dropoffLat: dLat,
      dropoffLng: dLng,
      notes: note,
    );

    bloc.add(UpdateTripDraft(newDraft));
  }

  // Scrolls the note field into view above the keyboard once it has
  // finished animating into place.
  void _scrollNoteFieldIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _noteFieldKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      // Let the scaffold shrink when the keyboard opens — this is what
      // gives the SingleChildScrollView room to scroll the focused field
      // up above the keyboard instead of letting the keyboard cover it.
      resizeToAvoidBottomInset: true,
      child: BlocConsumer<TripSetupBloc, TripSetupState>(
        listener: (context, state) {
          if (state.status == TripSetupStatus.success &&
              state.costSummary != null) {
            router.push(Paths.TRIPSUMMARY);
            // } else if (state.status == TripSetupStatus.failure) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(state.errorMessage ?? "An error occurred"),
            //     ),
            //   );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == TripSetupStatus.loading;
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;

          return GestureDetector(
            // Tapping outside any field dismisses the keyboard.
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              controller: _scrollController,
              // Extra bottom padding so the last fields (and the button)
              // can scroll clear of the keyboard rather than sitting
              // right under it.
              padding: EdgeInsets.only(
                bottom: bottomInset > 0 ? 24 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderText(
                    label: "Set Meeting Points",
                    subText: "Define specific landmarks for your passengers.",
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  _buildAutocompleteInput(
                    label: "General Pickup Spot",
                    hint: "Search pickup landmark...",
                    icon: Icons.location_on_outlined,
                    iconColor: Colors.green,
                    onSelected: (place) async {
                      _updateMeetingPointsInBloc(
                        pLat: place.lat,
                        pLng: place.lng,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  _buildAutocompleteInput(
                    label: "General Drop-off Spot",
                    hint: "Search drop-off landmark...",
                    icon: Icons.location_on_outlined,
                    iconColor: Colors.red,
                    onSelected: (place) {
                      _updateMeetingPointsInBloc(
                        dLat: place.lat,
                        dLng: place.lng,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  TripRouteMap(
                    olat: state.draft.originLat,
                    olng: state.draft.originLng,
                    dlat: state.draft.destinationLat,
                    dlng: state.draft.destinationLng,
                    hasRoundedEdges: true,
                    height: 200,
                    polylines: {
                      map.Polyline(
                        polylineId: map.PolylineId("Pickup Set"),
                        points: [
                          map.LatLng(
                            state.draft.pickupLat,
                            state.draft.pickupLng,
                          ),
                        ],
                      ),
                      map.Polyline(
                        polylineId: map.PolylineId("Drop-off Set"),
                        points: [
                          map.LatLng(
                            state.draft.dropoffLat,
                            state.draft.dropoffLng,
                          ),
                        ],
                      ),
                    },
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    "Add Note",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2559),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: _noteFieldKey,
                    controller: _noteController,
                    maxLines: 5,
                    onTap: _scrollNoteFieldIntoView,
                    decoration: InputDecoration(
                      hintText: "Write your thoughts here...",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE0E5F2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF0061FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Button(
                    onTap: () {
                      _updateMeetingPointsInBloc(note: _noteController.text);
                      context.read<TripSetupBloc>().add(
                        FetchBookingCostRequested(),
                      );
                    },
                    text: "Review Trip",
                    isBusy: isLoading,
                    showSuffixIcon: true,
                    suffixIcon: Icons.chevron_right,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAutocompleteInput({
    TextEditingController? controller,
    required String hint,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Function(LatLng) onSelected,
  }) {
    return PlacesSuggestionWidget(
      hint: hint,
      label: label,
      prefixIcon: null,
      controller: controller,
      onPlaceSelected: (place) async {
        // controller.text = place.address!;
        onSelected(place);
      },
    );
  }
}
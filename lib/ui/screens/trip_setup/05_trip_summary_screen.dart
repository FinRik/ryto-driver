import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/lat_lng.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/build_route_card.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/currency_formatter_widget.dart';
import '../../widgets/trip_route_map.dart';
import '../draft/bloc/trip_draft_bloc.dart';
import 'bloc/trip_setup_bloc.dart';

class TripSummaryScreen extends StatelessWidget {
  const TripSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripSetupBloc, TripSetupState>(
      listener: (context, state) {
        if (state.status == TripSetupStatus.success) {
          router.go(Paths.TRIPSUCCESS, extra: false);
        }
      },
      builder: (context, state) {
        final draft = state.draft;
        final isLoading = state.status == TripSetupStatus.loading;

        return BaseScaffoldWidget(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.all(12.0),
              child: BackArrowButton(),
            ),
            title: const Text(
              "Trip Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0F2F5)),
                  ),
                  child: BuildRouteCard(
                    startCoord: LatLng(
                      lat: draft.pickupLat,
                      lng: draft.pickupLng,
                    ),
                    stopCoord: LatLng(
                      lat: draft.dropoffLat,
                      lng: draft.dropoffLng,
                    ),
                    departureDate: draft.departureDate,
                    departureTime: draft.departureTime,
                    departureDateTime: draft.departureDateTime,
                    originCity: draft.originCity,
                    destCity: draft.destinationCity,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    TripRouteMap(
                      olat: draft.pickupLng,
                      olng: draft.pickupLat,
                      dlat: draft.dropoffLat,
                      dlng: draft.dropoffLng,
                      height: 180,
                      hasRoundedEdges: false,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF8F9FB),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.map_outlined,
                            color: Color(0xFF8F9BBA),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Confirmed Route",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.directions,
                            color: Color(0xFF8F9BBA),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "Trip Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailTile(
                        icon: Icons.event_seat_outlined,
                        title: "Available Seats",
                        value: "${draft.passengerSeats} Seats",
                        isPrice: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailTile(
                        icon: Icons.inventory_2_outlined,
                        title: "Price per Seat",
                        value: "${state.costSummary?.finalPrice?.formatted}",
                        isPrice: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildNotesCard(draft.notes),
                const SizedBox(height: 40),

                // Updated Action Buttons Logic
                Button(
                  onTap: () => context.read<TripSetupBloc>().add(
                    CreateTripRequested(draft),
                  ),
                  text: "Publish Trip",
                  isBusy: isLoading,
                  showSuffixIcon: true,
                  suffixIcon: Icons.keyboard_arrow_right_outlined,
                ),

                const SizedBox(height: 12),

                if (!isLoading)
                  Button.outline(
                    onTap: () {
                      var uuid = Uuid();
                      final newDraft = draft.copyWith(draftId: uuid.v1());
                      context.read<TripDraftBloc>().add(
                        SaveOrUpdateDraft(newDraft),
                      );

                      router.go(Paths.TRIPSUCCESS, extra: true);
                    },
                    text: "Save as Draft",
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesCard(String notes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF0F2F5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined),
              SizedBox(width: 8),
              Text("Trip Notes"),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notes.isEmpty ? "No notes provided for this trip." : notes,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF1B2559),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isPrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF0061FF)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Color(0xFF8F9BBA)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isPrice)
            CurrencyFormatterWidget(amount: value)
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2559),
              ),
            ),
        ],
      ),
    );
  }
}

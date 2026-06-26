import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/trip/create_trip_request.dart';
import '../trip_setup/bloc/trip_setup_bloc.dart';
import 'bloc/trip_draft_bloc.dart';

class TripDraftsListScreen extends StatelessWidget {
  const TripDraftsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to the TripSetupBloc to handle publication response states
        BlocListener<TripSetupBloc, TripSetupState>(
          listener: (context, setupState) {
            if (setupState.status == TripSetupStatus.loading) {
              // Show a blocking or non-blocking loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Publishing trip...'),
                  duration: Duration(
                    days: 1,
                  ), // Keeps it up until dismissed manually
                ),
              );
            }

            if (setupState.status == TripSetupStatus.success) {
              // 1. Dismiss the loading indicator
              ScaffoldMessenger.of(context).clearSnackBars();

              // 2. Safely extract the last requested draft context if your state tracks it,
              // or handle removal. If you need explicit targeting, you can pass the draftId
              // through a state property, or handle it via a local callback variable.
              // For a straightforward cleanup, we can let success handle notifications:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trip published successfully!')),
              );
            }

            // if (setupState is TripSetupFailure) {
            //   // Dismiss loading and display the server error message
            //   ScaffoldMessenger.of(context).clearSnackBars();
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('Publication failed: ${setupState.error}')),
            //   );
            // }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Saved Drafts',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<TripDraftBloc, TripDraftState>(
          builder: (context, state) {
            if (state.drafts.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.drafts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final draft = state.drafts[index];
                return _buildDraftCard(context, draft);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved drafts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Trips you start creating but save for later will appear right here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftCard(BuildContext context, CreateTripRequest draft) {
    final hasRouteInfo =
        draft.originCity.isNotEmpty || draft.destinationCity.isNotEmpty;
    final titleText = hasRouteInfo
        ? '${draft.originCity.isEmpty ? 'Unknown' : draft.originCity} → ${draft.destinationCity.isEmpty ? 'Unknown' : draft.destinationCity}'
        : 'Untitled Trip Draft';

    final hasTimeInfo =
        draft.departureDate.isNotEmpty || draft.departureTime.isNotEmpty;
    final subtitleText = hasTimeInfo
        ? 'Departs: ${draft.departureDate} at ${draft.departureTime}'
        : 'No departure date set yet';

    return Dismissible(
      key: Key(draft.draftId ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (draft.draftId != null) {
          context.read<TripDraftBloc>().add(DeleteDraft(draft.draftId!));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Draft deleted successfully')),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.time_to_leave,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitleText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.airline_seat_recline_normal,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${draft.passengerSeats} seats',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    if (draft.packagesAllowed) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.local_shipping,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Packages OK',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            // 1. Dispatch the data to setup / publish on the server
            context.read<TripSetupBloc>().add(CreateTripRequested(draft));

            // 2. Optimistically clean it out of your local cached list on tap
            // so the UI refreshes immediately
            if (draft.draftId != null) {
              context.read<TripDraftBloc>().add(DeleteDraft(draft.draftId!));
            }
          },
        ),
      ),
    );
  }
}

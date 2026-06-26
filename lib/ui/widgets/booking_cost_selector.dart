import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/trip/trip_cost_request.dart';
import '../../core/models/trip/trip_cost_summary.dart';
import '../../core/repos/booking_repo.dart';
import '../blocs/booking_cost/booking_cost_cubit.dart';
import 'loaders/circular_indicator.dart';

typedef BookingCostBuilder =
    Widget Function(BuildContext context, TripCostSummary summary);

class BookingCostSelector extends StatelessWidget {
  final TripCostRequest request;
  final BookingCostBuilder builder;

  const BookingCostSelector({
    super.key,
    required this.request,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(request),
      create: (context) =>
          BookingCostCubit(context.read<BookingRepo>())..calculateCost(request),
      child: BlocBuilder<BookingCostCubit, BookingCostState>(
        builder: (context, state) {
          if (state is BookingCostLoading) {
            return const Center(child: CircularIndicator());
          }

          if (state is BookingCostError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingCostLoaded) {
            return builder(context, state.summary);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

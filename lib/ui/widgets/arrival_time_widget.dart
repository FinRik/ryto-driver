import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/arrival_estimate.dart';
import '../../core/repos/arrival_time_repo.dart';
import '../blocs/arrival_time/arrival_time_cubit.dart';
import 'loaders/circular_indicator.dart';

typedef ArrivalBuilder =
    Widget Function(BuildContext context, ArrivalEstimate estimate);

class ArrivalTimeWidget extends StatelessWidget {
  final double sourceLat;
  final double sourceLng;
  final double destLat;
  final double destLng;
  final DateTime departureDateTime;
  final ArrivalBuilder builder;

  const ArrivalTimeWidget({
    super.key,
    required this.sourceLat,
    required this.sourceLng,
    required this.destLat,
    required this.destLng,
    required this.departureDateTime,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ArrivalTimeCubit(context.read<ArrivalTimeRepo>())..fetchArrivalData(
            sLat: sourceLat,
            sLng: sourceLng,
            eLat: destLat,
            eLng: destLng,
            departureDateTime: departureDateTime,
          ),
      child: BlocBuilder<ArrivalTimeCubit, AsyncSnapshot<ArrivalEstimate>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot.data!);
          }
          return const CircularIndicator();
        },
      ),
    );
  }
}

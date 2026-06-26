import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/lat_lng.dart';
import '../blocs/location_fetch/location_fetch_cubit.dart';
import 'loaders/circular_indicator.dart';

typedef LocationWidgetBuilder = Widget Function(BuildContext, LatLng?);

class LocationFetchBuilder extends StatefulWidget {
  final LatLng address;
  final LocationWidgetBuilder builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const LocationFetchBuilder({
    super.key,
    required this.address,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<LocationFetchBuilder> createState() => _LocationFetchBuilderState();
}

// class _LocationFetchBuilderState extends State<LocationFetchBuilder> {
//   late Future<LatLng?> _locationFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _locationFuture = LocationUtils.getAddressFromCoordinates(widget.address);
//   }
//
//   @override
//   void didUpdateWidget(LocationFetchBuilder oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Refresh the future if the address changes
//     if (oldWidget.address != widget.address) {
//       _locationFuture = LocationUtils.getAddressFromCoordinates(widget.address);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<LatLng?>(
//       future: _locationFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return widget.loadingWidget ?? const Center(child: CircularIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return widget.errorWidget ?? const Center(child: Text('Error loading location'));
//         }
//
//         // Pass the result (which could be null) to your custom builder
//         return widget.builder(context, snapshot.data);
//       },
//     );
//   }
// }

class _LocationFetchBuilderState extends State<LocationFetchBuilder> {
  late final LocationFetchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = LocationFetchCubit();
    _cubit.fetchLocation(widget.address);
  }

  // @override
  // void didUpdateWidget(LocationFetchBuilder oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.address != widget.address) {
  //     _cubit.fetchLocation(widget.address, forceRefresh: true);
  //   }
  // }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<LocationFetchCubit, LocationFetchState>(
        builder: (context, state) {
          switch (state.status) {
            case LocationFetchStatus.initial:
            case LocationFetchStatus.loading:
              return widget.loadingWidget ??
                  const Center(child: CircularIndicator());

            case LocationFetchStatus.error:
              return widget.errorWidget ??
                  const Center(child: Text('Error loading location'));

            case LocationFetchStatus.success:
              return widget.builder(context, state.location);
          }
        },
      ),
    );
  }
}

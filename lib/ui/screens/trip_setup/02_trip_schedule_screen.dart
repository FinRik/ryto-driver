import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import 'bloc/trip_setup_bloc.dart';
import 'widgets/arrival_estimation_box.dart';
import 'widgets/trip_calendar_card.dart';

import 'widgets/trip_time_picker.dart';

class SetTripScheduleScreen extends StatefulWidget {
  const SetTripScheduleScreen({super.key});

  @override
  State<SetTripScheduleScreen> createState() => _SetTripScheduleScreenState();
}

class _SetTripScheduleScreenState extends State<SetTripScheduleScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _selectedTime = DateTime.now();
  }

  void _updateScheduleInBloc() {
    final bloc = context.read<TripSetupBloc>();
    final combinedDateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newDraft = bloc.state.draft.copyWith(
      departureDateTime: combinedDateTime,
    );

    bloc.add(UpdateTripDraft(newDraft));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripSetupBloc, TripSetupState>(
      builder: (context, state) {
        final destination = state.draft.destinationCity.isEmpty
            ? "Your Destination"
            : state.draft.destinationCity;

        return BaseScaffoldWidget(
          appBar: AppBar(
            title: const Text("Set Schedule"),
            centerTitle: true,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Departure Date",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDay = DateTime.now();
                            _focusedDay = DateTime.now();
                          });
                          _updateScheduleInBloc();
                        },
                        child: const Text("Today")
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 1. Calendar Section
                TripCalendarCard(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  selectedTime: _selectedTime,
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                    _updateScheduleInBloc();
                  },
                ),

                const SizedBox(height: 24),

                // 2. Custom Time Picker Wheel
                TripTimePicker(
                  initialTime: _selectedTime,
                  onTimeChanged: (newTime) {
                    setState(() => _selectedTime = newTime);
                    _updateScheduleInBloc();
                  },
                ),

                const SizedBox(height: 24),

                // 3. Estimated Arrival Box (Dynamic Destination)
                ArrivalEstimationBox(
                  destination: destination,
                  // You can calculate an estimated arrival by adding
                  // a few hours to _selectedTime if you want to be fancy
                  arrivalTime: DateFormat('hh:mm a').format(
                    _selectedTime.add(const Duration(hours: 3)),
                  ),
                ),

                const SizedBox(height: 35),

                // 4. Primary Action Button
                Button(
                  onTap: () {
                    // Final sync before moving to next screen
                    _updateScheduleInBloc();
                    router.push(Paths.SETTRIPCAPACITY);
                  },
                  text: "Set Capacity",
                  showSuffixIcon: true,
                  suffixIcon: Icons.chevron_right,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
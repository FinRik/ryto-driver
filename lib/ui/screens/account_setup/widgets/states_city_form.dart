import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/enums/bottom_sheet_type.dart';
import '../../../../core/models/country/states_model.dart';
import '../../../../core/services/bottom_sheet_service.dart';
import '../../../blocs/country/country_bloc.dart';
import '../../../widgets/inputs/auth_text_field.dart';

class StateCityForm extends StatefulWidget {
  final TextEditingController stateController;
  final TextEditingController cityController;
  final String region;

  const StateCityForm({
    super.key,
    required this.stateController,
    required this.cityController,
    required this.region,
  });

  @override
  State<StateCityForm> createState() => _StateCityFormState();
}

class _StateCityFormState extends State<StateCityForm> {
  List<StateModel> _states = [];
  List<String> _cities = [];

  StateModel? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    context.read<CountryBloc>().add(FetchStates(country: widget.region));
  }

  @override
  void didUpdateWidget(covariant StateCityForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the region has actually changed
    if (widget.region != oldWidget.region) {
      // 1. Clear existing selections and data
      setState(() {
        _states = [];
        _cities = [];
        _selectedState = null;
        _selectedCity = null;
        widget.stateController.clear();
        widget.cityController.clear();
      });

      // 2. Trigger the new fetch for the updated region
      context.read<CountryBloc>().add(FetchStates(country: widget.region));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CountryBloc, CountryDataState>(
      listener: (context, state) {
        if (state is StatesSuccess) {
          setState(() => _states = state.states);
        } else if (state is CitiesSuccess) {
          setState(() => _cities = state.cities);
        }
      },
      child: Row(
        children: [
          // State Field
          Expanded(
            child: BlocBuilder<CountryBloc, CountryDataState>(
              builder: (context, state) {
                final isLoading = state is StateLoading;

                return AuthTextField(
                  controller: widget.stateController,
                  textInputType: TextInputType.text,
                  label: "State",
                  hint: "Select State",
                  readOnly: true,
                  suffixIcon: isLoading
                      ? Transform.scale(
                          scale: 0.4,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onPressed: _states.isEmpty
                              ? null
                              : () async {
                                  final selected =
                                      await sl<BottomSheetService>()
                                          .showCustomBottomSheet<
                                            List<StateModel>,
                                            StateModel
                                          >(
                                            variant:
                                                BottomSheetType.fetchStates,
                                            data: _states,
                                          );
                                  if (selected?.confirmed == true) {
                                    setState(() {
                                      _selectedState = selected?.data!;
                                      widget.stateController.text =
                                          selected?.data?.name ?? '';
                                      widget.cityController.clear();
                                      _cities.clear();
                                      _selectedCity = null;
                                    });

                                    context.read<CountryBloc>().add(
                                      FetchCities(
                                        country: widget.region,
                                        state: selected!.data!.name!,
                                      ),
                                    );
                                  }
                                },
                        ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? "State is required"
                      : null,
                );
              },
            ),
          ),

          const SizedBox(width: 21),

          // City Field
          Expanded(
            child: BlocBuilder<CountryBloc, CountryDataState>(
              builder: (context, state) {
                final isLoading = state is CitiesLoading;

                return AuthTextField(
                  controller: widget.cityController,
                  textInputType: TextInputType.text,
                  label: "City",
                  hint: "Select City",
                  readOnly: true,
                  suffixIcon: isLoading
                      ? Transform.scale(
                          scale: 0.4,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onPressed: _cities.isEmpty
                              ? null
                              : () async {
                                  final selected =
                                      await sl<BottomSheetService>()
                                          .showCustomBottomSheet<
                                            List<String>,
                                            String
                                          >(
                                            variant:
                                                BottomSheetType.fetchCities,
                                            data: _cities,
                                          );
                                  if (selected?.confirmed == true) {
                                    setState(() {
                                      _selectedCity = selected?.data;
                                      widget.cityController.text =
                                          selected!.data!;
                                    });
                                  }
                                },
                        ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? "City is required"
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Do NOT dispose controllers here! They are owned by parent.
    super.dispose();
  }
}

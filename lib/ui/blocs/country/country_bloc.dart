import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import '../../../core/models/country/states_model.dart';
import '../../../core/repos/country_repo.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryDataState> {
  final CountryRepo repo;

  CountryBloc(this.repo) : super(CountryDataInitial()) {
    on<FetchStates>(_onFetchStates);
    on<FetchCities>(_onFetchCities);
  }

  Future<void> _onFetchStates(
    FetchStates event,
    Emitter<CountryDataState> emit,
  ) async {
    emit(StateLoading());
    try {
      final states = await repo.fetchStates(country: event.country);
      emit(StatesSuccess(states ?? []));
    } catch (e) {
      emit(CountryDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchCities(
    FetchCities event,
    Emitter<CountryDataState> emit,
  ) async {
    emit(CitiesLoading());
    try {
      final cities = await repo.fetchCities(
        country: event.country,
        state: event.state,
      );
      emit(CitiesSuccess(cities ?? []));
    } catch (e) {
      emit(CountryDataFailure(e.toString()));
    }
  }
}

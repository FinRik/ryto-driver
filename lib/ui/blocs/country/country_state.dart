part of 'country_bloc.dart';

abstract class CountryDataState extends Equatable {
  const CountryDataState();

  @override
  List<Object?> get props => [];
}

class CountryDataInitial extends CountryDataState {}

class StateLoading extends CountryDataState {}

class CitiesLoading extends CountryDataState {}

class StatesSuccess extends CountryDataState {
  final List<StateModel> states;

  const StatesSuccess(this.states);

  @override
  List<Object?> get props => [states];
}

class CitiesSuccess extends CountryDataState {
  final List<String> cities;

  const CitiesSuccess(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CountryDataFailure extends CountryDataState {
  final String error;

  const CountryDataFailure(this.error);

  @override
  List<Object?> get props => [error];
}
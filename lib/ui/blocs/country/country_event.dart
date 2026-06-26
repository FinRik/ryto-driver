part of "country_bloc.dart";

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object?> get props => [];
}

class FetchStates extends CountryEvent {
  final String country;

  const FetchStates({required this.country});

  @override
  List<Object?> get props => [country];
}

class FetchCities extends CountryEvent {
  final String country;
  final String state;

  const FetchCities({required this.country, required this.state});

  @override
  List<Object?> get props => [country, state];
}
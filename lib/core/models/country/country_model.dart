// Model for a Country
import 'states_model.dart';

class CountryModel {
  final String? name;
  final String? iso3;
  final String? iso2;
  final List<StateModel>? states;
  // cities
  final String? country;
  final List<String>? cities;

  CountryModel({this.name, this.iso3, this.iso2, this.states, this.country, this.cities});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] as String?, // Safe
      iso3: json['iso3'] as String?, // Safe
      iso2: json['iso2'] as String?, // Safe
      states: json['states'] != null
          ? (json['states'] as List<dynamic>)
                .map(
                  (stateJson) =>
                      StateModel.fromJson(stateJson as Map<String, dynamic>),
                )
                .toList()
          : null, // or <StateModel>[] if you prefer empty list

      country: json['country'] as String?, // Safe
      cities: json['cities'] != null
          ? (json['cities'] as List<dynamic>)
                .map((cityJson) => cityJson as String)
                .toList()
          : null, // or <String>[] if you prefer empty list over null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iso3': iso3,
      'iso2': iso2,
      'states': states?.map((state) => state.toJson()).toList(),

      //cities
      'country': country,
      'cities': cities?.map((city) => city).toList()
    };
  }
}

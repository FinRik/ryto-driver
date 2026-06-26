import '../../app/app_setup_locator.dart';
import '../models/country/states_model.dart';
import '../services/g_api_service.dart';

abstract class CountryRepo {
  Future<List<String>?> fetchCities({
    required String country,
    required String state,
  });
  Future<List<StateModel>?> fetchStates({required String country});
}

class CountryRepoImpl implements CountryRepo {
  final GApiService _service;

  CountryRepoImpl({GApiService? service})
    : _service = service ?? sl<GApiService>();

  @override
  Future<List<String>?> fetchCities({
    required String country,
    required String state,
  }) async {
    final res = await _service.fetchCities(country: country, state: state);
    return res;
  }

  @override
  Future<List<StateModel>?> fetchStates({required String country}) async {
    final res = await _service.fetchStates(country: country);
    return res ?? [];
  }
}

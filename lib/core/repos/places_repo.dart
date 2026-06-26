import '../../app/app_setup_locator.dart';
import '../models/lat_lng.dart';
import '../models/places_autocomplete.dart';
import '../services/g_api_service.dart';

abstract class PlacesRepo {
  Future<List<Prediction>?> getSuggestions(String input, {String? country});
  Future<LatLng?> getLatLngFromPlaceId(String placeId, String address);
}

class PlacesRepoImpl implements PlacesRepo {
  final GApiService _service;

  PlacesRepoImpl({GApiService? service})
    : _service = service ?? sl<GApiService>();

  @override
  Future<List<Prediction>?> getSuggestions(
    String input, {
    String? country = 'ng',
  }) async {
    final res = await _service.getSuggestions(input, country!);
    return res;
  }

  @override
  Future<LatLng?> getLatLngFromPlaceId(String placeId, String address) async {
    final res = await _service.getLatLngFromPlaceId(placeId, address);
    return res;
  }
}

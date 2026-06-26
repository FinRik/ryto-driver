import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../app/api_urls.dart';
import '../models/bank/bank.dart';
import '../models/bank/banks_response.dart';
import '../models/bank/verify_user_account.dart';
import '../models/country/country_api_response.dart';
import '../models/country/country_model.dart';
import '../models/country/states_model.dart';
import '../models/lat_lng.dart';
import '../models/places_autocomplete.dart';

abstract class GApiService {
  Future<List<String>?> fetchCities({
    required String country,
    required String state,
  });
  Future<List<StateModel>?> fetchStates({required String country});
  Future<List<Bank>?> fetchBanks({required String country});
  Future<BankAccountData?> validateUserAccount({
    required String accountNumber,
    required String code,
  });
  Future<List<Prediction>?> getSuggestions(String input, String country);
  Future<LatLng> getLatLngFromPlaceId(String placeId, String address);
}

class GApiServiceImpl implements GApiService {
  final Dio _dio;

  GApiServiceImpl(Dio dio) : _dio = dio;

  @override
  Future<List<String>?> fetchCities({
    required String country,
    required String state,
  }) async {
    final responseData = await _dio.fetch(
      RequestOptions(
        method: "GET",
        baseUrl: ApiUrls.countryBaseUrl,
        path: ApiUrls.cities,
        extra: {'isPublic': true},
        data: {"country": country, "state": state},
      ),
    );
    final result = CountryApiResponse<List<CountryModel>>.fromJson(
      responseData.data as Map<String, dynamic>,
      (json) => (responseData.data['data'] as List)
          .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    if (result.error == true || result.data == null) {
      print("API Error: ${result.msg}");
      return null;
    }

    final List<CountryModel> countryList = result.data ?? [];

    print("Countries List: ${countryList.length} countries loaded");

    if (countryList.isEmpty) {
      return [];
    }

    final List<String> cities =
        countryList
            .firstWhere(
              (countryModel) =>
                  countryModel.country?.toLowerCase() == country.toLowerCase(),
              orElse: () => CountryModel(),
            )
            .cities ??
        []; // ← Change this only if you added 'cities' to CountryModel

    print("Extracted ${cities.length} cities for $country");

    if (cities.isNotEmpty) {
      print("First city: ${cities.first}");
    }

    return cities;
  }

  @override
  Future<List<StateModel>?> fetchStates({required String country}) async {
    try {
      final responseData = await _dio.fetch(
        RequestOptions(
          method: "GET",
          baseUrl: ApiUrls.countryBaseUrl,
          path: ApiUrls.states,
          extra: {'isPublic': true},
          data: {"country": country.toLowerCase()},
        ),
      );

      final result = CountryApiResponse<List<CountryModel>>.fromJson(
        responseData.data as Map<String, dynamic>,
        (json) => (responseData.data['data'] as List)
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (result.error == true || result.data == null) {
        print("API Error: ${result.msg}");
        return null;
      }

      final List<CountryModel> countriesList = result.data ?? [];

      print("Countries List: ${countriesList.length} countries loaded");

      if (countriesList.isEmpty) {
        return [];
      }

      final List<StateModel> states =
          countriesList
              .firstWhere(
                (countryModel) =>
                    countryModel.name?.toLowerCase() == (country).toLowerCase(),
                orElse: () => CountryModel(), // fallback empty model
              )
              .states ??
          [];

      print(
        "Extracted ${states.length} states for ${countriesList.first.name}",
      );

      return states;
    } catch (e) {
      print("Exception while fetching states: $e");
      return null;
    }
  }

  @override
  Future<List<Bank>?> fetchBanks({required String country}) async {
    try {
      final response = await _dio.get(
        ApiUrls.paystackBaseUrl + ApiUrls.fetchNGBanks,
        queryParameters: {"country": country.toLowerCase()},
        //TODO: inject header via interceptor
        options: Options(
          headers: {
            "Authorization": "Bearer ${dotenv.env['PAYSTACK_LIVE_SECRET_KEY']}",
          },
          extra: {'isPublic': true},
        ),
      );

      final result = BanksResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (result.status == false) {
        print("API Error fetching banks: ${result.message}");
        return null;
      }

      final banks = result.data ?? [];
      print("Loaded ${banks.length} banks for country: $country");
      return banks;
    } catch (e, stack) {
      print("Exception while fetching banks: $e\n$stack");
      return null;
    }
  }

  @override
  Future<BankAccountData?> validateUserAccount({
    required String accountNumber,
    required String code,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrls.paystackBaseUrl + ApiUrls.validateNGBank,
        queryParameters: {"account_number": accountNumber, "bank_code": code},
        //TODO: inject header via interceptor
        options: Options(
          headers: {
            "Authorization": "Bearer ${dotenv.env['PAYSTACK_LIVE_SECRET_KEY']}",
          },
          extra: {'isPublic': true},
        ),
      );

      final result = VerifyUserAccount.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (!result.status) {
        print("API Error validating account: ${result.message}");
        return null;
      }

      if (result.data == null) {
        print("No account data returned");
        return null;
      }

      return result.data;
    } catch (e, stack) {
      print("Exception while validating account: $e\n$stack");
      return null;
    }
  }

  @override
  Future<List<Prediction>?> getSuggestions(
    String input,
    String? country,
  ) async {
    if (input.isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiUrls.locationUrl,
        queryParameters: {
          'input': input,
          'components': country != null ? 'country:$country' : null,
          'key': dotenv.env['LOCATION_PREDICTION_KEY'],
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final placesResponse = PlacesAutocomplete.fromJson(data);

        switch (placesResponse.status) {
          case 'OK':
            return placesResponse.predictions;

          case 'ZERO_RESULTS':
            return [];

          default:
            throw Exception('Places API error: ${placesResponse.status}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  @override
  Future<LatLng> getLatLngFromPlaceId(String placeId, String address) async {
    if (placeId.isEmpty) {
      throw Exception('Place ID cannot be empty');
    }

    try {
      final response = await _dio.get(
        ApiUrls.placeDetailsUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': dotenv.env['LOCATION_PREDICTION_KEY'],
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];

          return LatLng(
            lat: (location['lat'] as num).toDouble(),
            lng: (location['lng'] as num).toDouble(),
            address: address,
          );
        } else if (data['status'] == 'ZERO_RESULTS') {
          throw Exception('No location found for this place_id');
        } else {
          throw Exception('Places API error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch lat/lng: $e');
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app/api_urls.dart';
import '../config/custom_dio_exception.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/kyc_response.dart';
import '../models/auth/us_kyc_preflight.dart';
import '../models/auth/us_kyc_verification.dart';
import '../models/bank/payout_bank.dart';
import '../models/trip/trip_cost_request.dart';
import '../models/bookings/booking_summary.dart';
import '../models/trip/safety_pin_request.dart';
import '../models/trip/trip_cost_summary.dart';
import '../models/trip/trip_response.dart';
import '../models/trip/trip_summary.dart';
import '../models/user/profile_request.dart';
import '../models/base.dart';
import '../models/preference.dart';
import '../models/trip/create_trip_request.dart';
import '../models/trip/trip.dart';
import '../models/user/user_entity.dart';
import '../models/vehicle_setup/vehicle_detail.dart';
import '../models/vehicle_setup/vehicle_setup_request.dart';
import '../models/wallet/transaction_summary.dart';
import '../models/wallet/wallet_summary.dart';
import '../models/wallet/withdrawal_response.dart';

part 'api_service.g.dart';

class ErrorAdapter<T> extends CallAdapter<Future<T>, Future<T>> {
  @override
  Future<T> adapt(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      // Transform raw DioException into your Custom version
      throw CustomDioException.fromDioException(e);
    } catch (e) {
      rethrow;
    }
  }
}

@RestApi(baseUrl: ApiUrls.baseUrl, callAdapter: ErrorAdapter)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST(ApiUrls.login)
  @Extra({'isPublic': true})
  Future<BaseModel> login(@Field("phone") String phone);

  @POST(ApiUrls.register)
  @Extra({'isPublic': true})
  Future<BaseModel<AuthResponse>> register(@Field("phone") String phone);

  @POST(ApiUrls.verifyLogin)
  Future<BaseModel<AuthResponse>> verifyLogin(
    @Field("phone") String phone,
    @Field("code") String code,
  );

  @POST(ApiUrls.verifyOtp)
  // @Extra({'requiresAuthToken': true})
  Future<BaseModel<UserEntity>> verifyOtp(@Field("code") String code);

  @POST(ApiUrls.resendOtp)
  // @Extra({'requiresAuthToken': true})
  Future<BaseModel> resendOtp();

  @MultiPart()
  @POST(ApiUrls.updateProfilePic)
  // @Extra({'requiresAuthToken': true})
  Future<BaseModel> uploadProfilePicture(
    @Part(name: 'file', contentType: 'image/png') File image,
  );

  @PUT(ApiUrls.updateProfile)
  // @Extra({'requiresAuthToken': true})
  Future<BaseModel<ProfileRequest>> updateProfile(
    @Body() ProfileRequest request,
  );

  @PUT(ApiUrls.updateFCMToken)
  Future<BaseModel> updateFCMToken({
    @Field("token") required String token,
    @Field("platform") required String platform,
  });

  @DELETE(ApiUrls.deleteFCMToken)
  Future<BaseModel> deleteFCMToken({@Field("token") required String token});

  @GET(ApiUrls.fetchProfile)
  // @Extra({'requiresAuthToken': true})
  Future<BaseModel<UserEntity>> fetchProfile();

  //KYC Flow
  @GET(ApiUrls.usKycStatus)
  Future<BaseModel> fetchUSKycStatus();

  @POST(ApiUrls.ngKycStatus)
  Future<BaseModel> fetchNGKycStatus(
    @Field("userId") int userId,
    @Field("type") String type,
    @Field("status") String status,
  );

  // ng kyc flow
  @MultiPart()
  @POST(ApiUrls.verifyNin)
  Future<BaseModel<KycResponse>> verifyNin(
    @Part(name: 'identityType') String identityType,
    @Part(name: 'nin') String nin,
    @Part(name: 'selfie', contentType: 'image/png') File selfie,
    @Part(name: 'document', contentType: 'image/png') File document,
  );

  @MultiPart()
  @POST(ApiUrls.verifyLicense)
  Future<BaseModel<KycResponse>> verifyLicense(
    @Part(name: 'licenseNumber') String licenseNumber,
    @Part(name: 'expiryDate') String expiryDate,
    @Part(name: 'front', contentType: 'image/png') File front,
    @Part(name: 'back', contentType: 'image/png') File back,
  );

  // us kyc flow
  @MultiPart()
  @POST(ApiUrls.attemptUSKyc)
  Future<BaseModel<USKycPreflight>> attemptUSKyc(
    @Part(name: 'ssn') String ssn,
    @Part(name: 'dob') String dob,
    @Part(name: 'driverLicenseNumber') String driverLicenseNumber,
    @Part(name: 'driverLicenseState') String driverLicenseState,
    @Part(name: 'zipcode') String zipcode,
    @Part(name: 'licenseFront', contentType: 'image/png') File licenseFront,
    @Part(name: 'licenseBack', contentType: 'image/png') File licenseBack,
  );

  @MultiPart()
  @POST(ApiUrls.verifyUSKyc)
  Future<BaseModel<USKycVerification>> verifyUSKyc();

  // vehicle reg flow
  @POST(ApiUrls.addVehicleDetails)
  Future<BaseModel> addVehicleDetails(@Body() VehicleDetailsRequest request);

  @PUT(ApiUrls.addVehicleCapacity)
  Future<BaseModel> addVehicleCapacity(@Body() VehicleCapacityRequest request);

  @MultiPart()
  @POST(ApiUrls.addVehicleDocument)
  Future<BaseModel> addVehicleDocument(
    @Part(name: 'license', contentType: 'image/png') File license,
    @Part(name: 'roadworthiness', contentType: 'image/png') File roadworthiness,
    @Part(name: 'insurance', contentType: 'image/png') File insurance,
    @Part(name: 'photoFront', contentType: 'image/png') File photoFront,
    @Part(name: 'photoBack', contentType: 'image/png') File photoBack,
    @Part(name: 'photoSide', contentType: 'image/png') File photoSide,
    @Part(name: 'photoInterior', contentType: 'image/png') File photoInterior,
    @Part(name: 'photoOther', contentType: 'image/png') File photoOther,
  );

  @GET(ApiUrls.fetchVehicleDetails)
  Future<BaseModel<VehicleDetail>> fetchVehicleDetails();

  @GET(ApiUrls.fetchPreference)
  Future<BaseModel<Preferences>> fetchDriverPreference();

  @PUT(ApiUrls.setPreference)
  Future<BaseModel> setDriverPreference(
    @Field("idCheckRequired") bool idCheckRequired,
    @Field("packagesAllowed") bool packagesAllowed,
    @Field("smokingAllowed") bool smokingAllowed,
    @Field("musicAllowed") bool musicAllowed,
    @Field("petsAllowed") bool petsAllowed,
  );

  /// Payout flow
  @GET(ApiUrls.fetchPayout)
  Future<BaseModel<PayoutBank>> fetchDriverPayout();

  // ng payout
  @PUT(ApiUrls.setNGPayout)
  Future<BaseModel> setDriverPayout(
    @Field("bankCode") String bankCode,
    @Field("bankName") String bankName,
    @Field("accountNumber") String accountNumber,
  );

  // us payout
  @PUT(ApiUrls.setUSRecipient)
  Future<BaseModel> setUSRecipient(
    @Field("contactEmail") String contactEmail,
    @Field("displayName") String displayName,
    @Field("entityType") String entityType,
  );

  @PUT(ApiUrls.setUSPayout)
  Future<BaseModel> setUSPayout(
    @Field("accountNumber") String accountNumber,
    @Field("routingNumber") String routingNumber,
    @Field("country") String country,
  );

  ///Wallet flow
  @GET(ApiUrls.walletDetails)
  Future<BaseModel<WalletSummary>> fetchUserWallet();

  @GET(ApiUrls.transactions)
  Future<BaseModel<List<TransactionItem>>> fetchTransactions();

  @POST(ApiUrls.withdraw)
  Future<BaseModel<WithdrawalResponse>> requestWithdrawal(
    @Field("amount") double amount,
  );

  @POST(ApiUrls.tripCost)
  Future<BaseModel<TripCostSummary>> fetchBookingCost(
    @Body() TripCostRequest request,
  );

  @POST(ApiUrls.createTrip)
  Future<BaseModel> createTrip(@Body() CreateTripRequest request);

  //bookings
  @GET(ApiUrls.trips)
  Future<BaseModel<TripResponse>> fetchTrips(@Query("status") String status);

  @GET(ApiUrls.tripsCount)
  Future<BaseModel> fetchTripsCount(@Query("period") String period);

  @GET(ApiUrls.tripSummary)
  Future<BaseModel<TripSummary>> fetchTripSummary(@Path("id") String id);

  @GET(ApiUrls.tripBookingSummary)
  Future<BaseModel<List<BookingSummary>>> fetchTripBookings(
    @Path("tripId") String tripId, {
    @Query("bookingStatus") String? bookingStatus,
  });

  @POST(ApiUrls.acceptTripBooking)
  Future<BaseModel> approveTripBooking(
    @Path("tripId") int tripId,
    @Path("bookingId") int bookingId,
  );

  @POST(ApiUrls.declineTripBooking)
  Future<BaseModel> declineTripBooking(
    // @Path("tripId") int tripId,
    @Field("reason") String reason,
    @Field("bookingId") int bookingId,
  );

  @POST(ApiUrls.completeTrip)
  Future<BaseModel<Trip>> completeTrip(
    @Path("id") String id,
    @Field("tripFeeGross") int tripFeeGross,
  );

  @POST(ApiUrls.cancelTrip)
  Future<BaseModel> cancelTrip(@Path("id") String id);

  @POST(ApiUrls.verityPassengerPin)
  Future<BaseModel> verifyPassengerPin(
    @Path("id") String tripId,
    @Body() PinVerification request,
  );
  @POST(ApiUrls.verityPassengerPins)
  Future<BaseModel> verifyPassengerPins(
    @Path("id") String tripId,
    @Body() SafetyPinRequest request,
  );
}

//old decline trip logic
// Future<BaseModel<dynamic>> _declineTripBooking(
//     int tripId,
//     int bookingId,
//     ) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   final _headers = <String, dynamic>{};
//   const Map<String, dynamic>? _data = null;
//   final _options = _setStreamType<BaseModel<dynamic>>(
//     Options(method: 'POST', headers: _headers, extra: _extra)
//         .compose(
//       _dio.options,
//       '/driver/trips/${tripId}/bookings/${bookingId}/reject',
//       queryParameters: queryParameters,
//       data: _data,
//     )
//         .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
//   );
//   final _result = await _dio.fetch<Map<String, dynamic>>(_options);
//   late BaseModel<dynamic> _value;
//   try {
//     _value = BaseModel<dynamic>.fromJson(
//       _result.data!,
//           (json) => json as dynamic,
//     );
//   } on Object catch (e, s) {
//     errorLogger?.logError(e, s, _options, response: _result);
//     rethrow;
//   }
//   return _value;
// }
//
// @override
// Future<BaseModel<dynamic>> declineTripBooking(int tripId, int bookingId) {
//   return ErrorAdapter<BaseModel<dynamic>>().adapt(
//         () => _declineTripBooking(tripId, bookingId),
//   );
// }

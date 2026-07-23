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
    @Path("tripId") int tripId,
    @Path("bookingId") int bookingId,
  );
  @POST(ApiUrls.completeTrip)
  Future<BaseModel<Trip>> completeTrip(
    @Path("id") String id,
    @Field("tripFeeGross") int tripFeeGross,
  );
  @POST(ApiUrls.cancelTrip)
  Future<BaseModel> cancelTrip(@Path("id") String id);
  @POST(ApiUrls.verityPassengerPins)
  Future<BaseModel> verifyPassengerPins(
    @Path("id") String tripId,
    @Body() SafetyPinRequest request,
  );

  //chat
  // Future<BaseModel<List<Conversation>>> getConversations();
  // Future<BaseModel<List<ChatMessage>>> getMessageHistory(int conversationId);
  // Future<BaseModel> sendMessage(int conversationId, String content);

  // @PUT(ApiUrls.updatePassword)
  // Future<BaseModel> updatePassword(@Body() AuthRequest updatePassword);
  //
  // @POST(ApiUrls.forgetPassword)
  // Future<BaseModel> forgetPassword(@Field('email') String email);
  // @POST(ApiUrls.resetPassword)
  // Future<BaseModel> resetPassword(@Body() AuthRequest resetPassword);
  //
  // @PUT(ApiUrls.verifyBVN)
  // Future<BaseModel> verifyBVN(@Field("bvn") String bvn);
  // @PUT(ApiUrls.createTransactionPin)
  // Future<BaseModel> createTransactionPin(@Field("type") String type,
  //     @Field("pin_confirmation") String confirmation, @Field("pin") String pin);
  // @PUT(ApiUrls.createTransactionPin)
  // Future<BaseModel> updateTransactionPin(
  //     @Field("type") String type,
  //     @Field("password") String password,
  //     @Field("pin_confirmation") String confirmation,
  //     @Field("pin") String pin);
  // @POST(ApiUrls.verifyTransactionPin)
  // Future<BaseModel> verifyTransactionPin(@Field("pin") String pin);
  // @PUT(ApiUrls.deactivateTransactionPin)
  // Future<BaseModel> deactivateTransactionPin(
  //     @Field("password") String password);
  //
  // // banners / ads
  // @GET(ApiUrls.ads)
  // Future<BaseModel<List<AdEntity>>> fetchAds();
  //
  // //profile
  // @MultiPart()
  // @POST(ApiUrls.updateProfilePicture)
  // Future<BaseModel> uploadProfilePicture(@Part(name: "_method") String method,
  //     @Part(name: "picture") File picture);
  // @GET(ApiUrls.me)
  // Future<BaseModel<UserEntity>> me();
  // // services
  // @GET(ApiUrls.getAirtimeService)
  // Future<BaseModel<List<ServiceEntity>>> getAirtimeServices();
  // @POST(ApiUrls.buyAirtime)
  // Future<BaseModel<BillsResponse>> buyAirtime(@Body() BillsRequest request);
  //
  // @GET(ApiUrls.a2CashServices)
  // Future<BaseModel<List<ServiceEntity>>> getAirtime2CashServices();
  // @POST(ApiUrls.requestNumber)
  // Future<BaseModel> requestNumber(@Field("serviceID") String serviceID,
  //     @Field("sender_number") String phoneNumber);
  // @POST(ApiUrls.verifyNumber)
  // Future<BaseModel> verifyNumber(@Field("serviceID") String serviceID,
  //     @Field("identifier") String identifier, @Field("otp") String otp);
  // @POST(ApiUrls.sendAirtime)
  // Future<BaseModel<BillsResponse>> sendAirtime(
  //     @Field("serviceID") String serviceID,
  //     @Field("sender_number") int phoneNumber,
  //     @Field("amount") double amount,
  //     @Field("airtime_share_pin") String transferPin,
  //     @Field("sessionId") String sessionId);
  //
  // @GET(ApiUrls.getDataService)
  // Future<BaseModel<List<ServiceEntity>>> getDataServices();
  // @POST(ApiUrls.getDataType)
  // Future<BaseModel<List<ServiceTypeEntity>>> getDataType(
  //     @Field("serviceID") String serviceId);
  // @POST(ApiUrls.getDataPlan)
  // Future<BaseModel<List<ServicePlanEntity>>> getDataPlans(
  //     @Body() BillsRequest request);
  // @POST(ApiUrls.buyData)
  // Future<BaseModel<BillsResponse>> buyData(@Body() BillsRequest request);
  //
  // @GET(ApiUrls.getCableServices)
  // Future<BaseModel<List<ServiceEntity>>> getCableServices();
  // @POST(ApiUrls.getCablePlans)
  // Future<BaseModel<List<ServicePlanEntity>>> getCablePlan(
  //     @Field("serviceID") String serviceId);
  // @POST(ApiUrls.verifySmartcard)
  // Future<VerificationResponse> verifySmartCard(@Body() BillsRequest request);
  // @POST(ApiUrls.buyCable)
  // Future<BaseModel<BillsResponse>> buyCableSub(@Body() BillsRequest request);
  //
  // @GET(ApiUrls.getElectricity)
  // Future<BaseModel<List<ServiceEntity>>> getElectricityServices();
  // @POST(ApiUrls.verifyMeterNumber)
  // Future<VerificationResponse> verifyMeterNumber(@Body() BillsRequest request);
  // @POST(ApiUrls.buyElectricity)
  // Future<BaseModel<BillsResponse>> buyElectricity(@Body() BillsRequest request);
  //
  // @GET(ApiUrls.getEducationServices)
  // Future<BaseModel<List<ServiceEntity>>> getEducationServices();
  // @POST(ApiUrls.getEducationPlan)
  // Future<BaseModel<List<ServicePlanEntity>>> getEducationPlan(
  //     @Field("serviceID") String serviceId);
  // @POST(ApiUrls.verifyEducationProfile)
  // Future<VerificationResponse> verifyEducationProfile(
  //     @Body() BillsRequest request);
  // @POST(ApiUrls.buyEducation)
  // Future<BaseModel<BillsResponse>> buyEducation(@Body() BillsRequest request);
  // // wallet
  // @GET(ApiUrls.fetchBalance)
  // Future<BaseModel> fetchBalance();
  // @GET(ApiUrls.virtualWallets)
  // Future<BaseModel<List<VirtualAccount>>> fetchWallets();
  // @GET(ApiUrls.manualFunding)
  // Future<BaseModel<List<VirtualAccount>>> manualFunding();
  // @POST(ApiUrls.uploadPaymentProof)
  // Future<BaseModel> uploadPaymentProof(
  //     @Field("bank_id") String bankId,
  //     @Field("sender_name") String senderName,
  //     @Field("amount") double amount,
  //     @Field("date") String date,
  //     @Field("bank") String bank);
  // @POST(ApiUrls.atmFunding)
  // Future<BaseModel> atmFunding(@Field("amount") double amount);
  //
  // @GET(ApiUrls.transactions)
  // Future<BaseModel<List<TransactionEntity>>> fetchTransactions();
  // @GET(ApiUrls.getTransactionByRef)
  // Future<BaseModel<TransactionEntity>> fetchTransactionByReference(
  //     @Path("reference") String reference,
  //     );
  // @POST(ApiUrls.filterTransaction)
  // Future<BaseModel<List<TransactionEntity>>> filterTransactions(
  //     @Body() FilterModel model);
  // @GET(ApiUrls.transactionTypes)
  // Future<BaseModel<List<TransactionType>>> fetchTransactionTypes();
  // //transaction
  // @GET(ApiUrls.walletHistory)
  // Future<BaseModel<List<WalletHistoryEntity>>> fetchWalletHistory();
  // @POST(ApiUrls.filterWalletHistory)
  // Future<BaseModel<List<WalletHistoryEntity>>> filterWalletHistory(
  //     @Body() FilterModel model);
  // //referral
  // @GET(ApiUrls.referral)
  // Future<BaseModel<List<ReferralEntity>>> fetchReferrals();
  // @POST(ApiUrls.filterReferral)
  // Future<BaseModel<List<ReferralEntity>>> filterReferrals(
  //     @Field("startDate") DateTime startDate,
  //     @Field("endDate") DateTime endDate);
  //
  // //beneficiary
  // @GET(ApiUrls.fetchBeneficiaries)
  // Future<BaseModel<List<BeneficiaryEntity>>> fetchBeneficiaries();
  // @POST(ApiUrls.storeBeneficiary)
  // Future<BaseModel> storeBeneficiary(
  //   @Field("serviceID") String serviceId,
  //   @Field("number") int number,
  // );
  // @POST(ApiUrls.deleteBeneficiary)
  // Future<BaseModel> deleteBeneficiary(
  //   @Field("serviceID") String serviceId,
  //   @Path("id") String id,
  // );
  //
  // //push notification
  // @POST(ApiUrls.pushNotif)
  // Future<BaseModel> saveFcmToken(
  //   @Field("fcm_token") String fcmToken,
  //   @Field("status") String status,
  // );

  // upload-profile-picture
  //   @MultiPart()
  //   @POST('/upload-profile-picture')
  //   Future<BaseModel<Map<String, dynamic>>> uploadProfilePicture(
  //     @Part(name: 'image', contentType: 'image/png') File image,
  //   );
  //
  //   @POST('/update-location')
  //   Future<BaseModel<DynamicResponse>> updateLocation(
  //       @Part(name: "latitude") String lat, @Part(name: "longitude") String long);
  //
  //   @GET('/errand/categories')
  //   Future<BaseModel<List<Category>>> getCategories();
  //   @GET('/operational-states')
  //   Future<BaseModel<List<StateEntity>>> getStates();
}

// _data.fields.addAll(checkoutRequest
//     .toJson()
//     .entries
//     .where((entry) => entry.value != null)
//     .map((e) => MapEntry(e.key, e.value)));
//
// @override
// Future<BaseModel<CalcPrice>> calcPrice(CheckoutRequest calc) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   queryParameters.removeWhere((k, v) => v == null);
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.fields.addAll(calc
//       .toJson()
//       .entries
//       .where((entry) => entry.value != null)
//       .map((e) => MapEntry(e.key, e.value)));
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<CalcPrice>>(Options(
//     method: 'POST',
//     headers: _headers,
//     extra: _extra,
//   )
//           .compose(
//             _dio.options,
//             '/delivery/calculate-price',
//             queryParameters: queryParameters,
//             data: _data,
//           )
//           .copyWith(
//               baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<CalcPrice>.fromJson(
//     _result.data!,
//     (json) => CalcPrice.fromJson(json as Map<String, dynamic>),
//   );
//   return _value;
// }
//
// @override
// Future<BaseModel<Map<String, dynamic>>> checkout(
//   CheckoutRequest checkoutRequest,
//   List<File>? itemImages,
//   List<File>? itemImagesTwo,
// ) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   queryParameters.removeWhere((k, v) => v == null);
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.fields.addAll(checkoutRequest
//       .toJson()
//       .entries
//       .where((entry) => entry.value != null)
//       .map((e) => MapEntry(e.key, e.value)));
//   if (itemImages != null) {
//     _data.files.addAll(itemImages.map((i) => MapEntry(
//         'items[0][images][]',
//         MultipartFile.fromFileSync(
//           i.path,
//           filename: i.path.split(Platform.pathSeparator).last,
//         ))));
//   }
//   if (itemImagesTwo != null) {
//     _data.files.addAll(itemImagesTwo.map((i) => MapEntry(
//         'items[1][images][]',
//         MultipartFile.fromFileSync(
//           i.path,
//           filename: i.path.split(Platform.pathSeparator).last,
//         ))));
//   }
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<Map<String, dynamic>>>(Options(
//     method: 'POST',
//     headers: _headers,
//     extra: _extra,
//     contentType: 'multipart/form-data',
//   )
//           .compose(
//             _dio.options,
//             '/delivery/checkout',
//             queryParameters: queryParameters,
//             data: _data,
//           )
//           .copyWith(
//               baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<Map<String, dynamic>>.fromJson(
//     _result.data!,
//     (json) => (json as Map<String, dynamic>),
//   );
//   return _value;
// }
// @override
// Future<BaseModel<Map<String, dynamic>>> uploadProfilePicture(
//     File image) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.files.add(MapEntry(
//     'image',
//     MultipartFile.fromFileSync(
//       image.path,
//       filename: image.path.split(Platform.pathSeparator).last,
//       contentType: DioMediaType.parse('image/png'),
//     ),
//   ));
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<Map<String, dynamic>>>(Options(
//         method: 'POST',
//         headers: _headers,
//         extra: _extra,
//         contentType: 'multipart/form-data',
//       )
//           .compose(
//         _dio.options,
//         '/upload-profile-picture',
//         queryParameters: queryParameters,
//         data: _data,
//       )
//           .copyWith(
//           baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<Map<String, dynamic>>.fromJson(
//     _result.data!,
//         (json) => json as Map<String, dynamic>,
//   );
//   return _value;
// }

// @override
// Future<BaseModel<DynamicResponse>> uploadProof(
//     List<MultipartFile> files,
//     String errandId,
//     ) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.files.addAll(files.map((i) => MapEntry('proof[]', i)));
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<DynamicResponse>>(Options(
//         method: 'POST',
//         headers: _headers,
//         extra: _extra,
//         contentType: 'multipart/form-data',
//       )
//           .compose(
//         _dio.options,
//         '/errand/${errandId}/upload-proof',
//         queryParameters: queryParameters,
//         data: _data,
//       )
//           .copyWith(
//           baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<DynamicResponse>.fromJson(
//     _result.data!,
//         (json) => DynamicResponse.fromJson(json as Map<String, dynamic>),
//   );
//   return _value;
// }

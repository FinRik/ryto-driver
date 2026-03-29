// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://api.getryto.com';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  Future<BaseModel<dynamic>> _login(String phone) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phone};
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/login/phone',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> login(String phone) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _login(phone));
  }

  Future<BaseModel<AuthResponse>> _register(String phone) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phone};
    final _options = _setStreamType<BaseModel<AuthResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/signup/phone',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<AuthResponse> _value;
    try {
      _value = BaseModel<AuthResponse>.fromJson(
        _result.data!,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<AuthResponse>> register(String phone) {
    return ErrorAdapter<BaseModel<AuthResponse>>().adapt(
      () => _register(phone),
    );
  }

  Future<BaseModel<VerifiedPhoneResponse>> _verifyOtp(String code) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code};
    final _options = _setStreamType<BaseModel<VerifiedPhoneResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/verify/phone',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<VerifiedPhoneResponse> _value;
    try {
      _value = BaseModel<VerifiedPhoneResponse>.fromJson(
        _result.data!,
        (json) => VerifiedPhoneResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<VerifiedPhoneResponse>> verifyOtp(String code) {
    return ErrorAdapter<BaseModel<VerifiedPhoneResponse>>().adapt(
      () => _verifyOtp(code),
    );
  }

  Future<BaseModel<dynamic>> _resendOtp() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/resend-phone-verification',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> resendOtp() {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _resendOtp());
  }

  Future<BaseModel<dynamic>> _uploadProfilePicture(File image) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'file',
        MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'auth/driver/profile-picture',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> uploadProfilePicture(File image) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _uploadProfilePicture(image),
    );
  }

  Future<BaseModel<DriverProfileRequest>> _updateProfile(
    DriverProfileRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<DriverProfileRequest>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/complete-profile',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<DriverProfileRequest> _value;
    try {
      _value = BaseModel<DriverProfileRequest>.fromJson(
        _result.data!,
        (json) => DriverProfileRequest.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<DriverProfileRequest>> updateProfile(
    DriverProfileRequest request,
  ) {
    return ErrorAdapter<BaseModel<DriverProfileRequest>>().adapt(
      () => _updateProfile(request),
    );
  }

  Future<BaseModel<dynamic>> _verifyNin(
    String identityType,
    String nin,
    File selfie,
    File document,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('identityType', identityType));
    _data.fields.add(MapEntry('nin', nin));
    _data.files.add(
      MapEntry(
        'selfie',
        MultipartFile.fromFileSync(
          selfie.path,
          filename: selfie.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'document',
        MultipartFile.fromFileSync(
          document.path,
          filename: document.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/kyc/driver/identity',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> verifyNin(
    String identityType,
    String nin,
    File selfie,
    File document,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _verifyNin(identityType, nin, selfie, document),
    );
  }

  Future<BaseModel<dynamic>> _verifyLicense(
    String licenseNumber,
    String expiryDate,
    File front,
    File back,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('licenseNumber', licenseNumber));
    _data.fields.add(MapEntry('expiryDate', expiryDate));
    _data.files.add(
      MapEntry(
        'front',
        MultipartFile.fromFileSync(
          front.path,
          filename: front.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'back',
        MultipartFile.fromFileSync(
          back.path,
          filename: back.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/kyc/driver/license',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> verifyLicense(
    String licenseNumber,
    String expiryDate,
    File front,
    File back,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _verifyLicense(licenseNumber, expiryDate, front, back),
    );
  }

  Future<BaseModel<KycResponse>> _fetchVerificationStatus() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<KycResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/kyc/driver/status',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<KycResponse> _value;
    try {
      _value = BaseModel<KycResponse>.fromJson(
        _result.data!,
        (json) => KycResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<KycResponse>> fetchVerificationStatus() {
    return ErrorAdapter<BaseModel<KycResponse>>().adapt(
      () => _fetchVerificationStatus(),
    );
  }

  Future<BaseModel<dynamic>> _addVehicleDetails(
    VehicleDetailsRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/vehicle/driver/details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> addVehicleDetails(VehicleDetailsRequest request) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _addVehicleDetails(request),
    );
  }

  Future<BaseModel<dynamic>> _addVehicleCapacity(
    VehicleCapacityRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/vehicle/driver/capacity',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> addVehicleCapacity(
    VehicleCapacityRequest request,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _addVehicleCapacity(request),
    );
  }

  Future<BaseModel<dynamic>> _addVehicleDocument(
    File license,
    File roadworthiness,
    File insurance,
    File photoFront,
    File photoBack,
    File photoSide,
    File photoInterior,
    File photoOther,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'license',
        MultipartFile.fromFileSync(
          license.path,
          filename: license.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'roadworthiness',
        MultipartFile.fromFileSync(
          roadworthiness.path,
          filename: roadworthiness.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'insurance',
        MultipartFile.fromFileSync(
          insurance.path,
          filename: insurance.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'photoFront',
        MultipartFile.fromFileSync(
          photoFront.path,
          filename: photoFront.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'photoBack',
        MultipartFile.fromFileSync(
          photoBack.path,
          filename: photoBack.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'photoSide',
        MultipartFile.fromFileSync(
          photoSide.path,
          filename: photoSide.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'photoInterior',
        MultipartFile.fromFileSync(
          photoInterior.path,
          filename: photoInterior.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'photoOther',
        MultipartFile.fromFileSync(
          photoOther.path,
          filename: photoOther.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/vehicle/driver/docs-and-photos',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> addVehicleDocument(
    File license,
    File roadworthiness,
    File insurance,
    File photoFront,
    File photoBack,
    File photoSide,
    File photoInterior,
    File photoOther,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _addVehicleDocument(
        license,
        roadworthiness,
        insurance,
        photoFront,
        photoBack,
        photoSide,
        photoInterior,
        photoOther,
      ),
    );
  }

  Future<BaseModel<VehicleDetailsResponse>> _fetchVehicleDetails() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<VehicleDetailsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/vehicle/driver/me',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<VehicleDetailsResponse> _value;
    try {
      _value = BaseModel<VehicleDetailsResponse>.fromJson(
        _result.data!,
        (json) => VehicleDetailsResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<VehicleDetailsResponse>> fetchVehicleDetails() {
    return ErrorAdapter<BaseModel<VehicleDetailsResponse>>().adapt(
      () => _fetchVehicleDetails(),
    );
  }

  Future<BaseModel<PreferenceSetup>> _fetchDriverPreference() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<PreferenceSetup>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trip/preferences',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<PreferenceSetup> _value;
    try {
      _value = BaseModel<PreferenceSetup>.fromJson(
        _result.data!,
        (json) => PreferenceSetup.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<PreferenceSetup>> fetchDriverPreference() {
    return ErrorAdapter<BaseModel<PreferenceSetup>>().adapt(
      () => _fetchDriverPreference(),
    );
  }

  Future<BaseModel<dynamic>> _setDriverPreference(
    bool idCheckRequired,
    bool packagesAllowed,
    bool smokingAllowed,
    bool musicAllowed,
    bool petsAllowed,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'idCheckRequired': idCheckRequired,
      'packagesAllowed': packagesAllowed,
      'smokingAllowed': smokingAllowed,
      'musicAllowed': musicAllowed,
      'petsAllowed': petsAllowed,
    };
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trip/preferences',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> setDriverPreference(
    bool idCheckRequired,
    bool packagesAllowed,
    bool smokingAllowed,
    bool musicAllowed,
    bool petsAllowed,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _setDriverPreference(
        idCheckRequired,
        packagesAllowed,
        smokingAllowed,
        musicAllowed,
        petsAllowed,
      ),
    );
  }

  Future<BaseModel<dynamic>> _fetchDriverPayout() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/payout-method',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> fetchDriverPayout() {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _fetchDriverPayout());
  }

  Future<BaseModel<dynamic>> _setDriverPayout(
    String bankCode,
    String bankName,
    String accountNumber,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'bankCode': bankCode,
      'bankName': bankName,
      'accountNumber': accountNumber,
    };
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/payout-method',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> setDriverPayout(
    String bankCode,
    String bankName,
    String accountNumber,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _setDriverPayout(bankCode, bankName, accountNumber),
    );
  }

  Future<BaseModel<WalletSummary>> _fetchUserWallet() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<WalletSummary>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/wallet/summary',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<WalletSummary> _value;
    try {
      _value = BaseModel<WalletSummary>.fromJson(
        _result.data!,
        (json) => WalletSummary.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<WalletSummary>> fetchUserWallet() {
    return ErrorAdapter<BaseModel<WalletSummary>>().adapt(
      () => _fetchUserWallet(),
    );
  }

  Future<BaseModel<TransactionSummary>> _fetchTransactions() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<TransactionSummary>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/wallet/transactions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<TransactionSummary> _value;
    try {
      _value = BaseModel<TransactionSummary>.fromJson(
        _result.data!,
        (json) => TransactionSummary.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<TransactionSummary>> fetchTransactions() {
    return ErrorAdapter<BaseModel<TransactionSummary>>().adapt(
      () => _fetchTransactions(),
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on

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
    final _extra = <String, dynamic>{'isPublic': true};
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
    final _extra = <String, dynamic>{'isPublic': true};
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

  Future<BaseModel<AuthResponse>> _verifyLogin(
    String phone,
    String code,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phone, 'code': code};
    final _options = _setStreamType<BaseModel<AuthResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/verify-login',
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
  Future<BaseModel<AuthResponse>> verifyLogin(String phone, String code) {
    return ErrorAdapter<BaseModel<AuthResponse>>().adapt(
      () => _verifyLogin(phone, code),
    );
  }

  Future<BaseModel<UserEntity>> _verifyOtp(String code) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code};
    final _options = _setStreamType<BaseModel<UserEntity>>(
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
    late BaseModel<UserEntity> _value;
    try {
      _value = BaseModel<UserEntity>.fromJson(
        _result.data!,
        (json) => UserEntity.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<UserEntity>> verifyOtp(String code) {
    return ErrorAdapter<BaseModel<UserEntity>>().adapt(() => _verifyOtp(code));
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
            '/auth/driver/profile-picture',
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

  Future<BaseModel<ProfileRequest>> _updateProfile(
    ProfileRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<ProfileRequest>>(
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
    late BaseModel<ProfileRequest> _value;
    try {
      _value = BaseModel<ProfileRequest>.fromJson(
        _result.data!,
        (json) => ProfileRequest.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<ProfileRequest>> updateProfile(ProfileRequest request) {
    return ErrorAdapter<BaseModel<ProfileRequest>>().adapt(
      () => _updateProfile(request),
    );
  }

  Future<BaseModel<UserEntity>> _fetchProfile() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<UserEntity>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/driver/user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<UserEntity> _value;
    try {
      _value = BaseModel<UserEntity>.fromJson(
        _result.data!,
        (json) => UserEntity.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<UserEntity>> fetchProfile() {
    return ErrorAdapter<BaseModel<UserEntity>>().adapt(() => _fetchProfile());
  }

  Future<BaseModel<dynamic>> _fetchUSKycStatus() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
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
  Future<BaseModel<dynamic>> fetchUSKycStatus() {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _fetchUSKycStatus());
  }

  Future<BaseModel<dynamic>> _fetchNGKycStatus(
    int userId,
    String type,
    String status,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'userId': userId, 'type': type, 'status': status};
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/kyc/driver/webhook',
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
  Future<BaseModel<dynamic>> fetchNGKycStatus(
    int userId,
    String type,
    String status,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _fetchNGKycStatus(userId, type, status),
    );
  }

  Future<BaseModel<KycResponse>> _verifyNin(
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
    final _options = _setStreamType<BaseModel<KycResponse>>(
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
  Future<BaseModel<KycResponse>> verifyNin(
    String identityType,
    String nin,
    File selfie,
    File document,
  ) {
    return ErrorAdapter<BaseModel<KycResponse>>().adapt(
      () => _verifyNin(identityType, nin, selfie, document),
    );
  }

  Future<BaseModel<KycResponse>> _verifyLicense(
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
    final _options = _setStreamType<BaseModel<KycResponse>>(
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
  Future<BaseModel<KycResponse>> verifyLicense(
    String licenseNumber,
    String expiryDate,
    File front,
    File back,
  ) {
    return ErrorAdapter<BaseModel<KycResponse>>().adapt(
      () => _verifyLicense(licenseNumber, expiryDate, front, back),
    );
  }

  Future<BaseModel<USKycPreflight>> _attemptUSKyc(
    String ssn,
    String dob,
    String driverLicenseNumber,
    String driverLicenseState,
    String zipcode,
    File licenseFront,
    File licenseBack,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('ssn', ssn));
    _data.fields.add(MapEntry('dob', dob));
    _data.fields.add(MapEntry('driverLicenseNumber', driverLicenseNumber));
    _data.fields.add(MapEntry('driverLicenseState', driverLicenseState));
    _data.fields.add(MapEntry('zipcode', zipcode));
    _data.files.add(
      MapEntry(
        'licenseFront',
        MultipartFile.fromFileSync(
          licenseFront.path,
          filename: licenseFront.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    _data.files.add(
      MapEntry(
        'licenseBack',
        MultipartFile.fromFileSync(
          licenseBack.path,
          filename: licenseBack.path.split(Platform.pathSeparator).last,
          contentType: DioMediaType.parse('image/png'),
        ),
      ),
    );
    final _options = _setStreamType<BaseModel<USKycPreflight>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/kyc/driver/us/preflight',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<USKycPreflight> _value;
    try {
      _value = BaseModel<USKycPreflight>.fromJson(
        _result.data!,
        (json) => USKycPreflight.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<USKycPreflight>> attemptUSKyc(
    String ssn,
    String dob,
    String driverLicenseNumber,
    String driverLicenseState,
    String zipcode,
    File licenseFront,
    File licenseBack,
  ) {
    return ErrorAdapter<BaseModel<USKycPreflight>>().adapt(
      () => _attemptUSKyc(
        ssn,
        dob,
        driverLicenseNumber,
        driverLicenseState,
        zipcode,
        licenseFront,
        licenseBack,
      ),
    );
  }

  Future<BaseModel<USKycVerification>> _verifyUSKyc() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<USKycVerification>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/kyc/driver/us/verification-session/native',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<USKycVerification> _value;
    try {
      _value = BaseModel<USKycVerification>.fromJson(
        _result.data!,
        (json) => USKycVerification.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<USKycVerification>> verifyUSKyc() {
    return ErrorAdapter<BaseModel<USKycVerification>>().adapt(
      () => _verifyUSKyc(),
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

  Future<BaseModel<VehicleDetail>> _fetchVehicleDetails() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<VehicleDetail>>(
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
    late BaseModel<VehicleDetail> _value;
    try {
      _value = BaseModel<VehicleDetail>.fromJson(
        _result.data!,
        (json) => VehicleDetail.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<VehicleDetail>> fetchVehicleDetails() {
    return ErrorAdapter<BaseModel<VehicleDetail>>().adapt(
      () => _fetchVehicleDetails(),
    );
  }

  Future<BaseModel<Preferences>> _fetchDriverPreference() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<Preferences>>(
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
    late BaseModel<Preferences> _value;
    try {
      _value = BaseModel<Preferences>.fromJson(
        _result.data!,
        (json) => Preferences.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<Preferences>> fetchDriverPreference() {
    return ErrorAdapter<BaseModel<Preferences>>().adapt(
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
      Options(method: 'PUT', headers: _headers, extra: _extra)
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

  Future<BaseModel<PayoutBank>> _fetchDriverPayout() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<PayoutBank>>(
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
    late BaseModel<PayoutBank> _value;
    try {
      _value = BaseModel<PayoutBank>.fromJson(
        _result.data!,
        (json) => PayoutBank.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<PayoutBank>> fetchDriverPayout() {
    return ErrorAdapter<BaseModel<PayoutBank>>().adapt(
      () => _fetchDriverPayout(),
    );
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
      Options(method: 'PUT', headers: _headers, extra: _extra)
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

  Future<BaseModel<dynamic>> _setUSRecipient(
    String contactEmail,
    String displayName,
    String entityType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'contactEmail': contactEmail,
      'displayName': displayName,
      'entityType': entityType,
    };
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/payout-method/us/recipient',
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
  Future<BaseModel<dynamic>> setUSRecipient(
    String contactEmail,
    String displayName,
    String entityType,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _setUSRecipient(contactEmail, displayName, entityType),
    );
  }

  Future<BaseModel<dynamic>> _setUSPayout(
    String accountNumber,
    String routingNumber,
    String country,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'accountNumber': accountNumber,
      'routingNumber': routingNumber,
      'country': country,
    };
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/payout-method/us/bank',
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
  Future<BaseModel<dynamic>> setUSPayout(
    String accountNumber,
    String routingNumber,
    String country,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _setUSPayout(accountNumber, routingNumber, country),
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

  Future<BaseModel<List<TransactionItem>>> _fetchTransactions() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<List<TransactionItem>>>(
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
    late BaseModel<List<TransactionItem>> _value;
    try {
      _value = BaseModel<List<TransactionItem>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<TransactionItem>(
                    (i) => TransactionItem.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<List<TransactionItem>>> fetchTransactions() {
    return ErrorAdapter<BaseModel<List<TransactionItem>>>().adapt(
      () => _fetchTransactions(),
    );
  }

  Future<BaseModel<WithdrawalResponse>> _requestWithdrawal(
    double amount,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'amount': amount};
    final _options = _setStreamType<BaseModel<WithdrawalResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/payout/request',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<WithdrawalResponse> _value;
    try {
      _value = BaseModel<WithdrawalResponse>.fromJson(
        _result.data!,
        (json) => WithdrawalResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<WithdrawalResponse>> requestWithdrawal(double amount) {
    return ErrorAdapter<BaseModel<WithdrawalResponse>>().adapt(
      () => _requestWithdrawal(amount),
    );
  }

  Future<BaseModel<TripCostSummary>> _fetchBookingCost(
    TripCostRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<TripCostSummary>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/booking/summary',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<TripCostSummary> _value;
    try {
      _value = BaseModel<TripCostSummary>.fromJson(
        _result.data!,
        (json) => TripCostSummary.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<TripCostSummary>> fetchBookingCost(TripCostRequest request) {
    return ErrorAdapter<BaseModel<TripCostSummary>>().adapt(
      () => _fetchBookingCost(request),
    );
  }

  Future<BaseModel<dynamic>> _createTrip(CreateTripRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips',
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
  Future<BaseModel<dynamic>> createTrip(CreateTripRequest request) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _createTrip(request));
  }

  Future<BaseModel<TripResponse>> _fetchTrips(String status) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'status': status};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<TripResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<TripResponse> _value;
    try {
      _value = BaseModel<TripResponse>.fromJson(
        _result.data!,
        (json) => TripResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<TripResponse>> fetchTrips(String status) {
    return ErrorAdapter<BaseModel<TripResponse>>().adapt(
      () => _fetchTrips(status),
    );
  }

  Future<BaseModel<dynamic>> _fetchTripsCount(String period) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'period': period};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/stats/completed-count',
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
  Future<BaseModel<dynamic>> fetchTripsCount(String period) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _fetchTripsCount(period),
    );
  }

  Future<BaseModel<TripSummary>> _fetchTripSummary(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<TripSummary>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/${id}/summary',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<TripSummary> _value;
    try {
      _value = BaseModel<TripSummary>.fromJson(
        _result.data!,
        (json) => TripSummary.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<TripSummary>> fetchTripSummary(String id) {
    return ErrorAdapter<BaseModel<TripSummary>>().adapt(
      () => _fetchTripSummary(id),
    );
  }

  Future<BaseModel<List<BookingSummary>>> _fetchTripBookings(
    String tripId, {
    String? bookingStatus,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'bookingStatus': bookingStatus};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<List<BookingSummary>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/${tripId}/bookings',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<List<BookingSummary>> _value;
    try {
      _value = BaseModel<List<BookingSummary>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<BookingSummary>(
                    (i) => BookingSummary.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<List<BookingSummary>>> fetchTripBookings(
    String tripId, {
    String? bookingStatus,
  }) {
    return ErrorAdapter<BaseModel<List<BookingSummary>>>().adapt(
      () => _fetchTripBookings(tripId, bookingStatus: bookingStatus),
    );
  }

  Future<BaseModel<dynamic>> _approveTripBooking(
    int tripId,
    int bookingId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/${tripId}/bookings/${bookingId}/accept',
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
  Future<BaseModel<dynamic>> approveTripBooking(int tripId, int bookingId) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _approveTripBooking(tripId, bookingId),
    );
  }

  Future<BaseModel<dynamic>> _declineTripBooking(
    int tripId,
    int bookingId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/${tripId}/bookings/${bookingId}/reject',
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
  Future<BaseModel<dynamic>> declineTripBooking(int tripId, int bookingId) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _declineTripBooking(tripId, bookingId),
    );
  }

  Future<BaseModel<Trip>> _completeTrip(String id, int tripFeeGross) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'tripFeeGross': tripFeeGross};
    final _options = _setStreamType<BaseModel<Trip>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/${id}/complete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<Trip> _value;
    try {
      _value = BaseModel<Trip>.fromJson(
        _result.data!,
        (json) => Trip.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<Trip>> completeTrip(String id, int tripFeeGross) {
    return ErrorAdapter<BaseModel<Trip>>().adapt(
      () => _completeTrip(id, tripFeeGross),
    );
  }

  Future<BaseModel<dynamic>> _cancelTrip(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/driver/trips/${id}/cancel',
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
  Future<BaseModel<dynamic>> cancelTrip(String id) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _cancelTrip(id));
  }

  Future<BaseModel<dynamic>> _verifyPassengerPins(
    String tripId,
    SafetyPinRequest request,
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
            '/driver/trips/${tripId}/verify-safety-pins',
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
  Future<BaseModel<dynamic>> verifyPassengerPins(
    String tripId,
    SafetyPinRequest request,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _verifyPassengerPins(tripId, request),
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

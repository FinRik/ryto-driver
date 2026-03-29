import 'dart:io';

import '../../utils/storage/token_storage.dart';
import '../di.dart';
import '../models/auth/driver_profile_request.dart';
import '../services/api_service.dart';

abstract class AuthRepo {
  Future<bool> login(String phone);
  Future<bool> register(String phone);
  Future<bool> verifyPhone(String code);
  Future<bool> resendOtp();
  Future<bool> updateProfilePic(File image);
  Future<bool> updateProfile(DriverProfileRequest request);
  Future<bool> logout();
}

class AuthRepoImpl implements AuthRepo {
  // final _apiService = sl<ApiService>();
  final ApiService _apiService;

  AuthRepoImpl({ApiService? service})
    : _apiService = service ?? sl<ApiService>();

  @override
  Future<bool> login(String phone) async {
    final res = await _apiService.login(phone);
    return res.code == 200;
  }

  @override
  Future<bool> register(String phone) async {
    final res = await _apiService.register(phone);
    if (res.data != null) await TokenStorage.saveAccessToken(res.data!.token);
    return res.code == 200;
  }

  @override
  Future<bool> verifyPhone(String code) async {
    final res = await _apiService.verifyOtp(code);
    return res.code == 200;
  }

  @override
  Future<bool> resendOtp() async {
    final res = await _apiService.resendOtp();
    return res.code == 200;
  }

  @override
  Future<bool> updateProfile(DriverProfileRequest request) async {
    final res = await _apiService.updateProfile(request);
    return res.code == 200;
  }

  @override
  Future<bool> updateProfilePic(File image) async {
    final res = await _apiService.uploadProfilePicture(image);
    return res.code == 200;
  }

  @override
  Future<bool> logout() async {
    final res = await _apiService.resendOtp();
    return res.code == 200;
  }
}

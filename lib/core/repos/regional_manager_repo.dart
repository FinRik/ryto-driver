import 'package:flutter/material.dart';

import '../../app/app_setup_locator.dart';
import '../enums/bottom_sheet_type.dart';
import '../services/bottom_sheet_service.dart';
import '../services/regional_manager_service.dart';
import '../setups/region_identity_setup.dart';

abstract class RegionalManagerRepo {
  Future<void> initializeRegion();
  Future<String?> setRegion();
  Future<void> setRegionManually(String detectedCode);
}

class RegionalManagerRepoImpl implements RegionalManagerRepo {
  final RegionalManagerService _service;

  RegionalManagerRepoImpl(RegionalManagerService? service)
    : _service = service ??= sl<RegionalManagerService>();

  @override
  Future<void> initializeRegion() async {
    // 1. Start detection
    String? detectedCode = await _service.getAutoDetectedCountry();

    // 2. Check if detection failed or is unsupported
    bool isInvalid =
        detectedCode == null || (detectedCode != 'NG' && detectedCode != 'US');

    if (isInvalid) {
      //TODO: check user data saved in hydrated bloc or local storage
      // ONLY show the bottom sheet if we don't have a valid code yet
    }

    // 3. Register the Single Source of Truth
    _registerIdentity(detectedCode);
  }

  @override
  Future<String?> setRegion() async {
    final response = await sl<BottomSheetService>()
        .showCustomBottomSheet<void, String>(
          variant: BottomSheetType.regionSelector,
        );

    if (response?.confirmed == true && response?.data != null) {
      final detectedCode = response!.data;
      _registerIdentity(detectedCode);
      debugPrint("Manual Selection: $detectedCode");
      return detectedCode;
    } else {
      debugPrint("Selection dismissed. Defaulting to NG.");
      return null;
    }
  }

  @override
  Future<void> setRegionManually(String code) async {
    try {
      _registerIdentity(code);
      debugPrint("Manual Selection: $code");
    } catch (e) {
      debugPrint("Selection dismissed. Defaulting to NG.");
    }
  }

  void _registerIdentity(String? code) {
    if (sl.isRegistered<RegionIdentity>()) {
      sl.unregister<RegionIdentity>();
    }

    if (code == 'US') {
      sl.registerSingleton<RegionIdentity>(USIdentity());
    } else {
      sl.registerSingleton<RegionIdentity>(NGIdentity());
    }
  }
}

import 'package:json_annotation/json_annotation.dart';

import '../../../app/api_urls.dart';
import '../../enums/action_status.dart';

part 'vehicle_detail.g.dart';

@JsonSerializable()
class VehicleDetail {
  final int id;
  final int userId;
  final String type;
  final String serviceTier;
  final String makeModel;
  final int year;
  final String color;
  final String plateNumber;
  final int passengerSeats;
  final bool frontSeatAvailable;
  final bool loadSmallPackages;
  final bool loadMediumLoads;
  final bool loadLargeLoads;
  final String storageLocation;
  final String? licenseImageUrl;
  final String? roadworthinessImageUrl;
  final String? insuranceImageUrl;
  final String? photoFrontUrl;
  final String? photoBackUrl;
  final String? photoSideUrl;
  final String? photoInteriorUrl;
  final String? photoOtherUrl;
  final String verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleDetail({
    required this.id,
    required this.userId,
    required this.type,
    required this.serviceTier,
    required this.makeModel,
    required this.year,
    required this.color,
    required this.plateNumber,
    required this.passengerSeats,
    required this.frontSeatAvailable,
    required this.loadSmallPackages,
    required this.loadMediumLoads,
    required this.loadLargeLoads,
    required this.storageLocation,
    this.licenseImageUrl,
    this.roadworthinessImageUrl,
    this.insuranceImageUrl,
    this.photoFrontUrl,
    this.photoBackUrl,
    this.photoSideUrl,
    this.photoInteriorUrl,
    this.photoOtherUrl,
    required this.verificationStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isVehicleREGVerified => verificationStatus == "APPROVED";
  bool get isVehicleREGPending => verificationStatus == "PENDING";
  bool get isVehicleREGRejected => verificationStatus == "REJECTED"
      || verificationStatus == "FAILED";

  ActionStatus get status {
    if (isVehicleREGVerified) {
      return ActionStatus.completed;
    } else if (isVehicleREGRejected) {
      return ActionStatus.failed;
    } else if (isVehicleREGPending) {
      return ActionStatus.pending;
    } else {
      return ActionStatus.notSet;
    }
  }

  String? get formattedLicenseImageUrl {
    if (licenseImageUrl == null) return null;
    return _parseUrl(licenseImageUrl!);
  }

  String? get formattedRoadworthinessImageUrl {
    if (roadworthinessImageUrl == null) return null;
    return _parseUrl(roadworthinessImageUrl!);
  }

  String? get formattedInsuranceImageUrl {
    if (insuranceImageUrl == null) return null;
    return _parseUrl(insuranceImageUrl!);
  }

  String? get formattedPhotoFrontUrl {
    if (photoFrontUrl == null) return null;
    return _parseUrl(photoFrontUrl!);
  }

  String? get formattedPhotoBackUrl {
    if (photoBackUrl == null) return null;
    return _parseUrl(photoBackUrl!);
  }

  String? get formattedPhotoSideUrl {
    if (photoSideUrl == null) return null;
    return _parseUrl(photoSideUrl!);
  }

  String get formattedPhotoInteriorUrl {
    if (photoInteriorUrl == null) return "";
    return _parseUrl(photoInteriorUrl!);
  }

  String? get formattedPhotoOtherUrl {
    if (photoOtherUrl == null) return null;
    return _parseUrl(photoOtherUrl!);
  }

  String _parseUrl(String url) => ApiUrls.baseUrl + url;

  factory VehicleDetail.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDetailToJson(this);
}

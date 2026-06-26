// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDetail _$VehicleDetailFromJson(Map<String, dynamic> json) =>
    VehicleDetail(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      type: json['type'] as String,
      serviceTier: json['serviceTier'] as String,
      makeModel: json['makeModel'] as String,
      year: (json['year'] as num).toInt(),
      color: json['color'] as String,
      plateNumber: json['plateNumber'] as String,
      passengerSeats: (json['passengerSeats'] as num).toInt(),
      frontSeatAvailable: json['frontSeatAvailable'] as bool,
      loadSmallPackages: json['loadSmallPackages'] as bool,
      loadMediumLoads: json['loadMediumLoads'] as bool,
      loadLargeLoads: json['loadLargeLoads'] as bool,
      storageLocation: json['storageLocation'] as String,
      licenseImageUrl: json['licenseImageUrl'] as String?,
      roadworthinessImageUrl: json['roadworthinessImageUrl'] as String?,
      insuranceImageUrl: json['insuranceImageUrl'] as String?,
      photoFrontUrl: json['photoFrontUrl'] as String?,
      photoBackUrl: json['photoBackUrl'] as String?,
      photoSideUrl: json['photoSideUrl'] as String?,
      photoInteriorUrl: json['photoInteriorUrl'] as String?,
      photoOtherUrl: json['photoOtherUrl'] as String?,
      verificationStatus: json['verificationStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VehicleDetailToJson(VehicleDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'serviceTier': instance.serviceTier,
      'makeModel': instance.makeModel,
      'year': instance.year,
      'color': instance.color,
      'plateNumber': instance.plateNumber,
      'passengerSeats': instance.passengerSeats,
      'frontSeatAvailable': instance.frontSeatAvailable,
      'loadSmallPackages': instance.loadSmallPackages,
      'loadMediumLoads': instance.loadMediumLoads,
      'loadLargeLoads': instance.loadLargeLoads,
      'storageLocation': instance.storageLocation,
      'licenseImageUrl': instance.licenseImageUrl,
      'roadworthinessImageUrl': instance.roadworthinessImageUrl,
      'insuranceImageUrl': instance.insuranceImageUrl,
      'photoFrontUrl': instance.photoFrontUrl,
      'photoBackUrl': instance.photoBackUrl,
      'photoSideUrl': instance.photoSideUrl,
      'photoInteriorUrl': instance.photoInteriorUrl,
      'photoOtherUrl': instance.photoOtherUrl,
      'verificationStatus': instance.verificationStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

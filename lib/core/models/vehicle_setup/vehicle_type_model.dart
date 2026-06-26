import '../../../app/res/icons.dart';

class VehicleTypeModel {
  final String id;
  final String carType;
  final String catDesc;
  final String image;

  VehicleTypeModel({
    required this.id,
    required this.carType,
    required this.catDesc,
    required this.image,
  });

  static List<VehicleTypeModel> packageSizes = [
    VehicleTypeModel(
      id: "SEDAN",
      carType: "Sedan",
      catDesc: "4 Seats",
      image: AppIcons.car,
    ),
    VehicleTypeModel(
      id: "SUV",
      carType: "Suv",
      catDesc: "4-6 Seats",
      image: AppIcons.suv,
    ),
    VehicleTypeModel(
      id: "MINIVAN",
      carType: "Minivan",
      catDesc: "6-8 Seats",
      image: AppIcons.minivan,
    ),
    VehicleTypeModel(
      id: "MINIBUS",
      carType: "Minibus",
      catDesc: "8-15 Seats",
      image: AppIcons.minibus,
    ),
    VehicleTypeModel(
      id: "BUS",
      carType: "Bus",
      catDesc: "15+ Seats",
      image: AppIcons.bus,
    ),
    VehicleTypeModel(
      id: "PICKUP",
      carType: "Pickup",
      catDesc: "5 Seats + Cargo bed",
      image: AppIcons.pickupVan,
    ),
    VehicleTypeModel(
      id: "SMALL_VAN",
      carType: "Small Van",
      catDesc: "8-15 Seats",
      image: AppIcons.smallVan,
    ),
    VehicleTypeModel(
      id: "MEDIUM_VAN",
      carType: "Medium Van",
      catDesc: "15+ Seats",
      image: AppIcons.car,
    ),
    VehicleTypeModel(
      id: "LARGE_VAN",
      carType: "Large Van",
      catDesc: "4 Seats",
      image: AppIcons.car,
    ),
  ];
}

class PackageDetails {
  final String title;
  final String icon;

  PackageDetails({required this.title, required this.icon});

  // static List<PackageDetails> packageSizes = [
  //   PackageDetails(title: "Documents", icon: AppIcons.documentText),
  //   PackageDetails(title: "Clothing", icon: AppIcons.clothing),
  //   PackageDetails(title: "Electronics", icon: AppIcons.electronics),
  //   PackageDetails(title: "Gift", icon: AppIcons.giftOutlined),
  //   PackageDetails(title: "Other", icon: AppIcons.boxOutlined),
  // ];
}

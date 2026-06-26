import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/res/icons.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';

class BottomNavModel {
  final String name;
  final String image;
  final String activeImage;

  BottomNavModel({
    required this.name,
    required this.image,
    required this.activeImage,
  });
}

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  List<BottomNavModel> list = [
    BottomNavModel(
      name: "Home",
      image: AppIcons.home,
      activeImage: AppIcons.homeFilled,
    ),
    BottomNavModel(
      name: "Trips",
      image: AppIcons.route,
      activeImage: AppIcons.routeFilled,
    ),
    BottomNavModel(
      name: "Earnings",
      image: AppIcons.money,
      activeImage: AppIcons.moneyFilled,
    ),
    BottomNavModel(
      name: "Profile",
      image: AppIcons.userOctagon,
      activeImage: AppIcons.userOctagonFilled,
    ),
  ];

  void goHome() {
    onTap(0);
  }

  void moveTo(int index) => onTap(index);

  void moveToNext() {
    if (state < list.length - 1) {
      emit(state + 1);
    }
  }

  void moveToPrevious() {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void onTap(int index) {
    switch (index) {
      case 0:
        router.go(Paths.HOME);
        break;
      case 1:
        router.go(Paths.TRIPS);
        break;
      case 2:
        router.go(Paths.EARNINGS);
        break;
      case 3:
        router.go(Paths.PROFILE);
        break;
      default:
        router.go(Paths.HOME);
        break;
    }
    if (index >= 0 && index < list.length) {
      emit(index);
    }
  }
}

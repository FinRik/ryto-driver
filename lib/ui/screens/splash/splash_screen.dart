import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/res/logos.dart';
import '../../../core/repos/regional_manager_repo.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/helpers/jwt_utils.dart';
import '../../../utils/storage/app_launch_state.dart';
import '../../../utils/storage/token_storage.dart';
import '../../styles/app_colors.dart';
import '../../widgets/customs/svg_widget.dart';
import '../../widgets/texts/header_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Use Future.wait to run branding timer and logic in parallel
    await Future.wait([
      context.read<RegionalManagerRepo>().initializeRegion(),
    ]);
    // Once initialized, proceed with Auth logic
    final token = await TokenStorage.getAccessToken();
    if (!(await AppLaunchState.isFirstLaunch())) {
      if (JwtUtils.isValid(token)) {
        router.push(Paths.HOME);
      } else {
        router.push(Paths.LOGIN);
      }
    } else {
      router.go(Paths.ONBOARDING);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary.withOpacity(.8),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              SizedBox(),
              Column(
                children: [
                  SvgWidget(assetName: AppLogos.appLogoWhiteYellow),
                  const SizedBox(height: 27),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xffE3FB20).withOpacity(.20),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: Color(0xffE3FB20)),
                    ),
                    child: Text(
                      "DRIVER",
                      style: TextStyle(color: Color(0xffE3FB20)),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 4, color: Color(0xffE3FB20)),
                    ),
                  ),
                  SizedBox(height: 24),
                  HeaderText(
                    label: "Intercity Travel & Logistics",
                    subText: "Empowering your journey",
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    labelStyle: TextStyle(
                      color: AppColors.tertiarySwatch[50],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    subTextStyle: TextStyle(
                      color: AppColors.tertiarySwatch[50],
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

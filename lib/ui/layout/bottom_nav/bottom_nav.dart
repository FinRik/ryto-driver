import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


import '../../../app/app_setup_locator.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../dialogs/generic_dialog.dart';
import '../../screens/home/bloc/home_bloc.dart';
import 'cubit/bottom_nav_cubit.dart';

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({super.key, required this.child});

  final Widget child;

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        final cubit = context.read<BottomNavCubit>();
        final items = cubit.list;

        return Scaffold(
          extendBody: false,
          extendBodyBehindAppBar: true,
          body: widget.child,
          bottomNavigationBar: BottomNavigationBar(
            // selectedFontSize: 14.0,
            // unselectedFontSize: 14.0,
            // iconSize: 24,
            // selectedLabelStyle: TextStyle(
            //   color: Color(0xff0A83FF),
            //   fontSize: 24.0,
            // ),
            // unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 24),
            //   backgroundColor: Colors.white,
            //   // onTap: cubit.moveTo,
            //   selectedItemColor: const Color(0xff0A83FF),
            //   unselectedItemColor: Colors.black,
            //   selectedLabelStyle: const TextStyle(
            //     fontSize: 14.0,
            //   ),
            //   unselectedLabelStyle: const TextStyle(
            //     fontSize: 14.0,
            //     color: Colors.black
            //   ),
            //   onTap: cubit.onTap,
            //   currentIndex: currentIndex,
            //   items: List.generate(
            //     items.length,
            //     (index) => BottomNavigationBarItem(
            //       icon: Column(
            //         children: [
            //           SvgPicture.asset(
            //             items[index].image,
            //             height: 24,
            //             width: 24
            //           ),
            //           const SizedBox(height: 2),
            //         ],
            //       ),
            //       activeIcon: Column(
            //         children: [
            //           SvgPicture.asset(
            //             items[index].activeImage,
            //             height: 24,
            //             width: 24,
            //           ),
            //           const SizedBox(height: 2),
            //         ],
            //       ),
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            elevation: 2,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xff0A83FF),
            unselectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(fontSize: 14.0),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.black, // this will now be respected
            ),
            onTap: (index) {
              final bloc = context.read<HomeBloc>();
              final region = sl<RegionIdentity>();
              final isComplete = bloc.state.isFullyOnboarded(
                region.countryCode,
              );
              if (isComplete || index == 0) {
                cubit.onTap(index);
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => GenericDialog(
                    title: 'Onboarding Incomplete',
                    content:
                        'Please complete your onboarding to access this section.',
                    onButtonPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                );
              }
            },
            currentIndex: currentIndex,
            items: List.generate(
              items.length,
              (index) => BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset(items[index].image, height: 24, width: 24),
                    const SizedBox(height: 2),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset(
                      items[index].activeImage,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
                label: items[index].name,
              ),
            ),
          ),
        );
      },
    );
  }
}

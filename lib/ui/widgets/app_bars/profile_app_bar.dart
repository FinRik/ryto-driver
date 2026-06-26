import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/res/svgs.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../layout/bottom_nav/cubit/bottom_nav_cubit.dart';
import '../customs/svg_widget.dart';
import '../dp_image_widget.dart';
import '../texts/header_text.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
    this.bottom,
    this.backgroundColor,
    this.disableBorder = false,
    this.height = 125,
  });

  final Widget? bottom;
  final Color? backgroundColor;
  final bool disableBorder;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final user = state.user;
        final fullName = "${user?.firstName ?? ''} ${user?.lastName ?? ''}"
            .trim();
        final displayName = fullName.isNotEmpty ? fullName : "User";

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? const Color(0xffF6F7F8),
                border: disableBorder
                    ? Border.all(style: BorderStyle.none)
                    : const Border(
                        bottom: BorderSide(width: 1, color: Color(0xffE2E8F0)),
                      ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.read<BottomNavCubit>().moveTo(3),
                    child: Row(
                      children: [
                        DpImageWidget(
                          height: 20,
                          width: 20,
                          imageUrl: user?.profilePicture,
                        ),
                        // CircleAvatar(
                        //   radius: 20,
                        //   backgroundColor: const Color(
                        //     0xff0066FF,
                        //   ).withOpacity(0.1),
                        //   backgroundImage:
                        //       (user?.profilePicture != null &&
                        //           user!.profilePicture!.isNotEmpty)
                        //       ? NetworkImage(user.profilePicture!)
                        //       : null,
                        //   child:
                        //       (user?.profilePicture == null ||
                        //           user!.profilePicture!.isEmpty)
                        //       ? Text(
                        //           state.user!.initials,
                        //           style: const TextStyle(
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.bold,
                        //             color: Color(0xff0066FF),
                        //           ),
                        //         )
                        //       : null,
                        // ),
                        const SizedBox(width: 12),
                        HeaderText(
                          label: "Welcome",
                          subText: "Capt. ${user?.firstName ?? 'User'}",
                          padding: EdgeInsets.zero,
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff64748B),
                          ),
                          subTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgWidget(assetName: AppSvgs.notification),
                ],
              ),
            ),
            if (bottom != null) bottom!,
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}

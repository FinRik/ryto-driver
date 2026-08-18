import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/enums/action_status.dart';
import '../../../core/enums/bottom_sheet_type.dart';
import '../../../core/models/01_uis/profile_menu_item.dart';
import '../../../core/routes/routes.dart';
import '../../../core/services/bottom_sheet_service.dart';
import '../../widgets/app_bars/profile_header_app_bar.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../widgets/customs/svg_widget.dart';
import '../../../core/routes/router.dart';
import '../../../app/res/icons.dart';
import '../../widgets/loaders/circular_indicator.dart';
import '../auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // Handle Loading State
          if (state.status == ProfileStatus.loading && state.user == null) {
            return const Center(child: CircularIndicator());
          }

          final user = state.user;

          // Fallback UI if user data is missing
          if (user == null) {
            return const Center(child: Text("Unable to load profile"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeaderAppBar(
                  name: user.displayName ?? user.fullname,
                  joinDate:
                      "Member since ${user.phoneVerifiedAt?.year ?? '2024'}",
                  rating: "${user.rating}",
                  isVerified: user.identityVerified,
                  imageUrl: user.profilePicture ?? "",
                  onEditProfile: () {
                    print("Edit profile clicked");
                  },
                ),
                const SizedBox(height: 32),
                ...ProfileMenuItem.profileItems.map(
                  (item) => _buildMenuTile(
                    item,
                    item.title == "KYC Verification"
                        ? user.kycStatus
                        : item.status,
                    () {
                      if (item.title == "KYC Verification") {
                        router.push(item.route, extra: true);
                      } else if (item.title == "Trip Preferences") {
                        router.push(item.route, extra: false);
                      } else if (item.title == "Contact Support") {
                        sl<BottomSheetService>().showCustomBottomSheet(
                          variant: BottomSheetType.contactSupport,
                        );
                      } else {
                        router.push(item.route);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 36),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthInitial) {
                      router.go(Paths.LOGIN);
                    }
                  },
                  builder: (context, state) {
                    return TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgWidget(
                            assetName: AppIcons.logout,
                            iconColor: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text("Logout", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuTile(
    ProfileMenuItem item,
    ActionStatus status,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xffEFF6FF),
          radius: 20,
          child: SvgWidget(
            assetName: item.icon,
            // iconColor: isPending ? Colors.orange : null,
            iconColor: status.color,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 14,
            // color: isPending ? Colors.orange.shade800 : Colors.black,
            color: status.color,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: item.title == "KYC Verification"
                      ? status.color
                      : Colors.grey.shade600,
                  // color: isPending
                  //     ? Colors.orange.shade800
                  //     : Colors.grey.shade600,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == ActionStatus.pending)
              Icon(Icons.pending_actions, color: Colors.orange.shade800),
            if (status == ActionStatus.completed)
              Icon(Icons.verified, color: Colors.green.shade800),
            if (status == ActionStatus.pending) const SizedBox(width: 12),
            if (item.isChevronShown)
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

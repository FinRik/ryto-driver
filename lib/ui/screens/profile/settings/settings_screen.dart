import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import 'bloc/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: SingleChildScrollView(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowHeader(title: 'App Settings'),
                const SizedBox(height: 43),

                SettingsSection(
                  header: "Notifications",
                  tiles: [
                    SettingsTile(
                      title: "Push Notifications",
                      subtitle: "Alerts for trips and updates",
                      trailing: Switch(
                        value: state.pushNotifications,
                        onChanged: cubit.togglePushNotifications,
                        activeColor: Colors.blue,
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    SettingsTile(
                      title: "Sound",
                      subtitle: "Enable sound for new requests",
                      trailing: Switch(
                        value: state.soundEnabled,
                        onChanged: cubit.toggleSound,
                        activeColor: Colors.blue,
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    SettingsTile(
                      title: "Email Alerts",
                      subtitle: "Monthly reports and security updates",
                      trailing: Switch(
                        value: state.emailAlerts,
                        onChanged: cubit.toggleEmailAlerts,
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),

                // SettingsSection(
                //   header: "Language",
                //   tiles: [
                //     SettingsTile(
                //       title: "Language",
                //       subtitle: "Current: ${state.selectedLanguage}",
                //       onTap: () {
                //         // Quick flip example for testing reactivity
                //         // final nextLang = state.selectedLanguage == "English (US)"
                //         //     ? "Español (ES)"
                //         //     : "English (US)";
                //         // cubit.changeLanguage(nextLang);
                //       },
                //     ),
                //   ],
                // ),

                SettingsSection(
                  header: "Data Usage",
                  tiles: [
                    SettingsTile(
                      title: "High-Quality Maps",
                      subtitle: "Uses more data for detailed textures",
                      trailing: Switch(
                        value: state.highQualityMaps,
                        onChanged: cubit.toggleHighQualityMaps,
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Version 2.4.12 (Build 883)",
                    style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
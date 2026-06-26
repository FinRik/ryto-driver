import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/models/01_uis/pending_setup.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/page_view_widget.dart';
import '../../../widgets/form_step_indicator.dart';
import '../../../../core/routes/router.dart';

class VerificationSetupScreen extends StatefulWidget {
  const VerificationSetupScreen({super.key, required this.isDashboard});

  final bool isDashboard;

  @override
  State<VerificationSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends State<VerificationSetupScreen> {
  final region = sl<RegionIdentity>();
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchKycStatus(0));
  }

  void _fetchKycStatus(int index) {
    if (index == 0 && widget.isDashboard == true) {
      context.read<ProfileBloc>().add(FetchUserProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = region.countryCode == "US"
        ? PendingSetup.usKycListView
        : PendingSetup.ngKycListView;

    return PageViewWidget(
      controller: controller,
      items: items,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: _fetchKycStatus,
      builder: (cxt, item, index) => BaseScaffoldWidget(
        removePadding: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isDashboard == false)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => router.go(Paths.HOME),
                  child: Text("Skip"),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BackArrowHeader(
                      title: item.title,
                      subText: item.subText,
                      setDefaultPadding: false,
                      onPressed: () {
                        if (controller.page != 0) {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        } else {
                          router.pop();
                        }
                      },
                    ),
                  ),
                  FormStepIndicator(
                    index: "${index + 1}",
                    length: "${items.length}",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(child: item.pageBuilder(controller)),
          ],
        ),
      ),
    );
  }
}

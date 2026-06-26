import 'package:flutter/material.dart';

import '../../../../core/models/01_uis/pending_setup.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/page_view_widget.dart';
import '../../../widgets/form_step_indicator.dart';
import '../../../../core/routes/router.dart';

class VehicleSetupScreen extends StatefulWidget {
  const VehicleSetupScreen({super.key});

  @override
  State<VehicleSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends State<VehicleSetupScreen> {
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: PageViewWidget(
        controller: controller,
        items: PendingSetup.vehicleListView,
        physics: NeverScrollableScrollPhysics(),
        builder: (cxt, item, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                          duration: Duration(seconds: 1),
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
                  length: "${PendingSetup.vehicleListView.length}",
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(child: item.pageBuilder(controller)),
          ],
        ),
      ),
    );
  }
}

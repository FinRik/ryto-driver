import 'package:flutter/material.dart';

import '../../core/services/bottom_sheet_service.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class RegionSelectorBottomSheet extends StatelessWidget {
  const RegionSelectorBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  final SheetRequest request;
  final Function(SheetResponse<String>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      builder: (context, size) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Select your operating region",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Text("🇳🇬", style: TextStyle(fontSize: 24)),
            title: const Text("Nigeria"),
            subtitle: const Text("Services available in NGN"),
            onTap: () => completer(SheetResponse(confirmed: true, data: 'NG')),
          ),
          ListTile(
            leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
            title: const Text("United States"),
            subtitle: const Text("Services available in USD"),
            onTap: () => completer(SheetResponse(confirmed: true, data: 'US')),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

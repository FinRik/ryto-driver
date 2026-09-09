import 'package:flutter/material.dart';

import '../../core/services/bottom_sheet_service.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class DocumentUploadSourceBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse<String>) completer;

  const DocumentUploadSourceBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<DocumentUploadSourceBottomSheet> createState() =>
      _BankSearchBottomSheetState();
}

class _BankSearchBottomSheetState
    extends State<DocumentUploadSourceBottomSheet> {
  final List<Map> sources = [
    {
      "id": "camera",
      'title': 'Camera',
      "subtitle": "Take a picture with your camera",
    },
    {
      "id": "gallery",
      "title": "Gallery",
      "subtitle": "Pick an image from your gallery",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      hasScrollableChild: true,
      showHandleBar: true,
      multiplier: .4,
      builder: (ctx, size) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Upload Source",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sources.length,
              itemBuilder: (context, index) {
                final source = sources[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(source['title']),
                      subtitle: Text(source['subtitle']),
                      onTap: () => widget.completer(
                        SheetResponse(confirmed: true, data: source['id']),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

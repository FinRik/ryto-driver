import 'package:flutter/material.dart';

import '../../core/models/reason.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class CancelBookingBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse<String>) completer;

  const CancelBookingBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<CancelBookingBottomSheet> createState() =>
      _CancelBookingBottomSheetState();
}

class _CancelBookingBottomSheetState extends State<CancelBookingBottomSheet> {
  List<CancellationReason> get _cancelReasons => CancellationReason.reasons;

  String? _selectedReason;
  final _otherReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _submitCancellation() {
    if (_selectedReason == null) return;

    // Explicit validation check if "Other" is picked
    if (_selectedReason == "Other" && !_formKey.currentState!.validate()) {
      return;
    }

    final finalReason = _selectedReason == "Other"
        ? _otherReasonController.text.trim()
        : _selectedReason!;

    widget.completer(SheetResponse(confirmed: true, data: finalReason));
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      multiplier: .7,
      builder: (ctx, size) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5F2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Reason for cancellation",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2559),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please select a reason to help us improve our ride experience.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _cancelReasons.map((reason) {
                final isSelected = _selectedReason == reason.name;
                return ChoiceChip(
                  label: Text(reason.name),
                  selected: isSelected,
                  onSelected: (selected) => setState(
                    () => _selectedReason = selected ? reason.id : null,
                  ),
                  selectedColor: const Color(0xFF1B2559).withOpacity(0.12),
                  backgroundColor: const Color(0xFFF4F7FE),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1B2559)
                        : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF1B2559)
                          : Colors.transparent,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),

            // Animate addition of Textfield seamlessly when "Other" is highlighted
            if (_selectedReason == "Other") ...[
              const SizedBox(height: 20),
              TextFormField(
                controller: _otherReasonController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Type your cancellation reason here...",
                  fillColor: const Color(0xFFF4F7FE),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1B2559)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please state your reason";
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 32),

            // Submission Action Button Controls
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedReason != null ? _submitCancellation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  disabledBackgroundColor: const Color(0xFFE0E5F2),
                  disabledForegroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Confirm Cancellation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

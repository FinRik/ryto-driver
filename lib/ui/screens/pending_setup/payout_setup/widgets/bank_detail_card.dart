import 'package:flutter/material.dart';

import '../../../../widgets/status_pill.dart';

class BankDetailCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final bool isDefault;
  final bool isVerified;
  final VoidCallback onEdit;

  const BankDetailCard({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    this.isDefault = false,
    this.isVerified = false,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F2F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFF0F7FF),
                      child: Icon(Icons.account_balance, color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    // Wrap this Column in Expanded to prevent the Row from overflowing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Wrap the bankName Text in Flexible
                              Flexible(
                                child: Text(
                                  bankName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (isDefault) ...[
                                const SizedBox(width: 8),
                                const StatusPill(
                                  label: "DEFAULT",
                                  color: Colors.blue,
                                ),
                              ],
                            ],
                          ),
                          Text(
                            accountNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF637381),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (isVerified) ...[
                const SizedBox(width: 8), // Add small gap
                const StatusPill(
                  label: "VERIFIED",
                  color: Colors.green,
                  showCheck: true,
                ),
              ],
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  accountName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF637381),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // ...
        ],
      ),
    );
  }
}
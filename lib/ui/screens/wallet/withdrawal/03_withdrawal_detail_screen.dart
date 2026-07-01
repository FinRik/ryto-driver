import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/wallet/withdrawal_response.dart';
import '../../../../utils/helpers/socials_helper.dart';
import '../../../widgets/currency_formatter_widget.dart';

class WithdrawalDetailScreen extends StatelessWidget {
  final WithdrawalResponse withdrawalResponse;

  const WithdrawalDetailScreen({super.key, required this.withdrawalResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Color(0xFF1B2559)),
        title: const Text(
          "Transaction Details",
          style: TextStyle(
            color: Color(0xFF1B2559),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. Transaction Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2559),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "WITHDRAWAL AMOUNT",
                    style: TextStyle(
                      color: Color(0xFF8F9BBA),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CurrencyFormatterWidget(
                    amount: "${withdrawalResponse.amount}",
                    textColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF05CD99).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFF05CD99),
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Completed",
                              style: TextStyle(
                                color: Color(0xFF05CD99),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Processed on ${DateFormat('MMM dd, yyyy').format(withdrawalResponse.createdAt)}",
                        style: const TextStyle(
                          color: Color(0xFF8F9BBA),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Metadata Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.account_balance,
                    "DESTINATION BANK",
                    withdrawalResponse.provider,
                    // trailing: "•••• $lastFour",
                  ),
                  const Divider(height: 32, color: Color(0xFFE0E5F2)),
                  _buildDetailRow(
                    Icons.fingerprint,
                    "TRANSACTION ID",
                    withdrawalResponse.providerRef,
                    isCopyable: true,
                  ),
                  const Divider(height: 32, color: Color(0xFFE0E5F2)),
                  _buildDetailRow(
                    Icons.access_time,
                    "DATE & TIME",
                    DateFormat(
                      'MMM dd, yyyy · hh:mm a',
                    ).format(withdrawalResponse.createdAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Financial Breakdown Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Breakdown",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2559),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBreakdownItem(
                    "Transfer Amount",
                    "${withdrawalResponse.amount}",
                    isAmount: true,
                  ),
                  const SizedBox(height: 12),
                  _buildBreakdownItem(
                    "Standard Processing Fee",
                    "Free",
                    isGreen: true,
                  ),
                  const Divider(height: 32, color: Color(0xFFE0E5F2)),
                  _buildBreakdownItem(
                    "Net Settlement",
                    "${withdrawalResponse.amount}",
                    isTotal: true,
                    isAmount: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Help Section
            _buildHelpCard(),
            const SizedBox(height: 40),

            // 5. Bottom Actions
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () {},
            //         icon: const Icon(
            //           Icons.file_download_outlined,
            //           color: Colors.white,
            //         ),
            //         label: const Text(
            //           "Download Receipt",
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: const Color(0xFF0061FF),
            //           padding: const EdgeInsets.symmetric(vertical: 16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30),
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Container(
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF4F7FE),
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const Icon(
            //           Icons.share_outlined,
            //           color: Color(0xFF1B2559),
            //         ),
            //         padding: const EdgeInsets.all(16),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    String? trailing,
    bool isCopyable = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0061FF), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF8F9BBA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(color: Color(0xFF8F9BBA), fontSize: 12),
          ),
        if (isCopyable)
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
            },
            icon: Icon(Icons.copy_all, color: Color(0xFF8F9BBA), size: 18),
          ),
      ],
    );
  }

  Widget _buildBreakdownItem(
    String label,
    String value, {
    bool isGreen = false,
    bool isTotal = false,
    bool isAmount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? const Color(0xFF1B2559) : const Color(0xFF8F9BBA),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        isAmount
            ? CurrencyFormatterWidget(amount: value)
            : Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isGreen
                      ? const Color(0xFF05CD99)
                      : (isTotal
                            ? const Color(0xFF0061FF)
                            : const Color(0xFF1B2559)),
                  fontSize: isTotal ? 18 : 14,
                ),
              ),
      ],
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF4F7FE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.redAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Need help?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
                const Text(
                  "Contact Ryto support if funds don't arrive in 3 days.",
                  style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 11),
                ),
                TextButton(
                  onPressed: () => SocialHelper.sendEmail("support@getryto.com"),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                  ),
                  child: const Text(
                    "Contact Support >",
                    style: TextStyle(
                      color: Color(0xFF0061FF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

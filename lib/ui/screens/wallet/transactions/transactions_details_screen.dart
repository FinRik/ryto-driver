import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionId;
  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //fetch transaction detail,
    });
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Main Payout Card
            _buildPayoutHeaderCard(),
            const SizedBox(height: 24),

            // 2. High-Level Breakdown Tiles
            _buildStatTile(
              "GROSS EARNINGS",
              "\$1,410.00",
              "Total trip fares + tips",
            ),
            const SizedBox(height: 16),
            _buildStatTile(
              "RYTO SERVICE FEE",
              "-\$161.50",
              "11.45% Platform deduction",
              isNegative: true,
            ),
            const SizedBox(height: 16),
            _buildStatTile("VOLUME", "42 Trips", "Oct 17 - Oct 23 Period"),
            const SizedBox(height: 32),

            // 3. Earnings Detail List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Earnings Detail",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Download PDF",
                    style: TextStyle(
                      color: Color(0xFF0061FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildTripItem(
              "Trip #RY-8829-X",
              "Oct 23, 09:42 PM • Downtown",
              "\$34.20",
              extra: "+\$5.00 TIP",
              icon: Icons.directions_car,
            ),
            _buildTripItem(
              "Trip #RY-8821-A",
              "Oct 23, 08:15 PM • Airport",
              "\$62.80",
              extra: "BASE FARE",
              icon: Icons.flight_takeoff,
            ),
            _buildTripItem(
              "Peak Hour Bonus",
              "Weekly Performance Reward",
              "\$25.00",
              extra: "INCENTIVE",
              icon: Icons.verified_outlined,
              isIncentive: true,
            ),

            const SizedBox(height: 24),

            // 4. Footer Actions
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4F7FE),
                  foregroundColor: const Color(0xFF1B2559),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "View All 42 Items",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFooterLink(Icons.help_outline, "Payout issue?"),
                Container(width: 1, height: 20, color: const Color(0xFFE0E5F2)),
                _buildFooterLink(Icons.description_outlined, "Tax documents"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2559),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "NET PAYOUT AMOUNT",
            style: TextStyle(
              color: Color(0xFF8F9BBA),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "\$1,248.50",
            style: TextStyle(
              color: Colors.white,
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
                      "Transferred to Bank",
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
              const Text(
                "Completed on Oct 24, 2023",
                style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(
    String label,
    String value,
    String sub, {
    bool isNegative = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF8F9BBA),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isNegative ? Colors.redAccent : const Color(0xFF1B2559),
            ),
          ),
          Text(
            sub,
            style: const TextStyle(color: Color(0xFF8F9BBA), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTripItem(
    String title,
    String subtitle,
    String amount, {
    required String extra,
    required IconData icon,
    bool isIncentive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF4F7FE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0061FF), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8F9BBA),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
              Text(
                extra,
                style: TextStyle(
                  color: isIncentive
                      ? const Color(0xFF05CD99)
                      : const Color(0xFF8F9BBA),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8F9BBA)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1B2559),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../app/res/images.dart';
import '../../../../core/models/trip/trip.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/currency_formatter_widget.dart';

class TripCard extends StatelessWidget {
  final String status;
  final String title;
  final String dateTime;
  final String earnings;
  final int seats;
  final int packages;
  final double? rating;
  final VoidCallback onManage;
  final VoidCallback onMoreOption;

  const TripCard({
    super.key,
    required this.status,
    required this.title,
    required this.dateTime,
    required this.earnings,
    required this.seats,
    required this.packages,
    this.rating,
    required this.onManage,
    required this.onMoreOption,
  });

  @override
  Widget build(BuildContext context) {
    final config = TripUIConfig.fromStatus(status);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // 1. Media Section with Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: ColorFiltered(
                  colorFilter: config.isGrayscale
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: Image.asset(
                    AppImages.tripCardBackground,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: config.badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    config.badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          dateTime,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        if (config.showRating) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "⭐ $rating",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "EARNINGS EST.",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        CurrencyFormatterWidget(
                          amount: earnings,
                          builder: (ctx, amount, rawAmount) => Text(
                            amount,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                // Metadata Row
                Row(
                  children: [
                    Icon(
                      Icons.chair_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$seats Seats",
                      style: const TextStyle(
                        color: Color(0xff0F172A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$packages Packages",
                      style: const TextStyle(
                        color: Color(0xff0F172A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                // const SizedBox(height: 16),

                // 3. Action Row
                Row(
                  children: [
                    Expanded(
                      child: config.isLinkButton
                          ? TextButton(
                              onPressed: onManage,
                              child: Text(config.actionLabel),
                            )
                          : Button(onTap: onManage, text: config.actionLabel),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: onMoreOption,
                        icon: const Icon(Icons.more_horiz),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../dp_image_widget.dart';
import '../texts/header_text.dart';

class ProfileHeaderAppBar extends StatelessWidget {
  final String name;
  final String joinDate;
  final String rating;
  final bool isVerified;
  final String imageUrl;
  final VoidCallback onEditProfile;

  const ProfileHeaderAppBar({
    super.key,
    required this.name,
    required this.joinDate,
    required this.rating,
    this.isVerified = true,
    required this.imageUrl,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Avatar with Edit Badge
        Stack(
          children: [
            DpImageWidget(
              height: 120,
              width: 120,
              imageUrl: (imageUrl),
              isCircular: true,
              showEditIcon: false,
              initialsOrErrorMessage: name,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditProfile,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E88E5), // Primary Blue
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 2. Name and Join Date
        HeaderText(
          label: name,
          subText: "Member since $joinDate",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          subTextStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        const SizedBox(height: 16),

        // 3. Status Tags Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatusTag(
              label: "Verified Driver",
              icon: Icons.verified,
              color: Colors.green,
              backgroundColor: const Color(0xFFE8F5E9),
            ),
            const SizedBox(width: 7.99),
            _StatusTag(
              label: "$rating Rating",
              icon: Icons.star,
              color: Color(0xFF1E88E5),
              backgroundColor: const Color(0xFFE3F2FD),
            ),
          ],
        ),
      ],
    );
  }
}

// Internal Helper for Tags
class _StatusTag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _StatusTag({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/enums/verification_status.dart';
import 'customs/svg_widget.dart';

class VerificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? leadingIcon;
  final String? svgIcon;
  final String index;
  final VerificationStatusEnum status;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;

  const VerificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingIcon,
    this.index = "1",
    required this.status,
    this.onTap,
    this.svgIcon, this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    bool isLocked = status == VerificationStatusEnum.locked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: isLocked ? null : onTap,
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 23,
          ),
          leading: CircleAvatar(
            backgroundColor: const Color(0xffEFF6FF),
            radius: 20,
            child: svgIcon != null
                ? SvgWidget(assetName: svgIcon!)
                : leadingIcon != null
                ? Icon(leadingIcon, color: const Color(0xff5C6A85), size: 20)
                : Text(
                    index,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xff2D3142),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xff9BA3B1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    switch (status) {
      case VerificationStatusEnum.locked:
        return const Icon(Icons.lock_outline, color: Color(0xff9BA3B1));
      case VerificationStatusEnum.inReview:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xffFFFBEB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "In Review",
                style: TextStyle(
                  color: Color(0xffB45309),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      case VerificationStatusEnum.available:
        return const Icon(Icons.chevron_right, color: Color(0xffD1D5DB));
      case VerificationStatusEnum.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case VerificationStatusEnum.failed:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }
}

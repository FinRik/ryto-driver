import 'package:flutter/material.dart';

enum UploadStatus { pending, optional, none }

class FileUploadTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final UploadStatus status;
  final bool isUploaded;
  final VoidCallback onUpload;

  const FileUploadTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    this.status = UploadStatus.none,
    this.isUploaded = false,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50), // pill shape
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Leading Icon
          CircleAvatar(
            backgroundColor: const Color(0xFFE8F1FF),
            child: Icon(leadingIcon, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    // if (status != UploadStatus.none) ...[
                    //   const SizedBox(width: 8),
                    //   _StatusBadge(status: status),
                    // ]
                  ],
                ),
                Text(subtitle, style: TextStyle(color: Colors.blueGrey.shade300)),
              ],
            ),
          ),
          // Action Button
          Material(
            elevation: isUploaded ? 4 : 0,
            shadowColor: Colors.blue.withOpacity(0.4),
            shape: const CircleBorder(),
            color: isUploaded ? Colors.blue.shade700 : const Color(0xFFE8F1FF),
            child: IconButton(
              icon: Icon(Icons.file_upload_outlined,
                  color: isUploaded ? Colors.white : Colors.blue.shade400),
              onPressed: onUpload,
            ),
          ),
        ],
      ),
    );
  }
}

// Internal Helper for the "Pending/Optional" tags
class _StatusBadge extends StatelessWidget {
  final UploadStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == UploadStatus.pending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPending ? const Color(0xFFFFF4E5) : const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPending ? "PENDING" : "OPTIONAL",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isPending ? Colors.orange : Colors.blueGrey,
        ),
      ),
    );
  }
}

class UploadProgressBar extends StatelessWidget {
  final int total;
  final int uploaded;

  const UploadProgressBar({super.key, required this.total, required this.uploaded});

  @override
  Widget build(BuildContext context) {
    double progress = uploaded / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("UPLOAD PROGRESS",
                style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            Text("$uploaded/$total",
                style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE0E5ED)), // Matching the grey-blue bar
          ),
        ),
      ],
    );
  }
}
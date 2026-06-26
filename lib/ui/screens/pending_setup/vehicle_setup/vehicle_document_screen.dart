import 'package:flutter/material.dart';

import '../../../../core/models/vehicle_setup/vehicle_detail.dart';
import '../../../widgets/buttons/back_arrow_button.dart';

// class VehicleDocumentsScreen extends StatelessWidget {
//   final VehicleDetail vehicle;
//
//   const VehicleDocumentsScreen({super.key, required this.vehicle});
//
//   @override
//   Widget build(BuildContext context) {
//     // List of documents to display
//     final docs = [
//       {'label': 'License', 'url': vehicle.formattedLicenseImageUrl},
//       {
//         'label': 'Road Worthiness',
//         'url': vehicle.formattedRoadworthinessImageUrl,
//       },
//       {'label': 'Insurance', 'url': vehicle.formattedInsuranceImageUrl},
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: BackArrowButton(),
//         ),
//         title: const Text('Vehicle Documents'),
//         elevation: 0,
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: docs.length,
//         separatorBuilder: (context, index) => const SizedBox(height: 16),
//         itemBuilder: (context, index) {
//           return DocumentCard(
//             imageUrl: docs[index]['url']!,
//             label: docs[index]['label']!,
//           );
//         },
//       ),
//     );
//   }
// }

class VehicleDocumentsScreen extends StatelessWidget {
  final VehicleDetail vehicle;

  const VehicleDocumentsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    // 1. Build a list filtering out null or empty URLs dynamically
    final docs = <Map<String, String>>[
      if (vehicle.formattedLicenseImageUrl != null && vehicle.formattedLicenseImageUrl!.isNotEmpty)
        {'label': 'License', 'url': vehicle.formattedLicenseImageUrl!},
      if (vehicle.formattedRoadworthinessImageUrl != null && vehicle.formattedRoadworthinessImageUrl!.isNotEmpty)
        {'label': 'Road Worthiness', 'url': vehicle.formattedRoadworthinessImageUrl!},
      if (vehicle.formattedInsuranceImageUrl != null && vehicle.formattedInsuranceImageUrl!.isNotEmpty)
        {'label': 'Insurance', 'url': vehicle.formattedInsuranceImageUrl!},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BackArrowButton(),
        ),
        title: const Text('Vehicle Documents'),
        elevation: 0,
      ),
      // 2. Handle the empty state case gracefully if no documents exist
      body: docs.isEmpty
          ? const Center(
        child: Text(
          'No uploaded documents found.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: docs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return DocumentCard(
            imageUrl: docs[index]['url']!,
            label: docs[index]['label']!,
          );
        },
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const DocumentCard({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 1. The Image Layer
            Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),

            // 2. The Gradient Overlay (Ensures text is readable regardless of image color)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),

            // 3. The Text Overlay
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

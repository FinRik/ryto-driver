import 'package:flutter/material.dart';

import '../../../../../core/models/vehicle_setup/vehicle_detail.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../widgets/status_pill.dart';

class VehicleCardWidget extends StatelessWidget {
  final VehicleDetail vehicle;

  const VehicleCardWidget({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(color: Color(0xffF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Image Header with Verified Badge
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(vehicle.formattedPhotoFrontUrl ?? ""),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: StatusPill(
                  label: vehicle.verificationStatus,
                  color: vehicle.verificationStatus.toLowerCase() == "pending"
                      ? Colors.orange
                      : Colors.green,
                  showCheck:
                      vehicle.verificationStatus.toLowerCase() == "pending"
                      ? false
                      : true,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.makeModel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vehicle.plateNumber,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 2. Quick Action Bar (Edit, Documents, Add New)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.edit_calendar_rounded,
                  "EDIT DETAILS",
                  () => router.push(Paths.VEHICLESETUP),
                ),
                Container(color: Color(0xffF1F5F9), width: 1, height: 50),
                _buildActionButton(
                  Icons.description_outlined,
                  "DOCUMENTS",
                  () => router.push(Paths.VEHICLEDOCUMENTS, extra: vehicle),
                ),
                Container(color: Color(0xffF1F5F9), width: 1, height: 50),
                _buildActionButton(
                  Icons.add_circle_outline,
                  "ADD NEW",
                  () => router.push(Paths.VEHICLESETUP),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

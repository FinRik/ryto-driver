import 'package:flutter/material.dart';

import '../../core/models/lat_lng.dart';
import 'arrival_time_widget.dart';
import 'location_fetch_builder.dart';

class BuildRouteCard extends StatelessWidget {
  const BuildRouteCard({
    super.key,
    this.title,
    this.subtitle,
    this.originCity,
    this.destCity,
    required this.startCoord,
    required this.stopCoord,
    this.departureDate,
    this.departureTime,
    required this.departureDateTime,
  });

  final String? title, subtitle;
  final String? originCity, destCity;
  final LatLng startCoord, stopCoord;
  final String? departureDate, departureTime;
  final DateTime departureDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BuildRouteRow(
          label: title ?? "PICKUP",
          location: originCity,
          subLocation: LatLng(lat: startCoord.lat, lng: startCoord.lng),
          isFirst: true,
        ),
        const SizedBox(height: 20),
        _BuildRouteRow(
          label: subtitle ?? "DROP-OFF",
          location: destCity,
          subLocation: LatLng(lat: stopCoord.lat, lng: stopCoord.lng),
          isFirst: false,
        ),
        if (departureDate != null && departureTime != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Colors.grey.shade100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimeInfo(
                "Date & Time",
                "$departureDate \n$departureTime",
              ),
              ArrivalTimeWidget(
                sourceLng: startCoord.lng,
                sourceLat: startCoord.lat,
                destLng: stopCoord.lng,
                destLat: stopCoord.lat,
                departureDateTime: departureDateTime,
                builder: (ctx, eta) => _buildDateTimeInfo(
                  "Estimated Duration",
                  eta.formattedArrivalTime,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDateTimeInfo(
    String title,
    String value, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8F9BBA)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2559),
          ),
        ),
      ],
    );
  }
}

class _BuildRouteRow extends StatelessWidget {
  final String label;
  final String? location;
  final LatLng subLocation;
  final bool isFirst;
  const _BuildRouteRow({
    required this.label,
    this.location,
    required this.subLocation,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isFirst ? Icons.radio_button_checked : Icons.radio_button_off,
              color: const Color(0xFF0061FF),
              size: 18,
            ),
            if (isFirst)
              Container(width: 2, height: 60, color: const Color(0xFFE0E5F2)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8F9BBA),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (location != null)
                Text(
                  location!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2559),
                  ),
                ),
              LocationFetchBuilder(
                address: subLocation,
                builder: (context, latlng) => Text(
                  "${latlng?.address}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8F9BBA),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

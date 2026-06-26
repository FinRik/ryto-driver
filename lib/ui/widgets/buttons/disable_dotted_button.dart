import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';

class CreateTripPlaceholder extends StatelessWidget {
  const CreateTripPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF98A6BC);
    const Color backgroundColor = Color(0xFFEBF1F6);

    return Container(
      decoration: DottedDecoration(
        shape: Shape.box,
        color: brandColor,
        strokeWidth: 1.5,
        dash: const [6, 4],
        borderRadius: BorderRadius.circular(
          40.0,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: brandColor, size: 20),
            SizedBox(width: 12),
            Text(
              'Create a Trip',
              style: TextStyle(
                color: brandColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

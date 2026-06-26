import 'package:flutter/material.dart';

import '../../../../../app/res/icons.dart';
import '../../../../widgets/customs/svg_widget.dart';

class StorageItemWidget extends StatefulWidget {
  const StorageItemWidget({super.key, required this.onSelected});

  final Function(String item, String id) onSelected;

  @override
  State<StorageItemWidget> createState() => _StorageItemWidgetState();
}

class _StorageItemWidgetState extends State<StorageItemWidget> {
  // 1. Define the state variable in your State class
  int selectedIndex = -1;

  List<Map> storageOptions = [
    {"id": "TRUNK_ONLY", "name": "Trunk Only", "image": AppIcons.trunk},
    {"id": "BACK_SEAT", "name": "Back Seat", "image": AppIcons.backSeat},
    {"id": "PICKUP_BED", "name": "Pickup Bed", "image": AppIcons.pickupBed},
  ];

  // 3. The callback function
  void onItemSelected(String text, String id) {
    widget.onSelected(text, id);
    print("Selected Location: $text");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Increased slightly to prevent overflow from border width
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: storageOptions.length,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) => _StorageItem(
          label: storageOptions[index]['name'],
          icon: storageOptions[index]['image'],
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() => selectedIndex = index);
            onItemSelected(storageOptions[index]['name'], storageOptions[index]['id']);
          },
        ),
      ),
    );
  }
}

class _StorageItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String icon;

  const _StorageItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Define your colors based on the selection state
    final Color themeColor = isSelected ? Colors.blue : Color(0xffE7E8E9);
    final Color contentColor = isSelected ? Colors.blue : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 127,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: themeColor, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(
            8,
          ), // Optional: looks better with selection
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgWidget(assetName: icon, iconColor: contentColor),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: contentColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

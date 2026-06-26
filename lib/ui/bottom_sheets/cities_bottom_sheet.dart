import 'package:flutter/material.dart';

import '../../core/services/bottom_sheet_service.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class CitiesBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse<String>) completer;
  const CitiesBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<CitiesBottomSheet> createState() => _CitiesBottomSheetState();
}

class _CitiesBottomSheetState extends State<CitiesBottomSheet> {
  late List<String> allCities;
  List<String> filteredCities = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allCities = widget.request.data ?? [];
    filteredCities = List.from(allCities); // Make a copy
  }

  void _filterCities(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCities = List.from(allCities);
      });
      return;
    }

    setState(() {
      filteredCities = allCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      hasScrollableChild: true,
      multiplier: .8,
      builder: (context, size) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Search city",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCities,
              decoration: InputDecoration(
                hintText: "Search city...",
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _filterCities('');   // Important: reset list
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // Results List
          Expanded(
            child: filteredCities.isEmpty
                ? const Center(
              child: Text(
                "No cities found",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,           // Good practice in bottom sheets
              physics: const ClampingScrollPhysics(),
              itemCount: filteredCities.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredCities[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () => widget.completer(
                    SheetResponse(
                      confirmed: true,
                      data: filteredCities[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models/country/us_state.dart';

class UsStateBottomSheet extends StatefulWidget {
  const UsStateBottomSheet({super.key});

  @override
  State<UsStateBottomSheet> createState() => _UsStateBottomSheetState();
}

class _UsStateBottomSheetState extends State<UsStateBottomSheet> {
  // Use empty lists to avoid null-check errors during the first build
  List<USState> allStates = [];
  List<USState> filteredStates = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initStates(); // No need for postFrameCallback if you handle isLoading
    _searchController.addListener(_performSearch);
  }

  Future<void> initStates() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/countries/us-states.json',
      );
      final data = json.decode(response);
      final usData = USData.fromJson(data);

      setState(() {
        allStates = usData.states;
        filteredStates = usData.states; // Show all states initially
        isLoading = false;
      });
    } catch (e) {
      // Handle file loading errors
      setState(() => isLoading = false);
      print("Error loading states: $e");
    }
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Filter the local 'allStates' list, not 'widget.allStates'
      filteredStates = allStates.where((state) {
        return state.name.toLowerCase().contains(query) ||
            state.shortcode.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.all(8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search state or code...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),

            // Filtered List
            Expanded(
              child: filteredStates.isEmpty
                  ? const Center(child: Text("No results found"))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: filteredStates.length,
                      itemBuilder: (context, index) {
                        final state = filteredStates[index];
                        return ListTile(
                          title: Text(state.name),
                          trailing: Text(
                            state.shortcode,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () => Navigator.pop(context, state),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

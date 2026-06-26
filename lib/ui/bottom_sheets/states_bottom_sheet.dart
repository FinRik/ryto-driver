import 'package:flutter/material.dart';

import '../../core/models/country/states_model.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class StatesBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse<StateModel>) completer;

  const StatesBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<StatesBottomSheet> createState() => _StatesBottomSheetState();
}

class _StatesBottomSheetState extends State<StatesBottomSheet> {
  late final List<StateModel> allStates;
  List<StateModel> filteredStates = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allStates = List.from(widget.request.data ?? []); // Safe copy
    filteredStates = List.from(allStates);
  }

  void _filterStates(String query) {
    final cleanQuery = query.trim().toLowerCase();

    setState(() {
      if (cleanQuery.isEmpty) {
        filteredStates = List.from(allStates);
      } else {
        filteredStates = allStates
            .where((state) =>
            (state.name ?? '').toLowerCase().contains(cleanQuery))
            .toList();
      }
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Select State",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStates,
              decoration: InputDecoration(
                hintText: "Search state...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterStates('');
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

          const SizedBox(height: 8),
          const Divider(height: 1),

          // This is the critical part
          Expanded(
            child: filteredStates.isEmpty
                ? const Center(
              child: Text(
                "No states found",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: filteredStates.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final stateItem = filteredStates[index];
                return ListTile(
                  title: Text(stateItem.name ?? ""),
                  subtitle: stateItem.stateCode != null
                      ? Text(
                    stateItem.stateCode!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  )
                      : null,
                  onTap: () => widget.completer(
                    SheetResponse(confirmed: true, data: stateItem),
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
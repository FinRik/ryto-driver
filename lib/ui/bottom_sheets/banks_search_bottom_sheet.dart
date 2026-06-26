import 'package:flutter/material.dart';

import '../../core/models/bank/bank.dart';

class BankSearchBottomSheet extends StatefulWidget {
  final List<Bank> banks;
  final Function(Bank) onBankSelected;

  const BankSearchBottomSheet({
    super.key,
    required this.banks,
    required this.onBankSelected,
  });

  @override
  State<BankSearchBottomSheet> createState() => _BankSearchBottomSheetState();
}

class _BankSearchBottomSheetState extends State<BankSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Bank> filteredBanks = [];

  @override
  void initState() {
    super.initState();
    filteredBanks = widget.banks;
    _searchController.addListener(_filterBanks);
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredBanks = widget.banks;
      } else {
        filteredBanks = widget.banks
            .where((bank) =>
        (bank.name?.toLowerCase().contains(query) ?? false) ||
            (bank.code?.toLowerCase().contains(query) ?? false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Select Bank",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: "Search bank name or code...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredBanks.isEmpty
                ? const Center(child: Text("No banks found"))
                : ListView.builder(
              itemCount: filteredBanks.length,
              itemBuilder: (context, index) {
                final bank = filteredBanks[index];
                return ListTile(
                  title: Text(bank.name ?? ''),
                  // subtitle: Text("Code: ${bank.code ?? ''}"),
                  onTap: () => widget.onBankSelected(bank),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
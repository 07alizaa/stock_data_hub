import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? startDate; // Start date for filtering
  DateTime? endDate; // End date for filtering
  String? selectedEntryType; // Entry type filter
  String? selectedSupplier; // Supplier filter

  // Sample data for transactions
  List<Map<String, dynamic>> transactions = [
    {
      'date': DateTime(2024, 12, 1),
      'entryType': 'Inward',
      'supplier': 'Supplier A',
      'productName': 'Product 1',
      'quantity': 10,
      'price': 100.0,
    },
    {
      'date': DateTime(2024, 12, 3),
      'entryType': 'Outward',
      'supplier': 'Supplier B',
      'productName': 'Product 2',
      'quantity': 5,
      'price': 50.0,
    },
  ];

  List<String> suppliers = ["Supplier A", "Supplier B", "Supplier C"]; // Example suppliers

  @override
  Widget build(BuildContext context) {
    // Filter transactions based on selected filters
    final filteredTransactions = transactions.where((transaction) {
      if (startDate != null && transaction['date'].isBefore(startDate!)) return false;
      if (endDate != null && transaction['date'].isAfter(endDate!)) return false;
      if (selectedEntryType != null && transaction['entryType'] != selectedEntryType) return false;
      if (selectedSupplier != null && transaction['supplier'] != selectedSupplier) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              children: [
                Expanded(
                  child: _buildDateFilter(
                    label: "Start Date",
                    selectedDate: startDate,
                    onDateSelected: (date) => setState(() => startDate = date),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDateFilter(
                    label: "End Date",
                    selectedDate: endDate,
                    onDateSelected: (date) => setState(() => endDate = date),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedEntryType,
              hint: const Text('Select Entry Type'),
              onChanged: (newValue) {
                setState(() {
                  selectedEntryType = newValue;
                });
              },
              items: ["Inward", "Outward"].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedSupplier,
              hint: const Text('Select Supplier'),
              onChanged: (newValue) {
                setState(() {
                  selectedSupplier = newValue;
                });
              },
              items: suppliers.map((supplier) {
                return DropdownMenuItem(
                  value: supplier,
                  child: Text(supplier),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Report Table
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(transaction['productName']),
                            subtitle: Text(
                              'Date: ${_formatDate(transaction['date'])}\n'
                                  'Quantity: ${transaction['quantity']} | Price: ${transaction['price']}',
                            ),
                            trailing: Text(transaction['entryType']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a date filter
  Widget _buildDateFilter({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            onDateSelected(pickedDate);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              selectedDate == null ? 'Select Date' : _formatDate(selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}

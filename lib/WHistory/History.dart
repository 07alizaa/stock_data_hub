import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Dummy data for history
  final List<Map<String, dynamic>> historyRecords = [
    {
      "date": "2024-12-10",
      "action": "Dispatched 50 units of Product A to Supplier X",
    },
    {
      "date": "2024-12-09",
      "action": "Added 100 units of Product B to inventory",
    },
    {
      "date": "2024-12-08",
      "action": "Completed 'Check Inventory Levels' task",
    },
    {
      "date": "2024-12-07",
      "action": "Low stock alert for Product C triggered",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8), // Beige background
        padding: const EdgeInsets.all(16.0),
        child: historyRecords.isEmpty
            ? const Center(
          child: Text(
            "No history records available.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
            : ListView.builder(
          itemCount: historyRecords.length,
          itemBuilder: (context, index) {
            final record = historyRecords[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color(0xFF123D59),
              child: ListTile(
                title: Text(
                  record["action"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  record["date"],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                leading: const Icon(
                  Icons.history,
                  color: Colors.orange,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

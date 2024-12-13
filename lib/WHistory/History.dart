import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No history records available.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            final historyRecords = snapshot.data!;

            return ListView.builder(
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${record["date"]}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        if (record["details"] != null)
                          Text(
                            "Details: ${record["details"]}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    leading: const Icon(
                      Icons.history,
                      color: Colors.orange,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final List<Map<String, dynamic>> history = [];

    // Fetch dispatch records
    final dispatchSnapshot = await _firestore
        .collection('dispatchRecords')
        .orderBy('date', descending: true)
        .get();

    for (var doc in dispatchSnapshot.docs) {
      final data = doc.data();
      history.add({
        "action": "Dispatched",
        "date": data["date"],
        "details": "Product: ${data["product"]}, Quantity: ${data["quantity"]}, Supplier: ${data["supplier"]}",
      });
    }

    // Fetch product changes history
    final productsSnapshot = await _firestore.collection('products').get();
    for (var productDoc in productsSnapshot.docs) {
      final productId = productDoc.id;
      final historySnapshot = await _firestore
          .collection('products')
          .doc(productId)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .get();

      for (var historyDoc in historySnapshot.docs) {
        final data = historyDoc.data();
        history.add({
          "action": data["action"],
          "date": (data["timestamp"] as Timestamp).toDate().toString(),
          "details": "Field: ${data["details"]["field"]}, Previous: ${data["details"]["previousValue"]}, New: ${data["details"]["newValue"]}",
        });
      }
    }

    // Sort by date
    history.sort((a, b) => b["date"].compareTo(a["date"]));

    return history;
  }
}

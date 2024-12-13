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
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('dispatchRecords')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No history records available.",
                  style: TextStyle(color: Colors.grey, fontSize:16),
                ),
              );
            }

            final historyRecords = snapshot.data!.docs.map((doc) {
              return {
                "date": doc["date"] ?? "Unknown date",
                "action":
                "Dispatched ${doc["quantity"]} units of ${doc["product"]} to ${doc["supplier"]}",
                "priority": doc["priority"] ?? "Normal Priority",
                "status": doc["status"] ?? "Pending",
              };
            }).toList();

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
                        Text(
                          "Priority: ${record["priority"]}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Status: ${record["status"]}",
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
}

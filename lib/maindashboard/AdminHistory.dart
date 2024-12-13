import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProductHistoryScreen extends StatefulWidget {
  const AdminProductHistoryScreen({super.key});

  @override
  State<AdminProductHistoryScreen> createState() => _AdminProductHistoryScreenState();
}

class _AdminProductHistoryScreenState extends State<AdminProductHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text(
          "Product History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8), // Beige background
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No product history records available.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            final productDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: productDocs.length,
              itemBuilder: (context, index) {
                final productDoc = productDocs[index];

                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('products')
                      .doc(productDoc.id)
                      .collection('history')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, historySnapshot) {
                    if (historySnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!historySnapshot.hasData || historySnapshot.data!.docs.isEmpty) {
                      return const SizedBox.shrink(); // Skip this product if no history
                    }

                    final historyRecords = historySnapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final details = data['details'] as Map<String, dynamic>? ?? {};
                      return {
                        "productId": productDoc.id,
                        "productName": productDoc['name'],
                        "action": data["action"] ?? "Unknown action",
                        "timestamp": (data["timestamp"] as Timestamp).toDate(),
                        "details": details,
                      };
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product: ${productDoc['name']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123D59),
                          ),
                        ),
                        ...historyRecords.map((record) => Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: const Color(0xFF123D59),
                          child: ListTile(
                            title: Text(
                              "Action: ${record["action"]}",
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
                                  "Date: ${record["timestamp"]}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                if (record["details"].isNotEmpty)
                                  Text(
                                    "Details: ${record["details"]["field"] ?? "Unknown field"} changed from ${record["details"]["previousValue"] ?? "N/A"} to ${record["details"]["newValue"] ?? "N/A"}",
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
                        ))
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertsNotifications extends StatefulWidget {
  const AlertsNotifications({super.key});

  @override
  _AlertsNotificationsState createState() => _AlertsNotificationsState();
}

class _AlertsNotificationsState extends State<AlertsNotifications> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        backgroundColor: const Color(0xFF123D59), // Dark teal color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching notifications"),
            );
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                "No alerts or notifications",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                    notifications[index].data() as Map<String, dynamic>;
                    final isRead = notification['read'] ?? false;

                    return Card(
                      color: isRead
                          ? Colors.blue.shade100
                          : const Color(0xFF123D59), // Dark teal for unread notifications
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: isRead
                              ? Colors.blue.shade300
                              : Colors.white,
                        ),
                        title: Text(
                          notification['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          notification['detail'] ?? 'No Details Available',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: isRead
                            ? null
                            : IconButton(
                          icon: const Icon(Icons.check_circle),
                          color: Colors.white,
                          onPressed: () {
                            _markAsRead(notifications[index].id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _clearNotifications,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECA25B),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text(
                  "Clear All Notifications",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Mark a notification as read
  Future<void> _markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification marked as read')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as read: $e')),
      );
    }
  }

  /// Clear all notifications
  Future<void> _clearNotifications() async {
    try {
      final snapshot = await _firestore.collection('notifications').get();

      for (var doc in snapshot.docs) {
        await _firestore.collection('notifications').doc(doc.id).delete();
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications cleared')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to clear notifications: $e')),
      );
    }
  }
}

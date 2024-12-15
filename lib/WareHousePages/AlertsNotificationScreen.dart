import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertsNotifications extends StatefulWidget {
  const AlertsNotifications({super.key});

  @override
  _AlertsNotificationsState createState() => _AlertsNotificationsState();
}

class _AlertsNotificationsState extends State<AlertsNotifications> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching notifications"));
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('No alerts or notifications.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
              notifications[index].data() as Map<String, dynamic>;
              final isRead = notification['read'] ?? false;

              return Card(
                color: isRead
                    ? Colors.grey.shade300
                    : const Color(0xFF123D59),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    notification['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    notification['detail'] ?? 'No Details',
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
          );
        },
      ),
    );
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marked as read.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as read: $e')),
      );
    }
  }
}

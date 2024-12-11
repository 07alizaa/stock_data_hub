import 'package:flutter/material.dart';

class AlertsNotifications extends StatefulWidget {
  const AlertsNotifications({super.key});

  @override
  _AlertsNotificationsState createState() => _AlertsNotificationsState();
}

class _AlertsNotificationsState extends State<AlertsNotifications> {
  // List to hold notifications
  List<Map<String, dynamic>> notifications = [
    {"title": "Low stock alert", "detail": "Item A is running low.", "read": false},
    {"title": "New order received", "detail": "Supplier B has sent a new order.", "read": false},
    {"title": "Inventory updated", "detail": "Stock levels were updated.", "read": true},
    {"title": "Task deadline", "detail": "Task #45 is nearing its deadline.", "read": false},
  ];

  // Function to clear all notifications
  void clearNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  // Function to mark a notification as read
  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        backgroundColor: const Color(0xFF123D59), // Dark teal color
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFF5F0E1), // Nude color background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                child: Text(
                  "No alerts or notifications",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    color: notification['read']
                        ? Colors.blue.shade100
                        : const Color(0xFF123D59), // Dark teal for unread notifications
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: notification['read']
                            ? Colors.blue.shade300
                            : Colors.white,
                      ),
                      title: Text(
                        notification['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        notification['detail'],
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: notification['read']
                          ? null
                          : IconButton(
                        icon: const Icon(Icons.check_circle),
                        color: Colors.white,
                        onPressed: () => markAsRead(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: clearNotifications,
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
        ),
      ),
    );
  }
}
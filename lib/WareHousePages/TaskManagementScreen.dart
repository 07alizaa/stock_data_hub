import 'package:flutter/material.dart';
import 'ProductList.dart';
import 'DispatchRecords.dart';

class TaskManagementScreen extends StatefulWidget {
  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text('Task Management', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              title: 'Manage Products',
              icon: Icons.inventory,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen()),
                );
                setState(() {}); // Refresh state when returning
              },
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              title: 'View Dispatch Records',
              icon: Icons.receipt,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DispatchFormScreen()),
                );
                setState(() {}); // Refresh state when returning
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF123D59)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward, color: Color(0xFF123D59)),
        onTap: onTap,
      ),
    );
  }
}

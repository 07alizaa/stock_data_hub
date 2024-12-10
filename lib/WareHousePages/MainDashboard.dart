import 'package:flutter/material.dart';
import 'WInventoryManagement.dart';
import 'AlertsNotificationScreen.dart';
import 'TaskManagementScreen.dart';
import 'DemandForecastScreen.dart';

class Maindashboard extends StatefulWidget {
  @override
  _MaindashboardState createState() => _MaindashboardState();
}

class _MaindashboardState extends State<Maindashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF123D59), // Set background color here
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59), // Matching background color for AppBar
        elevation: 0,
        title: const Text(
          'Warehouse Manager Dashboard',
          style: TextStyle(
            color: Colors.white, // Title text in white color
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF123D59),
                  backgroundImage: const NetworkImage(
                    'https://via.placeholder.com/150', // Placeholder profile image
                  ),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Warehouse Manager!', // Updated text
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text in white color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildQuickStatsSection(),
              const SizedBox(height: 20),
              _buildDemandForecastSection(),
              const SizedBox(height: 20),
              _buildInventoryTable(),
              const SizedBox(height: 20),
              _buildAlertsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Handle navigation based on the selected index
          if (index == 0) {
            // Navigate to the home screen (default behavior)
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryManagementScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TasksManagement()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlertsNotifications()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DemandForecastScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Forecast'),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Inventory Levels',
            value: '1,234',
            icon: Icons.storage,
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: _buildStatCard(
            title: 'Optimized Stock',
            value: '85%',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
        ),
        Expanded(
          child: _buildStatCard(
            title: 'Pending Orders',
            value: '42',
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemandForecastSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DemandForecastScreen()),
        );
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Demand Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: Text(
                    'Placeholder for Demand Forecast Graph',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real-Time Inventory',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Current Stock')),
                  DataColumn(label: Text('Reorder Threshold')),
                  DataColumn(label: Text('Status')),
                ],
                rows: [
                  _buildInventoryTableRow('Widget A', '250', '100', Colors.green),
                  _buildInventoryTableRow('Widget B', '75', '200', Colors.red),
                  _buildInventoryTableRow('Widget C', '500', '300', Colors.blue),
                  _buildInventoryTableRow('Widget D', '150', '250', Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildInventoryTableRow(
      String itemName, String currentStock, String reorderThreshold, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(itemName)),
        DataCell(Text(currentStock)),
        DataCell(Text(reorderThreshold)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStockStatus(currentStock, reorderThreshold),
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  String _getStockStatus(String currentStock, String reorderThreshold) {
    int current = int.parse(currentStock);
    int threshold = int.parse(reorderThreshold);

    if (current < threshold * 0.5) return 'Low';
    if (current < threshold) return 'Warning';
    return 'Optimal';
  }

  Widget _buildAlertsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildAlertItem(
                    'Low Stock Alert: Widget B',
                    'Current stock (75) is below reorder threshold (200)',
                    Icons.warning,
                    Colors.red,
                  ),
                  _buildAlertItem(
                    'Incoming Shipment',
                    'Shipment of 500 units of Widget C expected tomorrow',
                    Icons.local_shipping,
                    Colors.blue,
                  ),
                  _buildAlertItem(
                    'Overstock Warning',
                    'Widget D inventory exceeding optimal levels',
                    Icons.info,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(
      String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      subtitle: Text(subtitle),
    );
  }
}

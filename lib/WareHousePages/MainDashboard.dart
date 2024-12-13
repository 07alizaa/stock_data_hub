import 'package:flutter/material.dart';

// Import other pages
import 'package:stock_data_hub/DashboardOverview/DashboardOverviewScreen.dart';
import 'AlertsNotificationScreen.dart';
import 'WReports.dart';

import 'TaskManagementScreen.dart';
import 'DemandForecastScreen.dart';
import 'package:stock_data_hub/WHistory/History.dart';

import 'WinventoryManagement.dart'; // Placeholder for History

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text(
          'Warehouse Manager Dashboard',
          style: TextStyle(color: Colors.white), // White text
        ),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8), // Beige background
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Dashboard Overview
            _buildNavigationTile(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard Overview',
              screen: Dashboardscreen(),
            ),

            // Alerts
            _buildNavigationTile(
              context,
              icon: Icons.notifications,
              title: 'Alerts',
              screen: AlertsNotifications(),
            ),

            // Inventory Management
            _buildNavigationTile(
              context,
              icon: Icons.inventory,
              title: 'Inventory Management',
              screen: InventoryManagementScreen(),
            ),

            // Demand Forecast
            _buildNavigationTile(
              context,
              icon: Icons.bar_chart,
              title: 'Demand Forecast',
              screen: DemandForecastScreen(),
            ),

            // Task Management
            _buildNavigationTile(
              context,
              icon: Icons.task,
              title: 'Task Management',
              screen: TaskManagementScreen(),
            ),

            _buildNavigationTile(
              context,
              icon: Icons.task,
              title: 'Reports',
              screen: ReportPage(),
            ),


            // History
            _buildNavigationTile(
              context,
              icon: Icons.history,
              title: 'History',
              screen: HistoryScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget screen,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Card(
        elevation: 4,
        color: const Color(0xFF123D59), // Dark tile background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
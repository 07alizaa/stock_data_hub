import 'package:flutter/material.dart';


// Import other pages
import 'package:stock_data_hub/DashboardOverview/DashboardOverviewScreen.dart';

import 'AlertsNotificationScreen.dart';
import 'package:stock_data_hub/maindashboard/WinventoryManagement.dart';
import 'TaskManagementScreen.dart';
import 'DemandForecastScreen.dart';
import 'package:stock_data_hub/WHistory/History.dart'; // Placeholder for History

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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF123D59), // Blue-teal BottomNavigationBar
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Handle navigation based on the selected index
          if (index == 0) {
            // Stay on the home screen
          } else if (index == 1) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const InventoryManagementScreen()),
            // );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TasksManagement()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlertsNotifications()),
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

  // Quick Stats Section
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
      color: const Color(0xFF123D59), // Blue-teal background for stats
      elevation: 4,
      child: Padding(

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
              screen: TasksManagement(),
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

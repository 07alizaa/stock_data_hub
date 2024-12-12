import 'package:flutter/material.dart';

import '../ProductManagement/AddNewProduct.dart';

import 'SettingPage.dart';
import 'package:stock_data_hub/WareHousePages/WinventoryManagement.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF123D59),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildDashboardCard(
                    context,
                    label: "Dashboard Overview",
                    icon: Icons.dashboard,
                    onTap: () {
                      // Add navigation logic for Dashboard Overview
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    label: "Inventory Management",
                    icon: Icons.inventory,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InventoryManagementScreen(),
                        ),
                      );
                    },
                  ),



                  _buildDashboardCard(
                    context,
                    label: "Reports",
                    icon: Icons.bar_chart,
                    onTap: () {
                      // Add navigation logic for Reports
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    label: "History",
                    icon: Icons.history,
                    onTap: () {
                      // Add navigation logic for History
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    label: "Settings",
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF123D59),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: const Color(0xFF123D59),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

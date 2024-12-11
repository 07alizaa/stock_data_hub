import 'package:flutter/material.dart';

// Import other pages
import 'package:stock_data_hub/DashboardOverview/DashboardOverviewScreen.dart';
import 'AlertsNotificationScreen.dart';
import 'WInventoryManagement.dart';
import 'TaskManagementScreen.dart';
import 'DemandForecastScreen.dart';
import 'package:stock_data_hub/ProductManagement/AddNewProduct.dart';
import 'package:stock_data_hub/ProductManagement/UpdateProduct.dart';

class MainDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text('Warehouse Manager Dashboard'),
      ),
      body: Padding(
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

            // Add New Product
            _buildNavigationTile(
              context,
              icon: Icons.add_box,
              title: 'Add New Product',
              screen: AddNewProduct(),
            ),

            // Update Product
            _buildNavigationTile(
              context,
              icon: Icons.update,
              title: 'Update Product',
              screen: Updateproduct(
                product: {
                  'name': 'Sample Product',
                  'quantity': 100,
                  'description': 'Sample Description',
                  'price': 19.99,
                  'lowStockThreshold': 10,
                  'demandForecast': 50,
                  'status': 'Available',
                },
                onUpdate: (updatedProduct) {
                  print('Updated Product: $updatedProduct');
                },
              ),
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
        color: const Color(0xFF123D59),
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

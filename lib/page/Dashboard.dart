import 'package:flutter/material.dart';
import 'LowStockPage.dart';
import 'AddInwardPage.dart';
import 'AddOutwardPage.dart';
import 'product.dart';
import 'unit.dart';  // Import the UnitPage
import 'transaction.dart';  // Import TransactionPage
import 'reports.dart';  // Import ReportsPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

// Main Dashboard Page
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF123D59),
        centerTitle: true,
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Add notification action here
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open drawer
              },
            ),
          ),
        ],
      ),
      body: HomePage(),
      endDrawer: _buildHamburgerMenu(),
    );
  }

  Widget _buildHamburgerMenu() {
    return Drawer(
      backgroundColor: Color(0xFF123D59),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF123D59)),
            accountName: Text("John Doe", style: TextStyle(color: Colors.white)),
            accountEmail: Text("john.doe@example.com", style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF123D59)),
            ),
          ),
          _buildDrawerItem(Icons.all_inbox, "All Products", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductPage()),
            );
          }),
          _buildDrawerItem(Icons.people, "Suppliers", () {}),
          _buildDrawerItem(Icons.warehouse, "Warehouses", () {}),
          _buildDrawerItem(Icons.settings, "Units", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UnitPage()),
            );
          }),
          _buildDrawerItem(Icons.business, "Transactions", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionPage()),
            );
          }),
          _buildDrawerItem(Icons.bar_chart, "Reports", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportPage()),
            );
          }),
          _buildDrawerItem(Icons.logout, "Logout", () {}),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

// Dashboard Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                DashboardButton(
                  icon: Icons.inventory,
                  label: "Products",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductPage()),
                    );
                  },
                ),
                DashboardButton(
                  icon: Icons.warning,
                  label: "Low Stock",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LowStockPage()),
                    );
                  },
                ),
                DashboardButton(
                  icon: Icons.business,
                  label: "Transactions",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransactionPage()),
                    );
                  },
                ),
                DashboardButton(
                  icon: Icons.bar_chart,
                  label: "Reports",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Updated layout with Inward and Outward in a row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RectangleButton(
                  label: "Add Inward",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddInwardPage()),
                    );
                  },
                ),
                RectangleButton(
                  label: "Add Outward",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddOutwardPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Rectangle Button Widget
class RectangleButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  RectangleButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xFF123D59),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

// Reusable Dashboard Button Widget
class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  DashboardButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF123D59)),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16, color: Color(0xFF123D59))),
          ],
        ),
      ),
    );
  }
}
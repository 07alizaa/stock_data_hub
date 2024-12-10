import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'InventoryManagement.dart';
import 'DashboardPage.dart'; // Import Dashboard Page

class ReportsPage extends StatefulWidget {
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> todaySale = {
    "amount": "Rs0.0",
    "highestSale": "Rs0.0",
    "highlight": "No data available",
  };
  Map<String, dynamic> lastWeekSale = {
    "amount": "Rs0.0",
    "customers": "0",
    "highlight": "No data available",
  };

  @override
  void initState() {
    super.initState();
    _fetchReportsData();
  }

  void _fetchReportsData() async {
    try {
      final todayData = await _firestore.collection('sales').doc('today').get();
      final lastWeekData =
      await _firestore.collection('sales').doc('lastWeek').get();

      setState(() {
        todaySale = todayData.data() ?? todaySale;
        lastWeekSale = lastWeekData.data() ?? lastWeekSale;
      });
    } catch (e) {
      print("Error fetching sales data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color(0xFF123D59),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showSalesReportDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123D59),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Sales Report'),
            ),
            const SizedBox(height: 16.0),

            // Today's Sales Report Card
            _buildReportCard(
              title: "TODAY'S SALE",
              amount: todaySale["amount"],
              details: todaySale["highestSale"],
              highlight: todaySale["highlight"],
            ),
            const SizedBox(height: 16.0),

            // Last Week Sales Report Card
            _buildReportCard(
              title: "LAST WEEK SALE",
              amount: lastWeekSale["amount"],
              details:
              "Approx ${lastWeekSale["customers"]} customers arrived",
              highlight: lastWeekSale["highlight"],
            ),
            const Spacer(),

            // Generate Custom Report Button
            ElevatedButton(
              onPressed: _generateCustomReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9900),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    'Generate Custom Report',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF123D59),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            // Navigate to Inventory Management Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryManagementPage()),
            );
          } else if (index == 2) {
            // Navigate to Dashboard Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String amount,
    required String details,
    required String highlight,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF123D59),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            details,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            highlight,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  void _showSalesReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sales Report'),
          content: const Text(
            'Detailed sales report is generated from Firebase dynamically.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _generateCustomReport() async {
    try {
      await _firestore.collection('customReports').add({
        'generatedAt': FieldValue.serverTimestamp(),
        'details': 'Custom sales report generated successfully!',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Custom Report Generated!")),
      );
    } catch (e) {
      print("Error generating custom report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to generate custom report")),
      );
    }
  }
}

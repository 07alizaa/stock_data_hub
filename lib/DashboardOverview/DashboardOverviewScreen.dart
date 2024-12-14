import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // For rendering charts
import 'AprioriPage.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  // Dashboard stats variables
  int totalInventory = 0; // Total inventory count
  int dispatchedItems = 0; // Total dispatched items
  int pendingTasks = 0; // Number of tasks still pending
  int alerts = 0; // Number of low-stock alerts
  List<Map<String, dynamic>> recentActivities = []; // Recent activities list

  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    _listenToDashboardData(); // Start listening to Firestore updates
    _fetchRecentActivities(); // Fetch recent activities
  }

  // Real-time listener for Firestore data
  void _listenToDashboardData() {
    // Listen to inventory data
    firestore.collection('products').snapshots().listen((snapshot) {
      setState(() {
        totalInventory = snapshot.docs.fold<int>(
          0,
              (total, doc) => total + (doc['quantity'] as int? ?? 0), // Sum all product quantities
        );
      });
    });

    // Listen to dispatched items
    firestore
        .collection('dispatchRecords')
        .where('status', isEqualTo: 'Completed') // Only count completed dispatches
        .snapshots()
        .listen((snapshot) {
      setState(() {
        dispatchedItems = snapshot.docs.fold<int>(
          0,
              (total, doc) => total + (doc['quantity'] as int? ?? 0),
        );
      });
    });

    // Listen to pending tasks
    firestore
        .collection('tasks')
        .where('status', isEqualTo: 'Pending') // Only count tasks marked as pending
        .snapshots()
        .listen((snapshot) {
      setState(() {
        pendingTasks = snapshot.docs.length;
      });
    });

    // Listen to low-stock alerts
    firestore
        .collection('products')
        .where('quantity', isLessThan: 10) // Products with low stock
        .snapshots()
        .listen((snapshot) {
      setState(() {
        alerts = snapshot.docs.length;
      });
    });
  }

  // Fetch recent activities from Firestore
  Future<void> _fetchRecentActivities() async {
    try {
      final dispatchRecordsSnapshot =
      await firestore.collection('dispatchRecords').orderBy('date', descending: true).limit(5).get();
      final productUpdatesSnapshot =
      await firestore.collection('products').orderBy('updatedAt', descending: true).limit(5).get();

      List<Map<String, dynamic>> activities = [];

      // Process dispatch records
      for (var doc in dispatchRecordsSnapshot.docs) {
        final data = doc.data();
        activities.add({
          'type': 'Dispatch',
          'description': 'Dispatched ${data['quantity']} of ${data['product']}',
          'timestamp': data['date'] ?? 'Unknown Date',
        });
      }

      // Process product updates
      for (var doc in productUpdatesSnapshot.docs) {
        final data = doc.data();
        activities.add({
          'type': 'Product Update',
          'description': 'Updated product ${data['name']}',
          'timestamp': data['updatedAt'] ?? 'Unknown Date',
        });
      }

      // Sort activities by timestamp
      activities.sort((a, b) => (b['timestamp'] as Timestamp)
          .compareTo(a['timestamp'] as Timestamp));

      setState(() {
        recentActivities = activities;
      });
    } catch (e) {
      // Handle error
      print("Error fetching recent activities: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar for the dashboard
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59), // Dark teal color
        title: const Text(
          'Dashboard Overview',
          style: TextStyle(color: Colors.white), // White text color
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF5E8D8), // Beige background
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(), // Welcome message
              const SizedBox(height: 20),
              _buildQuickStatsSection(), // Quick stats
              const SizedBox(height: 20),
              _buildPerformanceOverview(), // Performance bar chart
              const SizedBox(height: 20),
              _buildRecentActivities(), // Recent activities
              const SizedBox(height: 20),
              _buildAprioriInsightsButton(), // Button for Apriori Insights
            ],
          ),
        ),
      ),
    );
  }

  // Welcome section at the top of the dashboard
  Widget _buildWelcomeSection() {
    return Card(
      elevation: 4, // Adds shadow for depth
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF123D59), // Dark teal background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for visibility
              ),
            ),
            SizedBox(height: 8), // Space below the title
            Text(
              "Here's an overview of your warehouse operations.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70, // Slightly lighter white for subtitle
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick stats section
  Widget _buildQuickStatsSection() {
    final stats = [
      {
        "title": "Total Inventory",
        "value": totalInventory.toString(),
        "icon": Icons.inventory,
        "color": Colors.blue,
      },
      {
        "title": "Dispatched Items",
        "value": dispatchedItems.toString(),
        "icon": Icons.local_shipping,
        "color": Colors.green,
      },
      {
        "title": "Pending Tasks",
        "value": pendingTasks.toString(),
        "icon": Icons.task,
        "color": Colors.orange,
      },
      {
        "title": "Alerts",
        "value": alerts.toString(),
        "icon": Icons.notifications,
        "color": Colors.red,
      },
    ];

    return Wrap(
      spacing: 16, // Space between cards horizontally
      runSpacing: 16, // Space between rows
      children: stats.map((stat) {
        return Card(
          elevation: 4, // Adds shadow for depth
          color: const Color(0xFF123D59), // Dark teal card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(stat["icon"] as IconData, color: Colors.white, size: 30),
                const SizedBox(height: 10),
                Text(
                  stat["value"] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: stat["color"] as Color, // Dynamic color based on stat type
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  stat["title"] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70, // Light white text
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Performance overview using fl_chart bar chart
  Widget _buildPerformanceOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF123D59), // Dark teal background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Fixed height for the chart
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: totalInventory.toDouble(),
                          color: Colors.blue,
                          width: 16,
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: dispatchedItems.toDouble(),
                          color: Colors.green,
                          width: 16,
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: pendingTasks.toDouble(),
                          color: Colors.orange,
                          width: 16,
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: alerts.toDouble(),
                          color: Colors.red,
                          width: 16,
                        )
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Inventory', style: TextStyle(color: Colors.white));
                            case 1:
                              return const Text('Dispatched', style: TextStyle(color: Colors.white));
                            case 2:
                              return const Text('Tasks', style: TextStyle(color: Colors.white));
                            case 3:
                              return const Text('Alerts', style: TextStyle(color: Colors.white));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false), // No border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent activities section
  Widget _buildRecentActivities() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF123D59),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Activities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            recentActivities.isEmpty
                ? const Text(
              "No recent activities available.",
              style: TextStyle(color: Colors.white70),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              itemBuilder: (context, index) {
                final activity = recentActivities[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    activity['description'] ?? 'No Description',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    activity['timestamp']?.toDate().toString() ?? 'Unknown Date',
                    style: const TextStyle(color: Colors.white38),
                  ),
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button for Apriori Insights
  // Button for Apriori Insights
  Widget _buildAprioriInsightsButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to Apriori Insights page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AprioriInsightsPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB66A39),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "View Apriori Insights",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

}

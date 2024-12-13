import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Warehouse Reports',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D59),
              ),
            ),
            const SizedBox(height: 20),
            _buildStockLevelsChart(),
            const SizedBox(height: 20),
            _buildDispatchStatusChart(),
            const SizedBox(height: 20),
            _buildLowStockList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStockLevelsChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildReportCard(
            title: 'Stock Levels Chart',
            content: const Text('No stock data available.'),
          );
        }

        final products = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['name'] ?? 'Unknown',
            'quantity': doc['quantity'] ?? 0,
          };
        }).toList();

        final barGroups = products.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: (entry.value['quantity'] ?? 0).toDouble(),
                color: Colors.blue,
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList();

        return _buildReportCard(
          title: 'Stock Levels Chart',
          content: SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < products.length) {
                          return Text(products[index]['name']);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDispatchStatusChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('dispatchRecords').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildReportCard(
            title: 'Dispatch Status Chart',
            content: const Text('No dispatch records available.'),
          );
        }

        final records = snapshot.data!.docs.map((doc) {
          return doc['status'] ?? 'Pending';
        }).toList();

        final statusCounts = <String, int>{};
        for (var status in records) {
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
        }

        final pieSections = statusCounts.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.key}: ${entry.value}',
            color: entry.key == 'Completed' ? Colors.green : Colors.orange,
          );
        }).toList();

        return _buildReportCard(
          title: 'Dispatch Status Chart',
          content: SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: pieSections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLowStockList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('products')
          .where('quantity', isLessThan: 10) // Threshold for low stock
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildReportCard(
            title: 'Low Stock Alerts',
            content: const Text('No low stock alerts.'),
          );
        }

        final lowStockProducts = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['name'] ?? 'Unknown',
            'quantity': doc['quantity'] ?? 0,
          };
        }).toList();

        return _buildReportCard(
          title: 'Low Stock Alerts',
          content: Column(
            children: lowStockProducts.map((product) {
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('Quantity: ${product['quantity']}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildReportCard({required String title, required Widget content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D59),
              ),
            ),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryReportsPage extends StatefulWidget {
  const InventoryReportsPage({Key? key}) : super(key: key);

  @override
  State<InventoryReportsPage> createState() => _InventoryReportsPageState();
}

class _InventoryReportsPageState extends State<InventoryReportsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalProducts = 0;
  double totalStockValue = 0.0;
  int lowStockCount = 0;
  List<Map<String, dynamic>> lowStockProducts = [];
  List<Map<String, dynamic>> highDemandProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchInventoryData();
  }

  Future<void> _fetchInventoryData() async {
    try {
      final productsSnapshot = await _firestore.collection('products').get();

      int productCount = 0;
      double stockValue = 0.0;
      int lowStock = 0;
      List<Map<String, dynamic>> lowStockList = [];
      List<Map<String, dynamic>> highDemandList = [];

      for (var doc in productsSnapshot.docs) {
        final product = doc.data();
        productCount++;

        int quantity = product['quantity'] ?? 0;
        double price = product['price'] ?? 0.0;
        int lowStockThreshold = product['lowStockThreshold'] ?? 0;
        String demandForecast = product['demandForecast'] ?? "Unknown";

        stockValue += quantity * price;

        if (quantity <= lowStockThreshold) {
          lowStock++;
          lowStockList.add({
            'name': product['name'],
            'quantity': quantity,
            'threshold': lowStockThreshold,
            'suggestedReorder': lowStockThreshold - quantity + 10,
          });
        }

        if (demandForecast == "High" && quantity <= lowStockThreshold) {
          highDemandList.add({
            'name': product['name'],
            'quantity': quantity,
            'demandForecast': demandForecast,
          });
        }
      }

      setState(() {
        totalProducts = productCount;
        totalStockValue = stockValue;
        lowStockCount = lowStock;
        lowStockProducts = lowStockList;
        highDemandProducts = highDemandList;
      });
    } catch (e) {
      print("Error fetching inventory data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Reports'),
        backgroundColor: const Color(0xFF123D59),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 16.0),
            if (lowStockProducts.isNotEmpty) ...[
              const Text(
                "Low Stock Alerts",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              _buildLowStockList(),
            ],
            const SizedBox(height: 16.0),
            if (highDemandProducts.isNotEmpty) ...[
              const Text(
                "High Demand Products (Low Stock)",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              _buildHighDemandList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF123D59),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overview",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Total Products: $totalProducts",
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Total Stock Value: Rs. ${totalStockValue.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Low Stock Products: $lowStockCount",
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockList() {
    return Column(
      children: lowStockProducts.map((product) {
        return Card(
          child: ListTile(
            title: Text(product['name']),
            subtitle: Text(
              "Quantity: ${product['quantity']}, Threshold: ${product['threshold']}",
            ),
            trailing: Text("Reorder: ${product['suggestedReorder']}"),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHighDemandList() {
    return Column(
      children: highDemandProducts.map((product) {
        return Card(
          child: ListTile(
            title: Text(product['name']),
            subtitle: Text(
              "Demand Forecast: ${product['demandForecast']}, Quantity: ${product['quantity']}",
            ),
          ),
        );
      }).toList(),
    );
  }
}

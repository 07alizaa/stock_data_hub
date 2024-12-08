import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({Key? key}) : super(key: key);

  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> _fetchSupplierData() async {
    DataSnapshot snapshot = await databaseReference.child('suppliers').get();
    if (snapshot.exists) {
      // Process supplier data here
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF123D59),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(),
              const SizedBox(height: 20),
              _buildSuppliersSection(context),
              const SizedBox(height: 20),
              _buildIncomingOrders(context),
              const SizedBox(height: 20),
              _buildDemandForecast(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF123D59),
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallets',
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Select",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
          ),
        ),

      ],
    );
  }

  Widget _buildIconButton(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF123D59),
          radius: 30,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSuppliersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suppliers Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _buildSupplierCard('Supplier A', 'On-time Delivery: 95%', Colors.green),
        _buildSupplierCard('Supplier B', 'On-time Delivery: 80%', Colors.orange),
        _buildSupplierCard('Supplier C', 'On-time Delivery: 60%', Colors.red),
      ],
    );
  }

  Widget _buildSupplierCard(String supplierName, String performance, Color statusColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF123D59),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              supplierName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Icon(Icons.circle, color: statusColor, size: 12),
                const SizedBox(width: 5),
                Text(
                  performance,
                  style: TextStyle(
                    fontSize: 16,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingOrders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage Incoming Orders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text("Filter by status"),
          items: const [
            DropdownMenuItem(value: "Pending", child: Text("Pending")),
            DropdownMenuItem(value: "Confirmed", child: Text("Confirmed")),
            DropdownMenuItem(value: "Shipped", child: Text("Shipped")),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 20),
        _buildOrderCard('Order #001', 'Product A, B, C', 'Pending'),
        _buildOrderCard('Order #002', 'Product D, E', 'Confirmed'),
      ],
    );
  }

  Widget _buildOrderCard(String orderId, String productDetails, String status) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF123D59),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              productDetails,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(status),
                  backgroundColor: status == 'Pending'
                      ? Colors.orange
                      : (status == 'Confirmed' ? Colors.green : Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Confirm Order'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemandForecast(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Demand Forecast',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text("Select date range"),
          items: const [
            DropdownMenuItem(value: "Next 7 Days", child: Text("Next 7 Days")),
            DropdownMenuItem(value: "Next 30 Days", child: Text("Next 30 Days")),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 20),
        _buildPriorityList(),
      ],
    );
  }

  Widget _buildPriorityList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF123D59),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            _buildPriorityItem('Product A', 'High Priority', Colors.red),
            _buildPriorityItem('Product B', 'Medium Priority', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityItem(String productName, String priorityLevel, Color priorityColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            productName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Icon(Icons.priority_high, color: priorityColor),
              const SizedBox(width: 5),
              Text(
                priorityLevel,
                style: TextStyle(
                  fontSize: 16,
                  color: priorityColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


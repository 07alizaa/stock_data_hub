import 'package:flutter/material.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({Key? key}) : super(key: key);

  @override
  _InventoryManagementScreenState createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  // Sample inventory data
  final List<Map<String, dynamic>> _inventory = [
    {'name': 'Widget A', 'stock': 250, 'reorderLevel': 100, 'status': 'Optimal'},
    {'name': 'Widget B', 'stock': 75, 'reorderLevel': 200, 'status': 'Low'},
    {'name': 'Widget C', 'stock': 500, 'reorderLevel': 300, 'status': 'Optimal'},
    {'name': 'Widget D', 'stock': 150, 'reorderLevel': 250, 'status': 'Warning'},
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: const Color(0xFF123D59), // Dark teal color
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action
              _showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the Add Product screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search inventory...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Inventory List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredInventory().length,
                itemBuilder: (context, index) {
                  final item = _filteredInventory()[index];
                  return _buildInventoryCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter inventory based on search query
  List<Map<String, dynamic>> _filteredInventory() {
    if (_searchQuery.isEmpty) {
      return _inventory;
    }
    return _inventory
        .where((item) => item['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // Build individual inventory card
  Widget _buildInventoryCard(Map<String, dynamic> item) {
    Color statusColor;
    switch (item['status']) {
      case 'Low':
        statusColor = Colors.red;
        break;
      case 'Warning':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.green;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xFF123D59), // Blue color for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Item Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color for text
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${item['stock']}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Reorder Level: ${item['reorderLevel']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['status'],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Action Buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Navigate to the Edit Product screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProductScreen(item: item)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Handle delete action
                    _deleteProduct(item);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Delete a product
  void _deleteProduct(Map<String, dynamic> item) {
    setState(() {
      _inventory.remove(item);
    });
  }

  // Show filter dialog (placeholder)
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Inventory'),
          content: const Text('Filter options will go here.'),
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
}

// Add Product Screen
class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Center(
        child: Text('Add Product Form Here'),
      ),
    );
  }
}

// Edit Product Screen
class EditProductScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const EditProductScreen({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Center(
        child: Text('Edit Product Form for ${item['name']}'),
      ),
    );
  }
}

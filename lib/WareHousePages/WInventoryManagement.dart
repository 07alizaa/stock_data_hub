import 'package:flutter/material.dart';
import 'package:stock_data_hub/ProductManagement/UpdateProduct.dart';
import 'package:stock_data_hub/ProductManagement/AddNewProduct.dart'; // Import your UpdateProduct widget

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final List<Map<String, dynamic>> _inventory = [
    {'name': 'Widget A', 'quantity': 250, 'price': 10.0, 'status': 'Optimal'},
    {'name': 'Widget B', 'quantity': 75, 'price': 15.5, 'status': 'Low'},
    {'name': 'Widget C', 'quantity': 500, 'price': 7.25, 'status': 'Optimal'},
    {'name': 'Widget D', 'quantity': 150, 'price': 12.75, 'status': 'Warning'},
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE3),
      body: SafeArea(
        child: _buildInventoryList(),
      ),
      floatingActionButton: _buildAddProductButton(),
    );
  }

  Widget _buildInventoryList() {
    final filteredInventory = _getFilteredInventory();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Manage Your Inventory',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123D59),
            ),
          ),
          const SizedBox(height: 10), // Add spacing between heading and search bar
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredInventory.length,
              itemBuilder: (context, index) {
                return _buildInventoryCard(filteredInventory[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        hintText: 'Search inventory...',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF173A5E), // Teal blue color for the background
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item, int index) {
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF123D59),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'Unknown Item',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Quantity: ${item['quantity'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Price: \$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'] ?? 'Unknown',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showUpdatePage(item, index),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Color(0xFF123D59)),
                  label: const Text(
                    'Update',
                    style: TextStyle(
                      color: Color(0xFF123D59),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () => _confirmDelete(index),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredInventory() {
    if (_searchQuery.isEmpty) return _inventory;
    return _inventory
        .where((item) =>
        item['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildAddProductButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final newProduct = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddNewProduct(),
          ),
        );

        if (newProduct != null) {
          setState(() {
            _inventory.add(newProduct);
          });
        }
      },
      backgroundColor: const Color(0xFFB66A39),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add New Product',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showUpdatePage(Map<String, dynamic> item, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Updateproduct(
          product: item,
          onUpdate: (updatedProduct) {
            setState(() {
              _inventory[index] = updatedProduct;
            });
          },
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _inventory.removeAt(index); // Remove the item from the inventory
              });
              Navigator.of(context).pop(); // Close the dialog after deletion
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
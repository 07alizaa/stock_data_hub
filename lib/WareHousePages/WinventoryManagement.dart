import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_data_hub/ProductManagement/AddNewProduct.dart';
import 'package:stock_data_hub/ProductManagement/UpdateProduct.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No products found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final allProducts = snapshot.data!.docs.map((doc) {
                  return {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  };
                }).toList();

                final filteredProducts = _getFilteredInventory(allProducts);

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return _buildInventoryCard(filteredProducts[index]);
                  },
                );
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
        fillColor: const Color(0xFF173A5E),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  // Widget _buildInventoryCard(Map<String, dynamic> item) {
  //   Color statusColor;
  //   switch (item['status'] ?? 'Optimal') {
  //     case 'Low':
  //       statusColor = Colors.red;
  //       break;
  //     case 'Warning':
  //       statusColor = Colors.orange;
  //       break;
  //     default:
  //       statusColor = Colors.green;
  //   }
  //
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     color: const Color(0xFF123D59),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(15),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             item['name'] ?? 'Unknown Item',
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             'Description: ${item['description'] ?? 'N/A'}',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //           Text(
  //             'Quantity: ${item['quantity'] ?? 'N/A'}',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //           Text(
  //             'Low Stock Threshold: ${item['lowStockThreshold'] ?? 'N/A'}',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //           Text(
  //             'Demand Forecast: ${item['demandForecast'] ?? 'N/A'}',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //           Text(
  //             'Price: \$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //           const SizedBox(height: 10),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () => _showUpdateProductScreen(item),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: const Color(0xFFB66A39),
  //                 ),
  //                 child: const Text(
  //                   'Update',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //               const SizedBox(width: 10),
  //               ElevatedButton(
  //                 onPressed: () => _deleteProduct(item['id']),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.red,
  //                 ),
  //                 child: const Text(
  //                   'Delete',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



  Widget _buildInventoryCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF123D59),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'] ?? 'Unknown Item', // Ensure 'name' is fetched here
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Description: ${product['description'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Quantity: ${product['quantity'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Low Stock Threshold: ${product['lowStockThreshold'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Demand Forecast: ${product['demandForecast'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Price: \$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _showUpdateProductScreen(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB66A39),
                  ),
                  child: const Text('Update'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _deleteProduct(product['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _deleteProduct(String productId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestore.collection('products').doc(productId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting product')),
        );
      }
    }
  }

  void _showUpdateProductScreen(Map<String, dynamic> product) async {
    final updatedProduct = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateProduct(
          product: product,
          onUpdate: (updatedProduct) {
            setState(() {});
          },
        ),
      ),
    );

    if (updatedProduct != null) {
      // No need to fetch manually; StreamBuilder will automatically update
    }
  }

  List<Map<String, dynamic>> _getFilteredInventory(
      List<Map<String, dynamic>> allProducts) {
    if (_searchQuery.isEmpty) return allProducts;
    return allProducts
        .where((item) =>
    item['name']?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
        false)
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
          // StreamBuilder automatically updates the list.
        }
      },
      backgroundColor: const Color(0xFFB66A39),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Add New Product'),
    );
  }
}

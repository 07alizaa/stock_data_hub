import 'package:flutter/material.dart';
import 'AddProduct.dart'; // Import the AddProductPage

class InventoryManagementPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'Product A', 'quantity': 500, 'price': 1100},
    {'name': 'Product B', 'quantity': 500, 'price': 1100},
    {'name': 'Product C', 'quantity': 500, 'price': 1100},
    {'name': 'Product D', 'quantity': 500, 'price': 1100},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddProductPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123D59),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Add New Products'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Filter Products action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123D59),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Filter Products'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    color: const Color(0xFF123D59),
                    child: ListTile(
                      title: Text(
                        product['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Quantity: ${product['quantity']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        'Rs.${product['price']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Delete Product action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123D59),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Delete Product'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Update Products action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123D59),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Update Products'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

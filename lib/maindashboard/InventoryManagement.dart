import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryManagementPage extends StatefulWidget {
  @override
  State<InventoryManagementPage> createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch products from Firebase Firestore
  void _fetchProducts() async {
    try {
      final querySnapshot = await _firestore.collection('products').get();
      final List<Map<String, dynamic>> fetchedProducts = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'quantity': doc['quantity'],
          'price': doc['price'],
        };
      }).toList();

      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

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
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filteredProducts = products
                      .where((product) =>
                      product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Add Product Button
            ElevatedButton(
              onPressed: _showAddProductDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123D59),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Add New Product'),
            ),
            const SizedBox(height: 16.0),

            // Filter Products Button
            ElevatedButton(
              onPressed: _showFilterDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123D59),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Filter Products'),
            ),
            const SizedBox(height: 16.0),

            // Product List
            Expanded(
              child: filteredProducts.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
              )
                  : const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog for adding a new product
  void _showAddProductDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                final int? quantity = int.tryParse(quantityController.text.trim());
                final double? price = double.tryParse(priceController.text.trim());

                if (name.isEmpty || quantity == null || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")),
                  );
                  return;
                }

                try {
                  await _firestore.collection('products').add({
                    'name': name,
                    'quantity': quantity,
                    'price': price,
                  });

                  _fetchProducts(); // Refresh the product list
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product added successfully")),
                  );
                } catch (e) {
                  print("Error adding product: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to add product")),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Dialog for filtering products
  void _showFilterDialog() {
    final TextEditingController minQuantityController = TextEditingController();
    final TextEditingController maxQuantityController = TextEditingController();
    final TextEditingController minPriceController = TextEditingController();
    final TextEditingController maxPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Products'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: minQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min Quantity'),
                ),
                TextField(
                  controller: maxQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max Quantity'),
                ),
                TextField(
                  controller: minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min Price'),
                ),
                TextField(
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filteredProducts = products; // Reset to all products
                });
                Navigator.pop(context);
              },
              child: const Text('Clear Filters'),
            ),
            TextButton(
              onPressed: () {
                final int? minQuantity = int.tryParse(minQuantityController.text);
                final int? maxQuantity = int.tryParse(maxQuantityController.text);
                final double? minPrice = double.tryParse(minPriceController.text);
                final double? maxPrice = double.tryParse(maxPriceController.text);

                setState(() {
                  filteredProducts = products.where((product) {
                    final matchesQuantity = (minQuantity == null || product['quantity'] >= minQuantity) &&
                        (maxQuantity == null || product['quantity'] <= maxQuantity);
                    final matchesPrice = (minPrice == null || product['price'] >= minPrice) &&
                        (maxPrice == null || product['price'] <= maxPrice);
                    return matchesQuantity && matchesPrice;
                  }).toList();
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

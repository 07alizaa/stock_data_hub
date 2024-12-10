import 'package:flutter/material.dart';
import 'addproduct.dart'; // Importing AddProductPage

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, String>> products = []; // This will store the product list.
  List<Map<String, String>> filteredProducts = []; // This will store the filtered list based on the search.

  // Initial categories
  List<String> categories = [
    "Electronics",
    "Clothing",
    "Groceries",
    "Furniture",
    "Beauty & Health",
    "Sports & Outdoors",
    "Automotive",
    "Juice",
    "Books"
  ]; // Expanded categories list

  // Define category icons for the new categories
  final Map<String, IconData> categoryIcons = {
    "Electronics": Icons.tv,
    "Clothing": Icons.checkroom,
    "Groceries": Icons.local_grocery_store,
    "Furniture": Icons.chair,
    "Beauty & Health": Icons.face,
    "Sports & Outdoors": Icons.sports_baseball,
    "Automotive": Icons.directions_car,
    "Juice": Icons.local_drink,
    "Books": Icons.book,
  };

  TextEditingController searchController = TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    filteredProducts = products; // Initially, display all products
    searchController.addListener(_filterProducts); // Listen for changes in the search input
  }

  // Function to filter products based on search query
  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        centerTitle: true,
        title: const Text('Products'),
        automaticallyImplyLeading: false, // To remove the back button
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(90), // Adjust the height of the AppBar for better spacing
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Add some padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.black), // Set text color to black
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    hintStyle: TextStyle(color: Colors.black), // Set hint text color to black
                    filled: true,
                    fillColor: Colors.white, // Set background color of the search bar to white
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Set outer border color to black
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.black), // Set icon color to black
                  ),
                ),
                SizedBox(height: 10),
                // Display total products
                Text(
                  'Total Products: ${products.length}', // Show the total number of products
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(  // Add SingleChildScrollView here to handle overflow
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              // Categories section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add Categories Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addCategoryDialog,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Display categories
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: categories.map((category) {
                        return GestureDetector(
                          onLongPress: () {
                            _showCategoryUpdateDeleteOptions(context, category);
                          },
                          child: Chip(
                            label: Text(category),
                            avatar: Icon(categoryIcons[category] ?? Icons.category),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Display products in a ListView
              ListView.builder(
                shrinkWrap: true,  // This ensures the ListView doesn't take up more space than necessary
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onLongPress: () {
                      _showUpdateDeleteOptions(context, product, index);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          product['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the product name bold
                          ),
                        ),
                        subtitle: Text('Quantity: ${product['quantity']} | Price: ${product['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Display the category icon
                            Icon(categoryIcons[product['category']] ?? Icons.help),
                            const SizedBox(width: 10),
                            Text(product['category']!),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(
                categories: categories,
              ),
            ),
          );
          if (newProduct != null) {
            setState(() {
              products.add(newProduct);
              filteredProducts = products; // Reset the filtered products list after adding a new product
            });
          }
        },
        backgroundColor: const Color(0xFF123D59),
        child: const Icon(Icons.add, color: Colors.white), // Set "+" icon color to white
      ),
    );
  }

  // Show the Update/Delete options for the product
  void _showUpdateDeleteOptions(BuildContext context, Map<String, String> product, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an action'),
          content: const Text('What would you like to do with this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateProduct(product, index);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteProduct(index);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Show the Update/Delete options for the category
  void _showCategoryUpdateDeleteOptions(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an action'),
          content: const Text('What would you like to do with this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteCategory(category);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Handle category addition
  void _addCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController categoryController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
                  setState(() {
                    categories.add(newCategory);
                    categoryIcons[newCategory] = Icons.category; // Default icon for the new category
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Update product logic
  void _updateProduct(Map<String, String> product, int index) async {
    final updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          categories: categories,
          product: product,
        ),
      ),
    );
    if (updatedProduct != null) {
      setState(() {
        products[index] = updatedProduct;
        filteredProducts = products; // Reset filtered products
      });
    }
  }

  // Delete product logic
  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      filteredProducts = products; // Reset filtered products list after deletion
    });
  }

  // Delete category logic
  void _deleteCategory(String category) {
    setState(() {
      categories.remove(category);
      categoryIcons.remove(category); // Remove associated icon for the category
    });
  }
}

import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final productNameController = TextEditingController();
  final initialPriceController = TextEditingController();
  final todaysPriceController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    initialPriceController.dispose();
    todaysPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Column(
                    children: const [
                      Icon(Icons.bar_chart, size: 60, color: Color(0xFF123D59)),
                      SizedBox(height: 10),
                      Text(
                        'STOCK DATA HUB',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123D59),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Update Product Information\nUpdate Product here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Product Name Field
                const Text(
                  'Product Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: productNameController,
                  decoration: inputDecoration('Enter product name'),
                ),
                const SizedBox(height: 20),
                // Initial Product Price Field
                const Text(
                  'Initial Product Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: initialPriceController,
                  decoration: inputDecoration('Enter initial price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                // Today's Product Price Field
                const Text(
                  'Today\'s Product Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: todaysPriceController,
                  decoration: inputDecoration('Enter today\'s price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product updated successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500), // Orange button
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth < 400 ? 12 : 15, // Adaptive padding
                      ),
                    ),
                    child: Text(
                      'Update Product Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth < 400 ? 14 : 16, // Adaptive font size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF5F5DC), // Beige color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}

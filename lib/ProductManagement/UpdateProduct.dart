import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onUpdate;

  const UpdateProduct({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController lowStockController;
  late TextEditingController demandForecastController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from the provided product map
    nameController = TextEditingController(text: widget.product['name']);
    quantityController =
        TextEditingController(text: widget.product['quantity'].toString());
    descriptionController =
        TextEditingController(text: widget.product['description'] ?? '');
    priceController =
        TextEditingController(text: widget.product['price'].toString());
    lowStockController =
        TextEditingController(text: widget.product['lowStockThreshold'].toString());
    demandForecastController =
        TextEditingController(text: widget.product['demandForecast'] ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    lowStockController.dispose();
    demandForecastController.dispose();
    super.dispose();
  }

  void _updateProductInFirestore() async {
    final updatedProduct = {
      'name': nameController.text.trim(),
      'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
      'description': descriptionController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      'lowStockThreshold': int.tryParse(lowStockController.text.trim()) ?? 0,
      'demandForecast': demandForecastController.text.trim(),

      // Optionally recalculate 'status'
      // 'status': int.tryParse(quantityController.text.trim()) ?? 0 <=
      //     int.tryParse(lowStockController.text.trim()) ?? 0
      //     ? 'Low'
      //     : 'Optimal',
    };

    try {
      // Update the product in Firestore using the product ID
      await _firestore.collection('products').doc(widget.product['id']).update(updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );

      widget.onUpdate(updatedProduct); // Callback to update the UI
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE3),
      appBar: AppBar(
        title: const Text('Update Product', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF123D59),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildFormContainer()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF8EFE3),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Image.asset(
            'assets/logo.png',
            height: 100,
          ),
          const SizedBox(height: 10),
          const Text(
            "STOCK DATA HUB",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD47019),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF173A5E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              "Update Product Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Product Name", nameController),
            _buildTextField("Product Quantity", quantityController, isNumeric: true),
            _buildTextField("Product Description", descriptionController),
            _buildTextField("Product Price", priceController, isNumeric: true),
            _buildTextField("Low Stock Threshold", lowStockController, isNumeric: true),
            _buildTextField("Demand Forecast", demandForecastController),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateProductInFirestore();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB66A39),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) =>
        value!.isEmpty ? 'Please enter a valid $label' : null,
      ),
    );
  }
}

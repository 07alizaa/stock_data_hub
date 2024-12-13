import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String productName = '';
  int productQuantity = 0;
  String productDescription = '';
  double productPrice = 0.0;
  int lowStockThreshold = 0;
  String demandForecast = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE3),
      appBar: AppBar(
        title: const Text(
          "Add New Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF123D59),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildTextField(
                  "Product Name",
                  "Enter product name",
                      (value) => productName = value!,
                  validator: (value) =>
                  value!.isEmpty ? "Please enter product name" : null,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "Product Quantity",
                  "Enter product quantity",
                      (value) => productQuantity = int.parse(value!),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter product quantity" : null,
                  isNumeric: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "Product Description",
                  "Enter product description",
                      (value) => productDescription = value!,
                  validator: (value) =>
                  value!.isEmpty ? "Please enter product description" : null,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "Product Price",
                  "Enter product price",
                      (value) => productPrice = double.parse(value!),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter product price" : null,
                  isNumeric: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "Low Stock Threshold",
                  "Enter low stock threshold",
                      (value) => lowStockThreshold = int.parse(value!),
                  validator: (value) =>
                  value!.isEmpty
                      ? "Please enter low stock threshold"
                      : null,
                  isNumeric: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "Demand Forecast",
                  "Enter demand forecast",
                      (value) => demandForecast = value!,
                  validator: (value) =>
                  value!.isEmpty ? "Please enter demand forecast" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB66A39),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText,
      String hintText,
      Function(String?) onSaved, {
        required String? Function(String?) validator,
        bool isNumeric = false,
      }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Add product to the 'products' collection
        DocumentReference productRef = await _firestore.collection('products')
            .add({
          'name': productName,
          'quantity': productQuantity,
          'description': productDescription,
          'price': productPrice,
          'lowStockThreshold': lowStockThreshold,
          'demandForecast': demandForecast,
          'status': productQuantity <= lowStockThreshold ? 'Low' : 'Optimal',
        });

        // Log the action to the product's 'history' sub-collection
        await productRef.collection('history').add({
          'action': 'added',
          'timestamp': FieldValue.serverTimestamp(),
          'details': {
            'name': productName,
            'quantity': productQuantity,
            'description': productDescription,
            'price': productPrice,
          },
        });

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
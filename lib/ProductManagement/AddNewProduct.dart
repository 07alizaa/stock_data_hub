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
    final size = MediaQuery.of(context).size;

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
        child: Column(
          children: [
            _buildHeader(size),
            Expanded(
              child: _buildForm(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/logo.png',
            height: size.height * 0.15,
          ),
          SizedBox(height: size.height * 0.01),
          const Text(
            "STOCK DATA HUB",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB66A39),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(Size size) {
    return Container(
      width: size.width,
      decoration: const BoxDecoration(
        color: Color(0xFF173A5E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(size.width * 0.05),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              "Product Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            _buildTextField(
              "Product Name",
              "Enter product name",
                  (value) => productName = value!.trim(),
              validator: (value) => value!.isEmpty ? "Please enter product name" : null,
            ),
            SizedBox(height: size.height * 0.015),
            _buildTextField(
              "Product Quantity",
              "Enter product quantity",
                  (value) => productQuantity = int.parse(value!),
              validator: (value) => value!.isEmpty ? "Please enter product quantity" : null,
              isNumeric: true,
            ),
            SizedBox(height: size.height * 0.015),
            _buildTextField(
              "Product Description",
              "Enter product description",
                  (value) => productDescription = value!,
              validator: (value) => value!.isEmpty ? "Please enter product description" : null,
            ),
            SizedBox(height: size.height * 0.015),
            _buildTextField(
              "Product Price",
              "Enter product price",
                  (value) => productPrice = double.parse(value!),
              validator: (value) => value!.isEmpty ? "Please enter product price" : null,
              isNumeric: true,
            ),
            SizedBox(height: size.height * 0.015),
            _buildTextField(
              "Low Stock Threshold",
              "Enter low stock threshold",
                  (value) => lowStockThreshold = int.parse(value!),
              validator: (value) => value!.isEmpty ? "Please enter low stock threshold" : null,
              isNumeric: true,
            ),
            SizedBox(height: size.height * 0.015),
            _buildTextField(
              "Demand Forecast",
              "Enter demand forecast",
                  (value) => demandForecast = value!,
              validator: (value) => value!.isEmpty ? "Please enter demand forecast" : null,
            ),
            SizedBox(height: size.height * 0.03),
            _buildSaveButton(size),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText,
      String hintText,
      void Function(String?) onSaved, {
        required String? Function(String?) validator,
        bool isNumeric = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF8EFE3),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildSaveButton(Size size) {
    return Center(
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB66A39),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.2,
            vertical: size.height * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Save",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (productName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product name cannot be empty')),
        );
        return;
      }

      try {
        await _firestore.collection('products').add({
          'name': productName,
          'quantity': productQuantity,
          'description': productDescription,
          'price': productPrice,
          'lowStockThreshold': lowStockThreshold,
          'demandForecast': demandForecast,
          'status': productQuantity <= lowStockThreshold ? 'Low' : 'Optimal',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      }
    }
  }
}

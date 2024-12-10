import 'package:flutter/material.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  int productQuantity = 0;
  String productDescription = '';
  double productPrice = 0.0;
  int lowStockThreshold = 0;
  int demandForecast = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE3),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with Logo and Title
            _buildHeader(),
            // Form Section
            Expanded(
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
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
              color: Color(0xFFB66A39), // Brown color
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
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
            // Form Title
            const Text(
              "Product Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Add New Product here.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Product Name Field
            _buildTextField("Product Name", (value) {
              if (value!.isEmpty) return 'Please enter the product name';
              return null;
            }, (value) {
              productName = value!;
            }),
            const SizedBox(height: 15),
            // Product Quantity Field
            _buildTextField("Product Quantity", (value) {
              if (value!.isEmpty) return 'Please enter the product quantity';
              return null;
            }, (value) {
              productQuantity = int.parse(value!);
            }, isNumeric: true),
            const SizedBox(height: 15),
            // Product Description Field
            _buildTextField("Product Description", (value) {
              if (value!.isEmpty) return 'Please enter the product description';
              return null;
            }, (value) {
              productDescription = value!;
            }),
            const SizedBox(height: 15),
            // Product Price Field
            _buildTextField("Product Price", (value) {
              if (value!.isEmpty) return 'Please enter the product price';
              return null;
            }, (value) {
              productPrice = double.parse(value!);
            }, isNumeric: true),
            const SizedBox(height: 15),
            // Low Stock Threshold Field
            _buildTextField("Low Stock Threshold", (value) {
              if (value!.isEmpty) return 'Please enter the low stock threshold';
              return null;
            }, (value) {
              lowStockThreshold = int.parse(value!);
            }, isNumeric: true),
            const SizedBox(height: 15),
            // Demand Forecast Field
            _buildTextField("Demand Forecast", (value) {
              if (value!.isEmpty) return 'Please enter the demand forecast';
              return null;
            }, (value) {
              demandForecast = int.parse(value!);
            }, isNumeric: true),
            const SizedBox(height: 30),
            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText,
      String? Function(String?) validator,
      void Function(String?) onSaved, {
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
            filled: true,
            fillColor: const Color(0xFFF8EFE3), // Light beige background
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB66A39), // Button color
          padding:
          const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Size
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

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save product details (add your logic here)
      print(
        'Product added: $productName, Quantity: $productQuantity, Description: $productDescription, Price: $productPrice, Low Stock Threshold: $lowStockThreshold, Demand Forecast: $demandForecast',
      );
    }
  }
}
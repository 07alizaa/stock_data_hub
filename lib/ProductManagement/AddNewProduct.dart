import 'package:flutter/material.dart';

class Addnewproduct extends StatefulWidget {
  const Addnewproduct({Key? key}) : super(key: key);

  @override
  State<Addnewproduct> createState() => _AddnewproductState();
}

class _AddnewproductState extends State<Addnewproduct> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  int productQuantity = 0;
  String productDescription = '';
  double productPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123D59),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField('Product Name', (value) {
                  if (value!.isEmpty) return 'Please enter the product name';
                  return null;
                }, (value) {
                  productName = value!;
                }),
                SizedBox(height: 20),
                _buildTextField('Product Quantity', (value) {
                  if (value!.isEmpty) return 'Please enter the product quantity';
                  return null;
                }, (value) {
                  productQuantity = int.parse(value!);
                }, isNumeric: true),
                SizedBox(height: 20),
                _buildTextField('Product Description', (value) {
                  if (value!.isEmpty) return 'Please enter the product description';
                  return null;
                }, (value) {
                  productDescription = value!;
                }),
                SizedBox(height: 20),
                _buildTextField('Product Price', (value) {
                  if (value!.isEmpty) return 'Please enter the product price';
                  return null;
                }, (value) {
                  productPrice = double.parse(value!);
                }, isNumeric: true),
                SizedBox(height: 40),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, String? Function(String?) validator, void Function(String?) onSaved, {bool isNumeric = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0xFF123D59).withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProduct,
      child: Text('Save'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF123D59), // Use theme color
        iconColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Add logic to save product details to database or perform other actions.
      print('Product added: $productName, Quantity: $productQuantity, Description: $productDescription, Price: $productPrice');
    }
  }
}

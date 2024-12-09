import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import to use TextInputFormatter

class AddProductPage extends StatefulWidget {
  final Map<String, String>? product; // For updating existing products
  final List<String> categories; // Categories passed from ProductPage

  const AddProductPage({super.key, this.product, required this.categories});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedUnit;

  List<String> units = ["Kg", "Litre", "Piece"]; // Example units
  final int lowStockThreshold = 10; // Set the low stock threshold value

  @override
  void initState() {
    super.initState();
    // If we are editing an existing product, populate the fields
    if (widget.product != null) {
      nameController.text = widget.product!['name']!;
      quantityController.text = widget.product!['quantity']!;
      priceController.text = widget.product!['price']!;
      descriptionController.text = widget.product!['description']!;
      selectedCategory = widget.product!['category'];
      selectedUnit = widget.product!['unit'];
    }
  }

  // Check if the quantity is low
  bool _isLowStock() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    return quantity < lowStockThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: Text(widget.product == null ? 'Add Product' : 'Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: const Text('Select Category'),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Please enter product name' : null,
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final newText = newValue.text;
                    if (newText.isNotEmpty) {
                      return TextEditingValue(
                        text: newText[0].toUpperCase() + newText.substring(1),
                        selection: TextSelection.collapsed(offset: newText.length),
                      );
                    }
                    return newValue;
                  }),
                ],
              ),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter quantity' : null,
                onChanged: (_) => setState(() {}), // Trigger stock check when quantity changes
              ),
              // Display low stock warning if quantity is below threshold
              if (_isLowStock())
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Low Stock Warning! Quantity is below $lowStockThreshold.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                hint: const Text('Select Unit'),
                onChanged: (newValue) {
                  setState(() {
                    selectedUnit = newValue;
                  });
                },
                items: units.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                validator: (value) => value == null ? null : null, // No validation for unit
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter price' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123D59),
                  foregroundColor: Colors.white, // Set the text color to white
                ),
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create or update product map
      Map<String, String> product = {
        'name': nameController.text,
        'quantity': quantityController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'category': selectedCategory!,
        'unit': selectedUnit ?? "", // Unit is optional
      };

      // Return the product map to the previous screen (either to add or update)
      Navigator.pop(context, product);
    }
  }
}

import 'package:flutter/material.dart';

class Updateproduct extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onUpdate;

  const Updateproduct({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  State<Updateproduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<Updateproduct> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController lowStockController;
  late TextEditingController demandForecastController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current product values
    nameController = TextEditingController(text: widget.product['name']);
    quantityController =
        TextEditingController(text: widget.product['quantity'].toString());
    descriptionController =
        TextEditingController(text: widget.product['description']);
    priceController =
        TextEditingController(text: widget.product['price'].toString());
    lowStockController =
        TextEditingController(text: widget.product['lowStockThreshold'].toString());
    demandForecastController =
        TextEditingController(text: widget.product['demandForecast'].toString());
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    lowStockController.dispose();
    demandForecastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Product"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lowStockController,
              decoration:
              const InputDecoration(labelText: 'Low Stock Threshold'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: demandForecastController,
              decoration:
              const InputDecoration(labelText: 'Demand Forecast'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Validate and update product data
            final updatedProduct = {
              'name': nameController.text,
              'quantity': int.tryParse(quantityController.text) ?? 0,
              'description': descriptionController.text,
              'price': double.tryParse(priceController.text) ?? 0.0,
              'lowStockThreshold': int.tryParse(lowStockController.text) ?? 0,
              'demandForecast': int.tryParse(demandForecastController.text) ?? 0,
              'status': widget.product['status'], // Preserve original status
            };
            widget.onUpdate(updatedProduct);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

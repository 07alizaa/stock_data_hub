import 'package:flutter/material.dart';

class StockManagement extends StatefulWidget {
  @override
  _StockManagementState createState() => _StockManagementState();
}

class _StockManagementState extends State<StockManagement> {
  final _formKey = GlobalKey<FormState>();
  String selectedProduct = '';
  int dispatchedQuantity = 0;
  String destination = '';
  String dispatchDate = '';
  String notes = '';

  // Dummy data for inventory products
  final List<String> inventoryProducts = [
    'Product A',
    'Product B',
    'Product C',
  ];

  // List to hold outgoing stock records
  final List<Map<String, dynamic>> outgoingStockRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59), // Same blue as form background
        title: const Text(
          'Stock Management',
          style: TextStyle(color: Colors.white), // White app bar text
        ),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8), // Beige background
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form to record outgoing stock
                _buildForm(),
                const SizedBox(height: 20),
                // List of outgoing stock records
                _buildOutgoingStockList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 4,
        color: const Color(0xFF123D59), // Same blue as the app bar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Product Selector
              DropdownButtonFormField<String>(
                value: selectedProduct.isNotEmpty ? selectedProduct : null,
                decoration: InputDecoration(
                  labelText: 'Select Product',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF123D59), // Dropdown matches card color
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
                dropdownColor: const Color(0xFF123D59), // Dropdown menu color
                items: inventoryProducts.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(
                      product,
                      style: const TextStyle(color: Colors.white), // White text
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProduct = value!;
                  });
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select a product' : null,
              ),
              const SizedBox(height: 10),

              // Quantity Field
              _buildTextField(
                'Dispatched Quantity',
                    (value) {
                  dispatchedQuantity = int.tryParse(value!) ?? 0;
                },
                TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Destination Field
              _buildTextField(
                'Destination (e.g., Supplier Name)',
                    (value) {
                  destination = value!;
                },
                TextInputType.text,
              ),
              const SizedBox(height: 10),

              // Dispatch Date Field
              _buildTextField(
                'Dispatch Date (YYYY-MM-DD)',
                    (value) {
                  dispatchDate = value!;
                },
                TextInputType.datetime,
              ),
              const SizedBox(height: 10),

              // Notes Field
              _buildTextField(
                'Notes (Optional)',
                    (value) {
                  notes = value!;
                },
                TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: _saveOutgoingStock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726), // Orange button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Record',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      Function(String?) onSaved,
      TextInputType inputType,
      ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF123D59), // Same blue as form background
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
      ),
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white), // White input text
      onChanged: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }

  Widget _buildOutgoingStockList() {
    return SizedBox(
      height: 200, // Adjustable height
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: outgoingStockRecords.length,
            itemBuilder: (context, index) {
              final record = outgoingStockRecords[index];
              return ListTile(
                title: Text('Product: ${record['product']}'),
                subtitle: Text(
                  'Quantity: ${record['quantity']}\n'
                      'Destination: ${record['destination']}\n'
                      'Date: ${record['date']}\n'
                      'Notes: ${record['notes']}',
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _saveOutgoingStock() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        outgoingStockRecords.add({
          'product': selectedProduct,
          'quantity': dispatchedQuantity,
          'destination': destination,
          'date': dispatchDate,
          'notes': notes,
        });

        // Reset form fields
        selectedProduct = '';
        dispatchedQuantity = 0;
        destination = '';
        dispatchDate = '';
        notes = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock record added successfully!')),
      );
    }
  }
}

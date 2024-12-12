import 'package:flutter/material.dart';

class TasksManagement extends StatefulWidget {
  @override
  _TasksManagementState createState() => _TasksManagementState();
}

class _TasksManagementState extends State<TasksManagement> {
  final _formKey = GlobalKey<FormState>();
  String selectedProduct = '';
  int dispatchedQuantity = 0;
  String destination = '';
  String dispatchDate = '';
  String notes = '';
  String status = 'Pending';
  String priority = 'Normal Priority';

  // Dummy data for inventory products
  final List<String> inventoryProducts = ['Product A', 'Product B', 'Product C'];

  // List to hold outgoing stock records
  final List<Map<String, dynamic>> outgoingStockRecords = [];

  // Status filter
  String statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text(
          'Stock Management',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8), // Beige background
        child: Column(
          children: [
            // Filter dropdown below AppBar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFilterDropdown(),
            ),
            // Wrapping Form and List in an expandable layout
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildForm(),
                      const SizedBox(height: 20),
                      _buildOutgoingStockList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 4,
      color: const Color(0xFF123D59), // Blue background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Product Selector
              DropdownButtonFormField<String>(
                value: selectedProduct.isNotEmpty ? selectedProduct : null,
                decoration: const InputDecoration(
                  labelText: 'Select Product',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors.white,
                items: inventoryProducts.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product),
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
              _buildTextField('Dispatched Quantity', (value) {
                dispatchedQuantity = int.tryParse(value!) ?? 0;
              }, TextInputType.number),
              const SizedBox(height: 10),

              // Destination Field
              _buildTextField('Destination (e.g., Supplier Name)', (value) {
                destination = value!;
              }, TextInputType.text),
              const SizedBox(height: 10),

              // Dispatch Date Field
              _buildTextField('Dispatch Date (YYYY-MM-DD)', (value) {
                dispatchDate = value!;
              }, TextInputType.datetime),
              const SizedBox(height: 10),

              // Priority Field
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                items: ['Normal Priority', 'High Priority']
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Status Field
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'In Progress', 'Dispatched']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveOutgoingStock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726), // Orange button
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
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: inputType,
      onChanged: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButtonFormField<String>(
      value: statusFilter,
      decoration: const InputDecoration(
        labelText: 'Filter by Status',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
      items: ['All', 'Pending', 'In Progress', 'Dispatched']
          .map((filter) => DropdownMenuItem(
        value: filter,
        child: Text(filter),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          statusFilter = value!;
        });
      },
    );
  }

  Widget _buildOutgoingStockList() {
    // Filter records based on the selected filter
    final filteredRecords = outgoingStockRecords.where((record) {
      if (statusFilter == 'All') return true;
      return record['status'] == statusFilter;
    }).toList();

    return filteredRecords.isEmpty && outgoingStockRecords.isNotEmpty
        ? Center(
      child: Text(
        'No records found for the selected filter.',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    )
        : outgoingStockRecords.isEmpty
        ? Center(
      child: Text(
        'No records added yet. Start by adding a record.',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    )
        : ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text('Product: ${record['product']}'),
            subtitle: Text(
              'Quantity: ${record['quantity']}\n'
                  'Destination: ${record['destination']}\n'
                  'Date: ${record['date']}\n'
                  'Priority: ${record['priority']}\n'
                  'Status: ${record['status']}',
            ),
          ),
        );
      },
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
          'priority': priority,
          'status': status,
        });

        // Reset form fields
        selectedProduct = '';
        dispatchedQuantity = 0;
        destination = '';
        dispatchDate = '';
        priority = 'Normal Priority';
        status = 'Pending';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock record added successfully!')),
      );
    }
  }
}

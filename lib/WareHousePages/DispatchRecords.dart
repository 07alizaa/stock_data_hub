import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DispatchFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product; // Optional: For dispatching a specific product

  const DispatchFormScreen({Key? key, this.product}) : super(key: key);

  @override
  _DispatchFormScreenState createState() => _DispatchFormScreenState();
}

class _DispatchFormScreenState extends State<DispatchFormScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TabController? _tabController;

  // Dispatch Form Fields
  int dispatchedQuantity = 0;
  String supplierName = '';
  DateTime? dispatchDate;
  String priority = 'Normal Priority';

  // Filter for Dispatch Records
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text('Dispatch Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add, color: Colors.white), text: "Dispatch Form"),
            Tab(icon: Icon(Icons.list, color: Colors.white), text: "Dispatch Records"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDispatchForm(), // Dispatch Form Tab
          _buildDispatchRecords(), // Dispatch Records Tab
        ],
      ),
    );
  }

  // Dispatch Form UI
  Widget _buildDispatchForm() {
    return Container(
      color: const Color(0xFFF5E8D8),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              widget.product != null
                  ? 'Available Quantity: ${widget.product!['quantity']}'
                  : 'No product selected',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dispatched Quantity
            _buildTextField(
              'Dispatched Quantity',
              'Enter quantity to dispatch',
                  (value) => dispatchedQuantity = int.tryParse(value!) ?? 0,
              TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Supplier Name
            _buildTextField(
              'Supplier Name',
              'Enter supplier name',
                  (value) => supplierName = value!,
              TextInputType.text,
            ),
            const SizedBox(height: 10),

            // Dispatch Date Picker
            InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                setState(() {
                  dispatchDate = selectedDate;
                });
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Dispatch Date',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  dispatchDate != null
                      ? '${dispatchDate!.toLocal()}'.split(' ')[0]
                      : 'Select a date',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Priority Dropdown
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
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveDispatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Dispatch',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dispatch Records UI
  Widget _buildDispatchRecords() {
    return Container(
      color: const Color(0xFFF5E8D8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              items: ['All', 'Pending', 'Completed']
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getDispatchRecordsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No dispatch records found.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }

                final records = snapshot.data!.docs.map((doc) {
                  return {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  };
                }).toList();

                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          record['product'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          'Status: ${record['status']}\nQuantity: ${record['quantity']}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        trailing: Icon(
                          record['status'] == 'Completed'
                              ? Icons.check_circle
                              : Icons.hourglass_top,
                          color: record['status'] == 'Completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getDispatchRecordsStream() {
    if (selectedStatus == 'All') {
      return _firestore.collection('dispatchRecords').snapshots();
    } else {
      return _firestore
          .collection('dispatchRecords')
          .where('status', isEqualTo: selectedStatus)
          .snapshots();
    }
  }

  Widget _buildTextField(String label, String hintText,
      Function(String?) onSaved, TextInputType inputType) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
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

  void _saveDispatch() async {
    if (_formKey.currentState!.validate()) {
      if (dispatchDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a dispatch date')),
        );
        return;
      }

      if (widget.product != null &&
          dispatchedQuantity > widget.product!['quantity']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient stock for dispatch')),
        );
        return;
      }

      await _firestore.collection('dispatchRecords').add({
        'product': widget.product?['name'] ?? 'Unknown Product',
        'quantity': dispatchedQuantity,
        'supplier': supplierName,
        'date': dispatchDate!.toLocal().toString().split(' ')[0],
        'priority': priority,
        'status': 'Pending',
      });

      if (widget.product != null) {
        await _firestore.collection('products').doc(widget.product!['id']).update({
          'quantity': widget.product!['quantity'] - dispatchedQuantity,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispatch saved successfully!')),
      );

      // Reset the form
      setState(() {
        dispatchedQuantity = 0;
        supplierName = '';
        dispatchDate = null;
        priority = 'Normal Priority';
      });
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart'; // For Firebase Database integration
// import 'ProductTable.dart'; // Import the ProductTable widget
//
// class TransactionPage extends StatefulWidget {
//   @override
//   _TransactionPageState createState() => _TransactionPageState();
// }
//
// class _TransactionPageState extends State<TransactionPage> {
//   String? entryType;
//   String? selectedSupplier;
//   TextEditingController remarksController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   List<Map<String, dynamic>> addedProducts = [];
//   List<String> suppliers = ["Supplier A", "Supplier B", "Supplier C"];
//
//   TextEditingController productNameController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//
//   final DatabaseReference _database = FirebaseDatabase.instance.ref().child('transactions');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Transaction'),
//         backgroundColor: const Color(0xFF123D59),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField<String>(
//               value: entryType,
//               hint: const Text('Select Entry Type'),
//               onChanged: (newValue) {
//                 setState(() {
//                   entryType = newValue;
//                 });
//               },
//               items: ["Inward", "Outward"].map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 10),
//
//             DropdownButtonFormField<String>(
//               value: selectedSupplier,
//               hint: const Text('Select Supplier'),
//               onChanged: (newValue) {
//                 setState(() {
//                   selectedSupplier = newValue;
//                 });
//               },
//               items: suppliers.map((supplier) {
//                 return DropdownMenuItem(
//                   value: supplier,
//                   child: Text(supplier),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 10),
//
//             TextField(
//               controller: remarksController,
//               decoration: const InputDecoration(
//                 labelText: 'Remarks',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             TextField(
//               controller: productNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Product Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             TextField(
//               controller: quantityController,
//               decoration: const InputDecoration(
//                 labelText: 'Quantity',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 10),
//
//             TextField(
//               controller: priceController,
//               decoration: const InputDecoration(
//                 labelText: 'Price',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: _addProduct,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF123D59),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text("Add Product"),
//             ),
//             const SizedBox(height: 20),
//
//             if (addedProducts.isNotEmpty)
//               ProductTable(addedProducts: addedProducts),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: _saveTransactionToFirebase,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF123D59),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text("Save Transaction"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _addProduct() {
//     final productName = productNameController.text;
//     final quantity = quantityController.text;
//     final price = priceController.text;
//
//     if (productName.isNotEmpty &&
//         quantity.isNotEmpty &&
//         price.isNotEmpty &&
//         entryType != null &&
//         selectedSupplier != null) {
//       setState(() {
//         addedProducts.add({
//           'name': productName,
//           'quantity': quantity,
//           'price': price,
//           'entryType': entryType!,
//           'supplier': selectedSupplier!,
//           'remarks': remarksController.text,
//           'date': DateTime.now().toString(),
//         });
//         productNameController.clear();
//         quantityController.clear();
//         priceController.clear();
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Please fill all fields")));
//     }
//   }
//
//   void _saveTransactionToFirebase() {
//     if (addedProducts.isNotEmpty) {
//       final transactionData = {
//         'entryType': entryType,
//         'supplier': selectedSupplier,
//         'remarks': remarksController.text,
//         'date': DateTime.now().toString(),
//         'products': addedProducts,
//       };
//
//       _database.push().set(transactionData).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Transaction saved successfully")));
//         setState(() {
//           addedProducts.clear();
//           remarksController.clear();
//           entryType = null;
//           selectedSupplier = null;
//         });
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to save transaction: $error")));
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("No products to save")));
//     }
//   }
// }

// import 'package:flutter/material.dart';
//
// class ProductTable extends StatelessWidget {
//   final List<Map<String, dynamic>> addedProducts;
//
//   const ProductTable({Key? key, required this.addedProducts}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Handle the case when the list is empty
//     if (addedProducts.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             "No products added yet.",
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ),
//       );
//     }
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Allow horizontal scrolling for large tables
//       child: DataTable(
//         columns: const [
//           DataColumn(label: Text('No.')),
//           DataColumn(label: Text('Product Name')),
//           DataColumn(label: Text('Quantity')),
//           DataColumn(label: Text('Entry Type')),
//           DataColumn(label: Text('Supplier')),
//           DataColumn(label: Text('Full Date')),
//           DataColumn(label: Text('Running Time')),
//           DataColumn(label: Text('Price')),
//           DataColumn(label: Text('Remarks')),
//           DataColumn(label: Text('Actions')),
//         ],
//         rows: List.generate(
//           addedProducts.length,
//               (index) {
//             final product = addedProducts[index];
//             final String date = product['date'] ?? DateTime.now().toString();
//             final DateTime parsedDate = DateTime.tryParse(date) ?? DateTime.now();
//             final Duration timeElapsed = DateTime.now().difference(parsedDate);
//             final String runningTime =
//                 "${timeElapsed.inHours} hrs ${timeElapsed.inMinutes % 60} mins";
//
//             return DataRow(
//               cells: [
//                 DataCell(Text('${index + 1}')), // Row number
//                 DataCell(Text(product['name'] ?? 'N/A')),
//                 DataCell(Text(product['quantity'] ?? 'N/A')),
//                 DataCell(Text(product['entryType'] ?? 'N/A')),
//                 DataCell(Text(product['supplier'] ?? 'N/A')),
//                 DataCell(Text(date)),
//                 DataCell(Text(runningTime)),
//                 DataCell(Text(product['price'] ?? 'N/A')),
//                 DataCell(Text(product['remarks'] ?? 'N/A')),
//                 DataCell(
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.blue),
//                         onPressed: () {
//                           // Add edit functionality here if needed
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           // Add delete functionality here if needed
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

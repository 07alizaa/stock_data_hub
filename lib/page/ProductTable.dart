// ProductTable.dart
import 'package:flutter/material.dart';

class ProductTable extends StatelessWidget {
  final List<Map<String, String>> addedProducts;

  const ProductTable({Key? key, required this.addedProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Horizontal scrolling for the table
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Product Name')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Entry Type')),
          DataColumn(label: Text('Supplier')),
          DataColumn(label: Text('Full Date')),
          DataColumn(label: Text('Running Time')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Remarks')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List.generate(
          addedProducts.length,
              (index) {
            final product = addedProducts[index];
            final timeElapsed = DateTime.now().difference(DateTime.parse(product['date']!));
            final runningTime = "${timeElapsed.inHours} hrs ${timeElapsed.inMinutes % 60} mins";
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')), // Row number
                DataCell(Text(product['name'] ?? '')),
                DataCell(Text(product['quantity'] ?? '')),
                DataCell(Text(product['entryType'] ?? '')),
                DataCell(Text(product['supplier'] ?? '')),
                DataCell(Text(product['date'] ?? '')),
                DataCell(Text(runningTime)),
                DataCell(Text(product['price'] ?? '')),
                DataCell(Text(product['remarks'] ?? '')),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Add edit functionality here if needed
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Add delete functionality here if needed
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

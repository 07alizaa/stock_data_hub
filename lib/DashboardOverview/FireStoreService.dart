import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Fetch dispatch records from Firestore and format them for Apriori
  Future<List<List<String>>> fetchDispatchRecords() async {
    List<List<String>> transactions = [];
    try {
      // Fetch all dispatch records
      final snapshot = await firestore.collection('dispatchRecords').get();

      for (var doc in snapshot.docs) {
        // Ensure that product and quantity fields exist
        final String product = doc['product'];
        final int quantity = doc['quantity'];

        if (quantity > 0) {
          // Add the product to the transaction list
          transactions.add([product]);
        }
      }
    } catch (e) {
      // Log error if fetching fails
      print('Error fetching dispatch records: $e');
    }
    return transactions;
  }
}

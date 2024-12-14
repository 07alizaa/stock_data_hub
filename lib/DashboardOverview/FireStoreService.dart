import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<List<String>>> fetchDispatchRecords() async {
    List<List<String>> transactions = [];
    try {
      final snapshot = await firestore.collection('dispatchRecords').get();

      for (var doc in snapshot.docs) {
        final String product = doc['product'];
        final int quantity = doc['quantity'];

        if (quantity > 0) {
          transactions.add([product]); // Each product as a transaction
        }
      }
    } catch (e) {
      print('Error fetching dispatch records: $e');
    }
    return transactions;
  }
}

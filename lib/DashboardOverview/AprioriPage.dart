import 'package:flutter/material.dart';
import 'FireStoreService.dart';
import 'apriori.dart';

class AprioriInsightsPage extends StatefulWidget {
  const AprioriInsightsPage({super.key});

  @override
  State<AprioriInsightsPage> createState() => _AprioriInsightsPageState();
}

class _AprioriInsightsPageState extends State<AprioriInsightsPage> {
  final FirestoreService firestoreService = FirestoreService();
  List<Map<String, dynamic>> associationRules = [];

  @override
  void initState() {
    super.initState();
    _generateAprioriInsights();
  }

  /// Generate Apriori insights
  Future<void> _generateAprioriInsights() async {
    List<List<String>> transactions = await firestoreService.fetchDispatchRecords();

    if (transactions.isEmpty) {
      debugPrint('No transactions available.');
      return;
    }

    // Run Apriori Algorithm
    Apriori apriori = Apriori(0.3, 0.7); // Support: 30%, Confidence: 70%
    Map<Set<String>, double> frequentItemsets = apriori.generateFrequentItemsets(transactions);
    List<Map<String, dynamic>> rules = apriori.generateAssociationRules(frequentItemsets, transactions);

    setState(() {
      associationRules = rules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apriori Insights'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: associationRules.isEmpty
            ? const Center(child: Text('No insights available.'))
            : ListView.builder(
          itemCount: associationRules.length,
          itemBuilder: (context, index) {
            final rule = associationRules[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(rule['rule']),
                subtitle: Text(
                  'Support: ${rule['support'].toStringAsFixed(2)}, '
                      'Confidence: ${rule['confidence'].toStringAsFixed(2)}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

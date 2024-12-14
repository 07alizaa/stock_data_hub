class Apriori {
  final double minSupport;
  final double minConfidence;

  Apriori(this.minSupport, this.minConfidence);

  Map<Set<String>, double> generateFrequentItemsets(List<List<String>> transactions) {
    Map<Set<String>, int> itemsetCounts = {};
    int transactionCount = transactions.length;

    for (var transaction in transactions) {
      for (var item in transaction) {
        itemsetCounts.update({item}, (count) => count + 1, ifAbsent: () => 1);
      }
    }

    Map<Set<String>, double> frequentItemsets = {};
    itemsetCounts.forEach((itemset, count) {
      double support = count / transactionCount;
      if (support >= minSupport) {
        frequentItemsets[itemset] = support;
      }
    });

    return frequentItemsets;
  }

  List<Map<String, dynamic>> generateAssociationRules(
      Map<Set<String>, double> frequentItemsets, List<List<String>> transactions) {
    List<Map<String, dynamic>> rules = [];

    frequentItemsets.forEach((itemset, support) {
      if (itemset.length > 1) {
        List<Set<String>> subsets = _getSubsets(itemset);
        for (var subset in subsets) {
          Set<String> remaining = itemset.difference(subset);
          if (remaining.isNotEmpty) {
            double confidence = _calculateConfidence(subset, remaining, transactions);
            if (confidence >= minConfidence) {
              rules.add({
                'rule': '${subset.join(", ")} => ${remaining.join(", ")}',
                'support': support,
                'confidence': confidence,
              });
            }
          }
        }
      }
    });

    return rules;
  }

  List<Set<String>> _getSubsets(Set<String> set) {
    List<Set<String>> subsets = [];
    int n = set.length;
    List<String> list = set.toList();

    for (int i = 1; i < (1 << n); i++) {
      Set<String> subset = {};
      for (int j = 0; j < n; j++) {
        if ((i & (1 << j)) != 0) {
          subset.add(list[j]);
        }
      }
      subsets.add(subset);
    }

    return subsets;
  }

  double _calculateConfidence(Set<String> antecedent, Set<String> consequent, List<List<String>> transactions) {
    int antecedentCount = 0;
    int bothCount = 0;

    for (var transaction in transactions) {
      if (antecedent.every((item) => transaction.contains(item))) {
        antecedentCount++;
        if (consequent.every((item) => transaction.contains(item))) {
          bothCount++;
        }
      }
    }

    return antecedentCount == 0 ? 0.0 : bothCount / antecedentCount;
  }
}

  class Transaction {
    final double change;
    final DateTime date;
    final String description;

    Transaction({required this.change, required this.date, required this.description});

    factory Transaction.fromJson(Map<String, dynamic> json) {
      return Transaction(
        change: json['amount'],
        date: DateTime.parse(json['date']),
        description: json['description'],
      );
    }
  }
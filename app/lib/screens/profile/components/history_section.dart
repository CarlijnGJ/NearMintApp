import 'package:app/screens/profile/components/transactionlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistorySection extends StatelessWidget {
  final List transactions;

  const HistorySection({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'History',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TransactionList(transactions: transactions),
          ),
        ],
      ),
    );
  }
}
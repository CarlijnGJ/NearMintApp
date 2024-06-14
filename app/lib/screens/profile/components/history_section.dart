import 'package:app/screens/members/components/page_selection.dart';
import 'package:flutter/material.dart';
import 'transactionlist.dart';
import 'transaction.dart';

class HistorySection extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback previousPage;
  final VoidCallback nextPage;
  final int page;
  final int pageSize;

  HistorySection({
    Key? key,
    required this.transactions,
    required this.previousPage,
    required this.nextPage,
    required this.page,
    required this.pageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int startIndex = page * pageSize;
    final int endIndex = (startIndex + pageSize < transactions.length)
        ? startIndex + pageSize
        : transactions.length;
    final List<Transaction> paginatedTransactions = transactions.sublist(startIndex, endIndex);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'History',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TransactionList(
              transactions: paginatedTransactions,
              width: 900,
            ),
          ),
          PageSelectionRow(
            page: page,
            itemsPerPage: pageSize,
            itemsList: transactions,
            previousPage: previousPage,
            nextPage: nextPage,
          ),
        ],
      ),
    );
  }
}

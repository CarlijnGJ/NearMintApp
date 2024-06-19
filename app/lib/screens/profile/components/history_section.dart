import 'package:app/screens/members/components/page_selection.dart';
import 'package:app/screens/profile/components/transaction.dart';
import 'package:app/screens/profile/components/transactionlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final List<Transaction> paginatedTransactions =
        transactions.sublist(startIndex, endIndex);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'History',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Center(
              child: TransactionList(transactions: paginatedTransactions),
            ),

            // Added to maintain spacing if required
            PageSelectionRow(
              page: page,
              itemsPerPage: pageSize,
              itemsList: transactions,
              previousPage: previousPage,
              nextPage: nextPage,
            ),
          ],
        ),
      ),
    );
  }
}

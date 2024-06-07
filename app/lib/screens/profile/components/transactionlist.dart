import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class TransactionList extends StatelessWidget {
  final List transactions;
  final double width;

  const TransactionList({Key? key, required this.transactions, required this.width}) : super(key: key);

  List<DataRow> checkTransactions() {
    if (transactions.isEmpty) {
      return [
        const DataRow(cells: [
          DataCell(Text('Empty')),
          DataCell(Text('Empty')),
          DataCell(Text('Empty')),
        ]),
      ];
    } else {
      return transactions.map(
        (transaction) => DataRow(cells: [
          DataCell(Text(transaction.change.toString())),
          DataCell(Text(DateFormat('dd/MM/yyyy HH:mm').format(transaction.date))), // Format the date here
          DataCell(Text(transaction.description)),
        ]),
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: width, // Set width to screen width for debugging
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Change')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Description')),
          ],
          rows: checkTransactions(),
        ),
      ),
    );
  }
}
  
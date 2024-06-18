import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List transactions;

  const TransactionList({Key? key, required this.transactions}) : super(key: key);

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
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Change')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Description')),
        ],
        rows: checkTransactions(),
      ),
    );
  }
}

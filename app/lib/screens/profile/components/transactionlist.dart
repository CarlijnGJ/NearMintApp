import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {

  final List transactions;

  const TransactionList({super.key, required this.transactions});


  @override
  Widget build(BuildContext context){
    return DataTable(
      columns: const [
        DataColumn(label: Text('Change')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Description')),
      ],
      rows: transactions
          .map(
            (transaction) => DataRow(cells: [
              DataCell(Text(transaction.change.toString())),
              DataCell(Text(transaction.date.toString())),
              DataCell(Text(transaction.description)),
            ]),
          )
          .toList(),
    );
  }
}
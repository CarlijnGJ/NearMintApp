import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/screens/profile/components/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
            final NumberFormat currencyFormat = NumberFormat.currency(symbol: '€');

    return transactions.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No transactions available.',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Change')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Description')),
              ],
              rows: transactions
                  .map(
                    (transaction) => DataRow(
                      cells: [
                        // DataCell(Text(transaction.change.toString())),
                        DataCell(Text(currencyFormat.format(transaction.change))),
                        DataCell(
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
                          ),
                        ),
                        DataCell(Text(transaction.description)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
  }
}

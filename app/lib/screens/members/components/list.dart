import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  final List memberList;

  const ListWidget({super.key, required this.memberList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Nickname')),
          DataColumn(label: Text('Credits')),
          DataColumn(label: Text('Add transaction')),
        ],
        rows: memberList
            .map(
              (user) => DataRow(cells: [
                DataCell(Text(user.name)),
                DataCell(Text(user.nickname)),
                DataCell(Text(user.credits.toString())),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, '/addtransaction',
                          arguments: user);
                    },
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }
}

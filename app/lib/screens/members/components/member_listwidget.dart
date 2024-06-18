import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberListWidget extends StatelessWidget {
  final List memberList;

  const MemberListWidget({super.key, required this.memberList});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: '€');

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double columnWidth = screenWidth > 600 ? 150 : 100; // Adjust column width based on screen size

        return memberList.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No members available.',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: screenWidth > 600 ? 20.0 : 10.0, // Adjust column spacing based on screen size
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Nickname')),
                    DataColumn(label: Text('Credits')),
                    DataColumn(label: Text('Add transaction')),
                  ],
                  rows: memberList
                      .map(
                        (user) => DataRow(cells: [
                          DataCell(
                            Container(
                              width: columnWidth, // Set a fixed width based on screen size
                              child: Text(
                                user.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: columnWidth, // Set a fixed width based on screen size
                              child: Text(
                                user.nickname,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: columnWidth, // Set a fixed width based on screen size
                              child: Text(
                                currencyFormat.format(user.credits),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: user.credits > 100
                                      ? Colors.yellow
                                      : user.credits < 0
                                          ? Colors.red
                                          : Colors.white,
                                ),
                              ),
                            ),
                          ),
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
      },
    );
  }
}

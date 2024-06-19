import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberListWidget extends StatelessWidget {
  final List memberList;
  final int page;
  final int pageSize;
  final List membersList;
  final VoidCallback previousPage;
  final VoidCallback nextPage;

  const MemberListWidget({
    super.key,
    required this.memberList,
    required this.page,
    required this.pageSize,
    required this.membersList,
    required this.previousPage,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: '€');

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double columnWidth = screenWidth > 600 ? 150 : 100;
        double buttonWidth = 120;

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0), // Padding for the table
                    child: DataTable(
                      columnSpacing: screenWidth > 600 ? 20.0 : 10.0,
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Nickname')),
                        DataColumn(label: Text('Credits')),
                        DataColumn(label: Text('Add transaction')),
                      ],
                      rows: [
                        ...memberList.map(
                          (user) => DataRow(cells: [
                            DataCell(
                              SizedBox(
                                width: columnWidth,
                                child: Text(
                                  user.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: columnWidth,
                                child: Text(
                                  user.nickname,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: columnWidth,
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
                                  Navigator.pushNamed(
                                      context, '/addtransaction',
                                      arguments: user);
                                },
                              ),
                            ),
                          ]),
                        ),
                        DataRow(
                          cells: [
                            DataCell.empty,
                            DataCell(
                              SizedBox(
                                width: buttonWidth,
                                child: ElevatedButton(
                                  onPressed: page > 0 ? previousPage : null,
                                  child: const Text('Previous'),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: buttonWidth,
                                child: ElevatedButton(
                                  onPressed: (page + 1) * pageSize < membersList.length
                                      ? nextPage
                                      : null,
                                  child: const Text('Next'),
                                ),
                              ),
                            ),
                            DataCell.empty,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

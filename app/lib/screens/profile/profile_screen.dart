import 'dart:developer';

import 'package:app/components/topbar/topbar.dart';
import 'package:app/screens/profile/components/transaction.dart';
import 'package:app/screens/profile/components/transactionlist.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? nickname;
  String? name;
  String? gender;
  String? preferedGame;
  String? avatar;
  String? balance;

  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';

  bool isExpenseChecked = false;
  bool isIncomeChecked = false;
  DateTime selectedStart = DateTime.now();
  DateTime selectedEnd = DateTime.now();
  bool showStartPicker = true;

  List<Transaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    fetchMemberData();
    fetchTransactions();
  }

  Future<void> fetchMemberData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        Map<String, dynamic> memberData = await APIService.getMember(sessionKey);
        setState(() {
          nickname = memberData['nickname'];
          name = memberData['name'];
          balance = memberData['balance'].toString();
          avatar = memberData['avatar'];
          gender = memberData['gender'];
          preferedGame = memberData['preferedGame'];
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = 'Please login again'; //Session key is not available
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = 'Failed to fetch member data: $e';
      });
    }
  }

  Future<void> fetchTransactions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        final transactions = await APIService.getTransactions(sessionKey);
        setState(() {
          transactionList = transactions;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Container
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        avatar != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(right: 16.0),
                                                child: Image.asset(
                                                  avatar!,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              )
                                            : const Icon(Icons.person, size: 50),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/editmember');
                                          },
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Nickname: ${nickname ?? 'Empty'}',
                                              style: const TextStyle(fontSize: 16.0),
                                            ),
                                            Text(
                                              'Name: ${name ?? 'Empty'}',
                                              style: const TextStyle(fontSize: 16.0),
                                            ),
                                            Text(
                                              'Gender: ${gender ?? 'Empty'}',
                                              style: const TextStyle(fontSize: 16.0),
                                            ),
                                            Text(
                                              'Preferred game: ${preferedGame ?? 'Empty'}',
                                              style: const TextStyle(fontSize: 16.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Balance Container
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Balance',
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      balance ?? 'Not found',
                                      style: const TextStyle(fontSize: 24.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Filter Container
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Filter',
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isExpenseChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isExpenseChecked = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Expense',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isIncomeChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isIncomeChecked = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Income',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Start date',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showStartPicker = true;
                                        });
                                      },
                                      child: Text(
                                        '${selectedStart.toLocal()}'.split(' ')[0],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ),
                                    if (showStartPicker)
                                      SizedBox(
                                      height: 220,
                                      width: 300,
                                      child: CalendarDatePicker(
                                        initialDate: selectedEnd,
                                        firstDate: DateTime(2024, 1, 1),
                                        lastDate: DateTime(2074, 12, 31),
                                        onDateChanged: (DateTime selected) {
                                          setState(() {
                                            selectedEnd = selected;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'End date',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showStartPicker = false;
                                        });
                                      },
                                      child: Text(
                                        '${selectedEnd.toLocal()}'.split(' ')[0],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ),
                                    if (!showStartPicker)
                                      SizedBox(
                                      height: 220,
                                      width: 300,
                                      child: CalendarDatePicker(
                                        initialDate: selectedEnd,
                                        firstDate: DateTime(2024, 1, 1),
                                        lastDate: DateTime(2074, 12, 31),
                                        onDateChanged: (DateTime selected) {
                                          setState(() {
                                            selectedEnd = selected;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Transaction List Container
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(  // History
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'History',
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: TransactionList(
                                  transactions: transactionList,
                                  width: 900, 
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
import 'dart:developer';

import 'package:app/components/topbar/topbar.dart';
import 'package:app/screens/profile/components/transaction.dart';
import 'package:app/screens/profile/components/transactionlist.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/widgets.dart';
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

  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';

  bool isExpenseChecked = false;
  bool isIncomeChecked = false;
  DateTime selectedStart = DateTime.now();
  DateTime selectedEnd = DateTime.now();

  List<Transaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    // Fetch member data when the profile page initializes
    fetchMemberData();
    fetchTransactions();
  }

  Future<void> fetchMemberData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        Map<String, dynamic> memberData =
            await APIService.getMember(sessionKey);
        setState(() {
          nickname = memberData['nickname'];
          name = memberData['name'];
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
              : SingleChildScrollView(
                  child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    avatar != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(right: 16.0),
                                            child: Image.asset(
                                              avatar!,
                                              width: 100,
                                              height: 100,
                                            ),
                                          )
                                        : const SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Balance: ',
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '{Insert balance here}',
                                      style: TextStyle(fontSize: 24.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
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
                                      'Startdate',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: CalendarDatePicker(
                                        initialDate: selectedStart,
                                        firstDate: DateTime(2024, 1, 1),
                                        lastDate: DateTime(2074, 12, 31),
                                        onDateChanged: (DateTime selected) {
                                          setState(() {
                                            selectedStart = selected;
                                          });
                                        },
                                      ),
                                    ),
                                    const Text(
                                      'Enddate',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      width: 250,
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
                        Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(minWidth: 20.0, maxWidth: 600.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                ),
                                child: TransactionList(transactions: transactionList)
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
              )
      );
  }
}
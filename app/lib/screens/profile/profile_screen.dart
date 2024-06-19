import 'package:app/components/topbar/topbar.dart';
import 'package:app/util/auth_check_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';
import 'components/balance_container.dart';
import 'components/profile_information.dart';
import 'components/history_section.dart';
import 'components/transaction.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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

  int page = 0;
  int pageSize = 10;
  List<Transaction> transactionList = [];

  void nextPage() {
    setState(() {
      if ((page + 1) * pageSize < transactionList.length) {
        page++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 0) {
        page--;
      }
    });
  }

  @override
  void initState() {
    CheckAuthUtil.MemberOrAdmin(context);
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
        if (avatar == null || avatar == '') {
          avatar = 'Images/Avatars/member.png';
        }
        gender = memberData['gender'];
        preferedGame = memberData['preferedGame'];
        isLoading = false;
        isError = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = 'Please login again';
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
      // Handle error
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
              : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 950) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileInformation(
                                    avatar: avatar,
                                    nickname: nickname,
                                    name: name,
                                    gender: gender,
                                    preferredGame: preferedGame,
                                  ),
                                  const SizedBox(height: 10),
                                  BalanceContainer(
                                    balance: balance,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 3,
                              child: HistorySection(
                                transactions: transactionList,
                                previousPage: previousPage,
                                nextPage: nextPage,
                                page: page,
                                pageSize: pageSize,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileInformation(
                                avatar: avatar,
                                nickname: nickname,
                                name: name,
                                gender: gender,
                                preferredGame: preferedGame,
                              ),
                              const SizedBox(height: 10),
                              BalanceContainer(
                                balance: balance,
                              ),
                              const SizedBox(height: 10),
                              HistorySection(
                                transactions: transactionList,
                                previousPage: previousPage,
                                nextPage: nextPage,
                                page: page,
                                pageSize: pageSize,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
    );
  }
}

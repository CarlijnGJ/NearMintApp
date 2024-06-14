import 'package:app/screens/members/components/list.dart';
import 'package:app/screens/members/components/page_selection.dart';
import 'package:app/screens/members/components/user.dart';
import 'package:app/screens/members/components/userservice.dart';
import 'package:flutter/material.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  List<User> membersList = [];
  int page = 0;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchMembers(); // Call fetchMembers in initState
  }

  //get users
  Future<void> fetchMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    if (sessionKey != null) {
      try {
        final newRole = await APIService.getRole(sessionKey);
        if (mounted) {
          if (newRole == 'Admin') {
            final membersData = await APIService.getMembers(sessionKey);
            final List<User> members = membersData
                .map((data) => User(
                      id: data['memberId'],
                      name: data['name'],
                      nickname: data['nickname'],
                      credits: data['credits'],
                    ))
                .toList();
            setState(() {
              membersList = members;
            });
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void nextPage() {
    setState(() {
      page++;
    });
  }

  void previousPage() {
    setState(() {
      page--;
    });
  }

  List<User> usersPerPage(int page) {
    UserService userService =
        UserService(membersList: membersList, pageSize: pageSize);
    return userService.getUsersPerPage(page);
  }

  void addMemberButton() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/addmember');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Members', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              ListWidget(
                memberList: usersPerPage(page),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: addMemberButton,
                    child: const Text('Add member'),
                  )
                ],
              ),
              PageSelectionRow(
                  page: page,
                  itemsPerPage: pageSize,
                  itemsList: membersList,
                  previousPage: previousPage,
                  nextPage: nextPage),
            ],
          ),
        ),
      ),
    );
  }
}

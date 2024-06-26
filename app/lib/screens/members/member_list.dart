import 'package:app/screens/members/components/member_listwidget.dart';
import 'package:app/screens/members/components/user.dart';
import 'package:app/screens/members/components/userservice.dart';
import 'package:app/util/auth_check_util.dart';
import 'package:app/util/role_util.dart';
import 'package:flutter/material.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

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
    CheckAuthUtil.Admin(context);
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
      // ignore: empty_catches
      } catch (e) {
        
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

  void updateTransactionsButton() async {
    if (await RoleUtil.fetchRole() == 'Admin') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (result != null && result.files.isNotEmpty) {
        var fileBytes = result.files.first.bytes;
        await APIService.uploadExcel(
            fileBytes as List<int>, result.files.first.name, sessionKey!);
      }
    }
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text('Members', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                MemberListWidget(
                  memberList: usersPerPage(page),
                  page: page,
                  pageSize: pageSize,
                  membersList: membersList,
                  previousPage: previousPage,
                  nextPage: nextPage,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: addMemberButton,
                        child: const Text('Add member'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: updateTransactionsButton,
                        child: const Text('Update transactions'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

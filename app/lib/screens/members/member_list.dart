import 'package:app/screens/members/components/list.dart';
import 'package:flutter/material.dart';
import 'package:app/components/topbar.dart';


class MemberList extends StatefulWidget {

  const MemberList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MemberListState createState() => _MemberListState();
}

class User {
  final String name;
  final String nickname;
  final int credits;

  User({required this.name, required this.nickname, required this.credits});
}

class _MemberListState extends State<MemberList> {

  // Dummy list of users
  final List<User> allUsers = [
    User(name: 'John Doe', nickname: 'JD', credits: 100),
    User(name: 'Alice Smith', nickname: 'Alicia', credits: 200),
    User(name: 'Bob Johnson', nickname: 'Bobby', credits: 150),
        User(name: 'John Doe', nickname: 'JD', credits: 100),
    User(name: 'Alice Smith', nickname: 'Alicia', credits: 200),
    User(name: 'Bob Johnson', nickname: 'Bobby', credits: 150),
        User(name: 'John Doe', nickname: 'JD', credits: 100),
    User(name: 'Alice Smith', nickname: 'Alicia', credits: 200),
    User(name: 'Bob Johnson', nickname: 'Bobby', credits: 150),
        User(name: 'John Doe', nickname: 'JD', credits: 100),
    User(name: 'Alice Smith', nickname: 'Alicia', credits: 200),
    User(name: 'Bob Johnson', nickname: 'Bobby', credits: 150),
  ];
  
  int page = 0;
  int pageSize = 10;

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

  List<User> get usersPerPage {
    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;
    return allUsers.sublist(startIndex, endIndex.clamp(0, allUsers.length));
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

            const Text('Members',style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            ListWidget(
              memberList: usersPerPage,
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: page > 0 ? previousPage : null,
                  child: Text('Previous'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (page + 1) * pageSize < allUsers.length
                      ? nextPage
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}

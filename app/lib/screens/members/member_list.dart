  import 'package:app/screens/members/components/list.dart';
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
              if(newRole == 'Admin'){
              final members = await APIService.getMembers(sessionKey);
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
      UserService userService = UserService(membersList: membersList, pageSize: pageSize);
      return userService.getUsersPerPage(page);
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
                memberList: usersPerPage(page),
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
                    onPressed: (page + 1) * pageSize < membersList.length
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


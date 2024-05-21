import 'dart:developer';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:flutter/material.dart';

import 'package:app/components/topbar/topbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';
import 'package:app/screens/home/components/titlesection.dart';
import 'package:app/screens/home/components/buttonsection.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  bool isLoggedIn = false;
  String role = 'Visitor';

  Future<void> fetchRoleAndInitialize() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    if (sessionKey != null) {
      try {
        final newRole = await APIService.getRole(sessionKey);
        if (mounted) {
          setState(() {
            isLoggedIn = true;
            role = newRole;
          });
        }
      } catch (e) {
        log('Error: $e');
      }
    } else {
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          role = 'Visitor';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoleAndInitialize();
  }

  List<Widget> buildButtonsForRole() {
    if (role == 'Visitor') {
      return [
        const ButtonSection(
          assetname: '../../../Images/account-login-xxl.png',
          description: 'Log in',
        ),
        const Spacer(flex: 1),
        const ButtonSection(
          assetname: '../../../Images/add-user-2-xxl.png',
          description: 'Register',
        ),
      ];
    } else if (role == 'Member') {
      return [
        // Example buttons for 'User' role
        const ButtonSection(
          assetname: '../../../Images/account-login-xxl.png', 
          description: 'Log out',
        ),
      ];
    } else if (role == 'Admin') {
      return [
        const ButtonSection(
          assetname: '../../../Images/account-login-xxl.png', 
          description: 'Log out',
        ),
      ];
    }
    return [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),  
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const TealGradLeft(),
            const TealGradRight(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight), // Adjust based on app bar height
                  TitleSection(
                    name: 'Welcome, $role!',
                  ),
                  const SizedBox(height: 16.0),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            ...buildButtonsForRole(),
                            const Spacer(flex: 2),
                          ],
                        );
                      } else {
                        return Column(
                          children: buildButtonsForRole(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}
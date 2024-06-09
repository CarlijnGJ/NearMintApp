import 'dart:developer';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/services/state_manager/session_events.dart';
import 'package:app/services/state_manager/session_provider.dart';
import 'package:app/services/state_manager/session_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:app/components/topbar/topbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';
import 'package:app/screens/home/components/titlesection.dart';
import 'package:app/screens/home/components/navbutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoleAndInitialize();
  }

  Future<void> fetchRoleAndInitialize() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    if (sessionKey != null) {
      try {
        final newRole = await APIService.getRole(sessionKey);
        if (mounted) {
          final sessionProvider =
              Provider.of<SessionProvider>(context, listen: false);
          sessionProvider.handleEvent(LoggedIn(newRole, sessionKey));
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        log('Error: $e');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Widget> buildButtonsForRole(SessionState currentState) {
    if (currentState is VisitorState) {
      return [
        const NavButton(
          assetname: '../../../Images/account-login-xxl.png',
          description: 'Log in',
          url: '/login',
        ),
        const SizedBox(height: 16.0),
        const NavButton(
          assetname: '../../../Images/add-user-2-xxl.png',
          description: 'Register',
          url: '/login',
        ),
      ];
    } else if (currentState is MemberState) {
      return [
        const NavButton(
            assetname: '../../../Images/user-3-xxl.png',
            description: 'Profile',
            url: '/profile'),
        const NavButton(
          assetname: '../../../Images/account-login-xxl.png',
          description: 'Log out',
          url: '/',
        ),
      ];
    } else if (currentState is AdminState) {
      return [
        const NavButton(
            assetname: '../../../Images/user-3-xxl.png',
            description: 'Profile',
            url: '/profile'),
        const NavButton(
            assetname: '../../../Images/add-user-2-xxl.png',
            description: 'Members',
            url: '/members'),
        const NavButton(
            assetname: '../../../Images/account-login-xxl.png',
            description: 'Log out',
            url: '/'),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    var currentState = sessionProvider.currentState;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              const TealGradLeft(),
              const TealGradRight(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:
                          MediaQuery.of(context).padding.top + kToolbarHeight,
                    ), // Adjust based on app bar height
                    const TitleSection(
                      name: 'Welcome!',
                    ),
                    const SizedBox(height: 16.0),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: buildButtonsForRole(currentState),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.7, // You can adjust this value according to your needs
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              children: buildButtonsForRole(currentState),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

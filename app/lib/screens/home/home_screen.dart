import 'dart:developer';
import 'dart:async';
import 'package:app/events/login_events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';
import 'package:app/screens/home/components/titlesection.dart';
import 'package:app/screens/home/components/navbutton.dart';
import 'package:app/util/eventbus_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  String role = 'Visitor';
  bool isLoading = true;
  late StreamSubscription logoutSubscription;

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
          isLoggedIn = false;
          role = 'Visitor';
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoleAndInitialize();
    logoutSubscription = eventBus.on<LogoutEvent>().listen((event) {
      _handleLogout();
    });
  }

  @override
  void dispose() {
    logoutSubscription.cancel();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        await prefs.remove('session_key');
        await APIService.logout(sessionKey);
        setState(() {
          isLoggedIn = false;
          role = 'Visitor';
        });
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        log('session key not found');
      }
    } catch (e) {
      log('Logout failed: $e');
    }
  }

  List<Widget> buildButtonsForRole() {
    if (role == 'Visitor') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return [];
    } else if (role == 'Member') {
      return [
        NavButtonWithHover(
          assetname: '../assets/images/user-3-xxl.png',
          description: 'Profile',
          url: '/profile',
        ),
        NavButtonWithHover(
          assetname: '../assets/images/account-login-xxl.png',
          description: 'Log out',
          url: '/',
        ),
      ];
    } else if (role == 'Admin') {
      return [
        NavButtonWithHover(
          assetname: '../assets/images/user-3-xxl.png',
          description: 'Profile',
          url: '/profile',
        ),
        NavButtonWithHover(
          assetname: '../assets/images/add-user-2-xxl.png',
          description: 'Members',
          url: '/members',
        ),
        NavButtonWithHover(
          assetname: '../assets/images/account-login-xxl.png',
          description: 'Log out',
          url: '/',
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBtnSize = screenWidth * 0.7;
    final double constrainedBtnSize = maxBtnSize > 250 ? 250 : maxBtnSize;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              const TitleSection(name: 'Welcome!'),
              const SizedBox(height: 16.0),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 950) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildButtonsForRole().map((button) {
                        return Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: button,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildButtonsForRole().map((button) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: button,
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

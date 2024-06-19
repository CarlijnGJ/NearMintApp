import 'dart:async';

import 'package:app/components/topbar/topbarbuttons.dart';
import 'package:app/events/login_events.dart';
import 'package:app/util/eventbus_util.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';

class RefreshTopbarEvent {
  final bool isLoggedIn;

  RefreshTopbarEvent(this.isLoggedIn);
}

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late Widget currentScreen;
  bool isLoggedIn = false;
  String role = 'Visitor';
  String loginButtonText = 'Login'; // Default text for login button

  // to be able to clean up the events on dispose

  @override
  void initState() {
    fetchRoleAndInitialize();
    super.initState();
    currentScreen = const HomePage();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            loginButtonText = 'Logout';
          });
        }
      // ignore: empty_catches
      } catch (e) {
      }
    } else {
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          role = 'Visitor';
          loginButtonText = 'Login';
        });
      }
    }
  }

  Future<void> onTap() async {
    try {
      eventBus.fire(LogoutEvent());
      eventBus.fire(RefreshTopbarEvent(false));
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<List<Widget>> getTopbarButtons(String role) async {
    if (role == 'Admin') {
      return <Widget>[
        const TopbarMembersButton(),
        const TopbarProfileButton(),
        TopbarLogoutButton(onTap: onTap), // Remove await here
      ];
    } else if (role == 'Member') {
      return <Widget>[
        const TopbarProfileButton(),
        TopbarLogoutButton(onTap: onTap),
      ];
    } else {
      return <Widget>[
        const TopbarLoginButton(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: getTopbarButtons(role),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator if data is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if an error occurred
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the AppBar with fetched top bar buttons
          return AppBar(
            title: const TopbarHomeButton(),
            actions: snapshot.data ?? [], // Use snapshot data as the actions
          );
        }
      },
    );
  }
}

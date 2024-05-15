import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';

EventBus eventBus = EventBus();

class RefreshTopbarEvent {
  final bool isLoggedIn;

  RefreshTopbarEvent(this.isLoggedIn);
}

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late Widget currentScreen;
  bool isLoggedIn = false;
  String role = 'Visitor';
  String loginButtonText = 'Login'; // Default text for login button

  late StreamSubscription<RefreshTopbarEvent> _eventSubscription;

  @override
  void initState() {

    _eventSubscription = eventBus.on<RefreshTopbarEvent>().listen((event) {
      if (event.isLoggedIn != isLoggedIn) {
        fetchRoleAndInitialize();
      } else {
        if (mounted) {
          setState(() {
            isLoggedIn = event.isLoggedIn;
            loginButtonText = isLoggedIn ? 'Logout' : 'Login';
          });
        }
      }
    });
    fetchRoleAndInitialize();
    super.initState();
    currentScreen = const HomePage();
  }

  @override
  void dispose() {
    _eventSubscription.cancel(); // Remove the event listener
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
      } catch (e) {
        print('Error: $e');
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

  List<Widget> getTopbarButtons(String role) {
    // return <Widget>[];
    if (role == 'Admin') {
      return <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/members');
          },
          child: const Text('Members'),
        ),
                IconButton(
          icon: const Icon(Icons.more_horiz),
          tooltip: 'More Options',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          },
          child: Text(loginButtonText),
        ),
      ];
    } else if (role == 'Member') {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.more_horiz),
          tooltip: 'More Options',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          },
          child: Text(loginButtonText),
        ),
      ];
    } else {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.more_horiz),
          tooltip: 'More Options',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          },
          child: Text(loginButtonText),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Near Mint Gaming'),
      actions: getTopbarButtons(role),
    );
  }
}

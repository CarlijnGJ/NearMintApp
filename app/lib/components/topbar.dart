import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'dart:html' as html;
import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart'; // Import your API service

EventBus eventBus = EventBus();

class LoggedInEvent {
  final bool isLoggedIn;
  final String role;

  LoggedInEvent(this.isLoggedIn, this.role);
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
  String role = '';
  String loginButtonText = 'Login'; // Default text for login button

  @override
  void initState() {
    super.initState();
    currentScreen = const HomePage();
    // Access SharedPreferences instance outside the event listener
    SharedPreferences.getInstance().then((prefs) {
      final sessionKey = prefs.getString('sessionKey');
      if (sessionKey != null) {
        APIService.getRole(sessionKey).then((role) {
          setState(() {
            isLoggedIn = true;
            this.role = role;
            loginButtonText = 'Logout';
          });
          eventBus.fire(LoggedInEvent(true, role));
        });
      }
      eventBus.on<LoggedInEvent>().listen((event) {
        setState(() {
          isLoggedIn = event.isLoggedIn;
          role = event.role;
          loginButtonText = isLoggedIn ? 'Logout' : 'Login';
        });
      });
    });
  }

  void updateState(SharedPreferences prefs) {
    setState(() {
      final sessionKey = prefs.getString('sessionKey');
      if (sessionKey != null) {
        APIService.getRole(sessionKey).then((role) {
          setState(() {
            isLoggedIn = true;
            this.role = role;
            loginButtonText = 'Logout';
          });
        });
      } else {
        isLoggedIn = false;
        role = '';
        loginButtonText = 'Login';
      }
    });
  }

  void setCurrentScreen(Widget screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Near Mint Gaming'),
      actions: <Widget>[
        if (!isLoggedIn) ...[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
              html.window.history.pushState(null, 'login', 'login');
            },
            child: Text(loginButtonText),
          ),
        ] else ...[
          if (role == 'member') ...[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
                html.window.history.pushState(null, 'profile', 'profile');
              },
              child: const Text('Profile'),
            ),
          ] else if (role == 'admin') ...[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/members');
                html.window.history.pushState(null, 'members', 'members');
              },
              child: const Text('Member List'),
            ),
          ],
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('sessionKey');
              eventBus.fire(LoggedInEvent(false, ''));
              Navigator.pushNamed(context, '/');
              html.window.history.pushState(null, '', '');
            },
            child: Text(loginButtonText),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'dart:html' as html;
import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

EventBus eventBus = EventBus();

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late Widget currentScreen;
  String loginButtonText = 'Login'; // Default text for login button

  @override
  void initState() {
    super.initState();
    currentScreen = const HomePage();
    // Access SharedPreferences instance outside the event listener
    SharedPreferences.getInstance().then((prefs) {
      // Listen for NicknameChangedEvent
      updateState(prefs);
      // eventBus.on<LoggedInEvent>().listen((event) {
      //   updateState(prefs);
      // });
    });
  }

  void updateState(SharedPreferences prefs) {
    setState(() {});
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
        IconButton(
          icon: const Icon(Icons.more_horiz),
          tooltip: 'More Options',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
            html.window.history.pushState(null, '', '');
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
            html.window.history.pushState(null, 'login', 'login');
          },
          child: Text(loginButtonText),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/members');
            html.window.history.pushState(null, 'members', 'members');
          },
          child: const Text('Members'),
        ),
      ],
    );
  }
}

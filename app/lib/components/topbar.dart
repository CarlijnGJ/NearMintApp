import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'dart:html' as html;

class TopBar extends StatefulWidget implements PreferredSizeWidget {

  const TopBar({Key? key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    currentScreen = const HomePage();
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
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/members');
          },
          child: const Text('Members'),
        ),
      ],
    );
  }
}

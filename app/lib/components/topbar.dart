import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'package:app/screens/login/login_screen.dart'; // Import the necessary widgets

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(Widget) onScreenChange;

  const TopBar({Key? key, required this.onScreenChange}) : super(key: key);

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
    widget.onScreenChange(screen); // Notify MainPage about the screen change
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
            Navigator.pushNamed(context, '/');
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}

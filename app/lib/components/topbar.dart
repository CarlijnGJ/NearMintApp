import 'package:flutter/material.dart';
// import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
// import 'package:app/screens/login/login_screen.dart'; // Import the necessary widgets

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  // final Function(Widget) onScreenChange;

  const TopBar({Key? key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  // late Widget currentScreen;

  // @override
  // void initState() {
  //   super.initState();
  //   currentScreen = const HomePage();
  // }

  // void setCurrentScreen(Widget screen) {
  //   setState(() {
  //     currentScreen = screen;
  //   });
  //   widget.onScreenChange(screen); // Notify MainPage about the screen change
  // }

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Near Mint Gaming"),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/'); // Replace '/home' with your actual route name for HomePage
            },
            icon: Icon(Icons.search),
          ),
                    IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login'); // Replace '/login' with your actual route name for LoginPage

            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}

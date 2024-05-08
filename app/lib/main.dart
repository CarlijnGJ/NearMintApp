import 'package:app/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:app/components/themes/maintheme.dart'; //import the main theme for the app
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return Scaffold(
      appBar: TopBar(
        onScreenChange: setCurrentScreen, // Pass the callback function
      ),  
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.center,
                  colors: [Colors.teal, Colors.transparent],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.centerRight,
                  colors: [Colors.transparent, Colors.teal],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          currentScreen,
        ]
      ),
    );
  }
}

import 'package:app/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
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
      body: Center(
        child: currentScreen,
      ),
    );
  }
}

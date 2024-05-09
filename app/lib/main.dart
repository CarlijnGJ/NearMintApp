import 'package:flutter/material.dart';

import 'package:app/components/themes/maintheme.dart'; //import the main theme for the app
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'package:app/screens/login/login_screen.dart';
import 'package:app/util/unanimated_pageroute.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return UnanimatedPageRoute(
              builder: (context) => const HomePage(),
            );
          case '/login':
            return UnanimatedPageRoute(
              builder: (context) => const LoginPage(),
            );
          default:
            return UnanimatedPageRoute(
              builder: (context) => const HomePage(),
            );
        }
      }
    );
  }
}

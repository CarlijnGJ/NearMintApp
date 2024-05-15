import 'package:app/screens/members/member_list.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:app/components/themes/maintheme.dart'; //import the main theme for the app
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'package:app/screens/login/login_screen.dart';
import 'package:app/util/unanimated_pageroute.dart';


void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const AppBarApp());
}
//void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/members': (context) => const MemberList(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

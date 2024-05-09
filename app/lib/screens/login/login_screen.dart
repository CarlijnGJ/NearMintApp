import 'package:flutter/material.dart';

import 'package:app/components/topbar.dart';
import 'package:app/components/titlesection.dart';
import 'package:app/components/loginpanel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),  
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight), // Adjust based on app bar height
                const TitleSection(
                  name: 'Login Page',
                ),
                const SizedBox(height: 16.0),
                const LoginPanel(
                  description:
                  'This is a test-container for the fields and text of the login page. '
                  'All of the stuff that needs doing will be based off of this. If there\'s '
                  'anything else involved, that\'ll be here as well.',
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}

import 'package:flutter/material.dart';

import 'package:app/components/titlesection.dart';
import 'package:app/components/textsection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight), // Adjust based on app bar height
          const TitleSection(
            name: 'Login Page',
          ),
          const SizedBox(height: 16.0),
          const TextSection(
            description:
            'This is a test-container for the fields and text of the login page. '
            'All of the stuff that needs doing will be based off of this. If there\'s '
            'anything else involved, that\'ll be here as well.',
          ),
        ],
      ),
    );
  }
}

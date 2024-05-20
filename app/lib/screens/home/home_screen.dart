import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:flutter/material.dart';

import 'package:app/components/topbar/topbar.dart';
import 'package:app/screens/home/components/titlesection.dart';
import 'package:app/screens/home/components/buttonsection.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),  
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const TealGradLeft(),
            const TealGradRight(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight), // Adjust based on app bar height
                  const TitleSection(
                    name: 'Welcome!',
                  ),
                  const SizedBox(height: 16.0),
                  const ButtonSection(
                    assetname: '../../../Images/account-login-xxl.png',
                    description: 'Log in',
                  ),
                  const SizedBox(height: 16.0),
                  const ButtonSection(
                    assetname: '../../../Images/add-user-2-xxl.png',
                    description: 'Register',
                  ),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}
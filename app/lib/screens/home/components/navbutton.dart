import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.assetname,
    required this.description,
    required this.url,
  });

  final String assetname;
  final String description;
  final String url;

  void navigate(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, url);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          if (description == 'Log out') {
            try {
              final prefs = await SharedPreferences.getInstance();
              final sessionKey = prefs.getString('session_key');
              if(sessionKey != null){
                await APIService.logout(sessionKey);
                await prefs.remove('session_key'); // Remove the session key from SharedPreferences
              }
              else{
                print('session key not found');
              }
            } catch (e) {
              print("Logout failed: $e");
            }
          }
          navigate(context);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color.fromRGBO(0, 0, 0, 0.25),
          child: Column(
            children: [
              Image.asset(assetname),
              Text(
                description,
                style: const TextStyle(fontSize: 32),
              )
            ],
          )
        ),
      )
    );
  }
}
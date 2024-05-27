import 'dart:developer';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/components/button.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app/components/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  void loginUser() async {
    final username = usernameController.text;
    final password = passwordController.text;
    try {
      // Call the login method from APIService
      final token = await APIService.login(username, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = token['session_key'];
      prefs.setString('session_key', sessionKey);
      // Navigate to the home page
      Navigator.pop(context);
      Navigator.pushNamed(context, '/');
      eventBus.fire(RefreshTopbarEvent(true));
    } catch (e) {
      // Handle login error (e.g., show an error message)
      print('Login failed: $e');
    }
  }

  void forgotPassword() {
    print("Forgot Password button pressed!");
  }

  void registerUser() async {
    final code = codeController.text;

    try {
      final exists = await APIService.checkCode(code);

      if (exists.result) {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/setup', arguments: exists.name);
        eventBus.fire(RefreshTopbarEvent(true));
      } else {
        log('Code does not exist');
      }
    } catch (e) {
      log('Register nav failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(),
        body: Stack(
          children: [
            const TealGradLeft(),
            const TealGradRight(),
            SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      'Credentials',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // username textfield
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: forgotPassword,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    CustomButton(text: 'Log in', onTap: loginUser),

                    const SizedBox(height: 30),

                    const Divider(),

                    const SizedBox(height: 20),

                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //code textfield
                    CustomTextField(
                      controller: codeController,
                      hintText: 'Token',
                      obscureText: false,
                    ),

                    const SizedBox(height: 20),

                    CustomButton(text: 'Register', onTap: registerUser),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

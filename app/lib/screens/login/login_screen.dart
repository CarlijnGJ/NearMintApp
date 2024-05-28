import 'dart:developer';
import 'dart:convert';

import 'package:app/components/customexception.dart';
import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/components/button.dart';
import 'package:app/services/api_service.dart';
import 'package:crypto/crypto.dart';
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
  String? errorMessage;

  String generateHashCode(String code) {
    var bytes = utf8.encode(code); // Convert the code to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return digest.toString(); // Convert the digest to a string
  }

  void loginUser() async {
    errorMessage = null;
    final username = usernameController.text;
    final password = passwordController.text;
    final hashedPassword = generateHashCode(password);
    try {
      // Call the login method from APIService
      final token = await APIService.login(username, hashedPassword);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = token['session_key'];
      prefs.setString('session_key', sessionKey);
      // Navigate to the home page
      Navigator.pop(context);
      Navigator.pushNamed(context, '/');
      eventBus.fire(RefreshTopbarEvent(true));
    } catch (e) {
      
      setState(() {
        if (e is HttpExceptionWithStatusCode) {
          errorMessage = e.message;
        } else {
          errorMessage = 'Connection failed';
        }
      });
      
    }
  }

  void forgotPassword() {
    print("Forgot Password button pressed!");
  }

  void checkValidity() async {
    final code = codeController.text;

    try {
      final exists = await APIService.checkCode(code);

      if (exists.result) {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/setup', arguments: exists.name);
        eventBus.fire(RefreshTopbarEvent(true));
      } else {
        //TO-DO: Add logic to display error visually
        log('Code does not exist');
      }
    } catch (e) {
      //TO-DO: Add logic to display error visually
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
                      errorText: errorMessage,
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

                    CustomButton(text: 'Register', onTap: checkValidity),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar.dart';
import 'package:app/screens/login/components/button.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/login/components/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser() async {
    final username = usernameController.text;
    final password = passwordController.text;
    try {
      // Call the login method from APIService
      final token = await APIService.login(username, password);
      // Handle successful login (e.g., navigate to the next screen)
    } catch (e) {
      // Handle login error (e.g., show an error message)
      print('Login failed: $e');
    }
  }

  void forgotPassword() {
    print("Forgot Password button pressed!");
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

                    CustomButton(onTap: loginUser),

                    const SizedBox(height: 30),

                    Divider(),

                    Text('or use the QR code'),

                    Icon(Icons.qr_code_2_rounded, size: 180),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

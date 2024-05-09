import 'package:app/screens/login/components/button.dart';
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

  void loginUser(){  print("Login button pressed!");}
  void forgotPassword(){  print("Forgot Password button pressed!");}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:  SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                'Credentials',
                style: TextStyle(
                  fontSize: 20,
                ),),
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
                      child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              CustomButton(
                onTap: loginUser),
              
              const SizedBox(height: 30),
              
              Divider(),

              Text('or use the QR code'),

              Icon(Icons.qr_code_2_rounded, size: 180),
            ],
          ),
        ),
      ),
    );
  }
}

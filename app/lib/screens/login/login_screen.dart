import 'package:app/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/components/customexception.dart';
import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/components/button.dart';
import 'package:app/events/login_events.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:app/services/api_service.dart';
import 'package:app/util/cypto_util.dart';
import 'package:app/util/eventbus_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();
  String? errorMessage;
  String? setupErrorMessage;

  void loginUser() async {
    errorMessage = null;
    final username = usernameController.text;
    final password = passwordController.text;
    final hashedPassword = CryptoUtil.generateHashCode(password);
    try {
      // Call the login method from APIService
      final token = await APIService.login(username, hashedPassword);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = token['session_key'];
      prefs.setString('session_key', sessionKey);
      // Navigate to the home page
      eventBus.fire(LoginEvent());
      Navigator.pop(context);
      Navigator.pushNamed(context, '/');
      eventBus.fire(RefreshTopbarEvent(true));
    } catch (e) {
      setState(() {
        if (e is HttpExceptionWithStatusCode) {
          errorMessage = e.message;
        } else {
          errorMessage = 'Wrong username or password';
        }
      });
    }
  }

  void forgotPassword() {
    print("Forgot Password button pressed!");
  }

  void checkValidity() async {
    setupErrorMessage = null;
    final code = codeController.text;
    String hashedCode = CryptoUtil.generateHashCode(code);

    if (!ValidateUser.validateToken(code)) {
      setupErrorMessage = 'Code must be 6 characters!';
      setState(() {});
      return;
    }

    try {
      final exists = await APIService.checkCode(hashedCode);

      if (exists.result) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', hashedCode);

        Navigator.pop(context);
        Navigator.pushNamed(context, '/setup');
        eventBus.fire(RefreshTopbarEvent(true));
      } else {
        setupErrorMessage = 'Code does not exist';
        setState(() {});
        return;
      }
    } catch (e) {
      //TO-DO: Add logic to display error visually
      setupErrorMessage = 'Connection failed';
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient or image goes here if needed
          Center(
            child: Container(
              width: screenWidth > 600 ? 600 : screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Adjust opacity as needed
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Transform.scale(
                            scale: 1.2,
                            child: Image.asset('assets/near_mint_logo.png'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Near Mint Gaming',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Account login',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: usernameController,
                      labelText: 'Username',
                      hintText: 'Peter',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      obscureText: true,
                      errorText: errorMessage,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(text: 'Log in', onTap: loginUser),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: screenWidth > 600 ? 500 : screenWidth * 0.9,
                        child: Divider(
                          color: Colors.white.withOpacity(0.5), // Set color with 50% opacity
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: codeController,
                      labelText: 'Token',
                      hintText: '6 characters',
                      obscureText: false,
                      errorText: setupErrorMessage,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(text: 'Register', onTap: checkValidity),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

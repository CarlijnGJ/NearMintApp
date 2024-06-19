import 'dart:convert';
import 'dart:developer';
import 'package:app/components/customexception.dart';
import 'package:app/events/login_events.dart';
import 'package:app/util/auth_check_util.dart';
import 'package:app/util/eventbus_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:app/components/button.dart';
import 'package:app/components/textfield.dart'; 
import 'package:app/screens/setup/components/prefered_game_picker.dart';
import 'package:app/screens/setup/components/profile_image_picker.dart';
import 'package:app/services/api_service.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:app/components/topbar/topbar.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  List<String?> errors = [];

  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final pwcheckController = TextEditingController();
  final genderController = TextEditingController();
  final gameController = TextEditingController();

  Map<String, String>? selectedImage; // Updated to Map<String, String>?

  @override
  void initState() {
    CheckAuthUtil.Visitor(context);
    super.initState();
  }

  String generateHashCode(String code) {
    var bytes = utf8.encode(code); // Convert the code to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return digest.toString(); // Convert the digest to a string
  }

  void showErrors() {
    if (errors.any((error) => error != null)) {
      setState(() {
      });
      return;
    }
  }

  void finishRegister() async {
    log("Data: ${nicknameController.text}, ${passwordController.text}, ${selectedImage?.toString()}, ${pwcheckController.text}, ${genderController.text}, ${gameController.text}.");

    String nickname = nicknameController.text;
    String password = passwordController.text;
    String pwcheck = pwcheckController.text;
    String gender = genderController.text;
    String prefgame = gameController.text;

    errors = List.filled(5, null);
    if (!ValidateUser.validateBasicString(nickname)) {
      errors[0] = 'Invalid username';
    }

    if (!ValidateUser.validatePassword(password)) {
      errors[1] = 'Invalid password';
    }

    if (pwcheck != password) {
      errors[2] = 'Passwords don\'t match';
    }

    if (!ValidateUser.validateBasicString(gender) && gender.isNotEmpty) {
      errors[3] = 'Invalid gender';
    }

    if (!ValidateUser.validateBasicString(prefgame) && prefgame.isNotEmpty) {
      errors[4] = 'Invalid preferred game';
    }

    showErrors();

    if (errors.any((error) => error != null)) {
      return; // Exit if there are errors
    }

    try {
      // Retrieve token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String code = prefs.getString('token') ?? '';

      final String hashedPassword = generateHashCode(password);

      // Update member data via API
      await APIService.updateMember(code, nickname, hashedPassword,
          selectedImage?['path'] ?? '', gender, prefgame);

      // Attempt login after update
      final token = await APIService.login(nickname, hashedPassword);
      final sessionKey = token['session_key'];
      prefs.setString('session_key', sessionKey);

      // Navigate to the home page
      eventBus.fire(LoginEvent());
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/');
      });
      eventBus.fire(RefreshTopbarEvent(true));
    } on HttpExceptionWithStatusCode {
      errors[0] = 'Username already exists';
      showErrors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Hello, new user!',
                              style: TextStyle(
                                fontSize: 32,
                              ),
                            ),
                            const Text(
                              'Just a few more steps to register your account!',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: nicknameController,
                              labelText: 'Nickname*',
                              hintText: 'Peter',
                              obscureText: false,
                              errorText: errors.isNotEmpty ? errors[0] : null,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: passwordController,
                              labelText: 'Password*',
                              obscureText: true,
                              errorText: errors.isNotEmpty ? errors[1] : null,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: pwcheckController,
                              labelText: 'Repeat Password*',
                              obscureText: true,
                              errorText: errors.isNotEmpty ? errors[2] : null,
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: genderController,
                              labelText: 'Gender',
                              obscureText: false,
                              errorText: errors.isNotEmpty ? errors[3] : null,
                            ),
                            const SizedBox(height: 10),
                            PreferredGameDropdown(
                              initialValue: 'None',
                              errorText: errors.isNotEmpty ? errors[4] : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  gameController.text = newValue ?? 'None';
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            ProfileImagePicker(
                              selectedImage: selectedImage,
                              onImageSelected: (Map<String, String>? image) {
                                setState(() {
                                  selectedImage = image;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                                text: 'Finish registration',
                                onTap: finishRegister),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

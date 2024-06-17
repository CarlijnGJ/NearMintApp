import 'dart:convert';
import 'dart:developer';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/textfield.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/screens/setup/components/prefered_game_picker.dart';
import 'package:app/screens/setup/components/profile_image_picker.dart';
import 'package:app/services/api_service.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:app/components/button.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  List<String?> errors = [];

  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final pwcheckController = TextEditingController();
  final genderController = TextEditingController();
  final gameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? selectedImage;

  final List<Map<String, String>> images = [
    {'name': 'Magic', 'path': '../assets/images/profilepics/PFP1.png'},
    {'name': 'Sea', 'path': '../assets/images/profilepics/PFP2.png'},
    {'name': 'Skull', 'path': '../assets/images/profilepics/PFP3.png'},
    {'name': 'Vanguard', 'path': '../assets/images/profilepics/PFP4.png'},
    {'name': 'Lorcana', 'path': '../assets/images/profilepics/PFP5.png'},
    {'name': 'OnePiece', 'path': '../assets/images/profilepics/PFP6.png'},
  ];

  String generateHashCode(String code) {
    var bytes = utf8.encode(code); // Convert the code to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return digest.toString(); // Convert the digest to a string
  }

  void finishRegister() async {
    log("Data: ${nicknameController.text}, ${passwordController.text}, ${selectedImage.toString()} ${pwcheckController.text}, ${genderController.text}, ${gameController.text}.");

    String nickname = nicknameController.text;
    String password = passwordController.text;
    String pwcheck = pwcheckController.text;
    String gender = genderController.text;
    String prefgame = gameController.text;

    errors = List.filled(5, null);
    if (!ValidateUser.validateBasicString(nicknameController.text)) {
      errors[0] = 'Invalid username';
    }

    if (!ValidateUser.validatePassword(passwordController.text)) {
      errors[1] = 'Invalid password';
    }

    if (pwcheckController.text != passwordController.text) {
      errors[2] = 'Passwords don\'t match';
    }

    if (!ValidateUser.validateBasicString(genderController.text) &&
        genderController.text != '') {
      errors[3] = 'Invalid gender';
    }

    if (!ValidateUser.validateBasicString(gameController.text) &&
        gameController.text != '') {
      errors[4] = 'Invalid prefered game';
    }

    if (errors.any((error) => error != null)) {
      setState(() {
        print('Errors: $errors'); // Debugging check
      });
      return;
    }
    setState(() {});

    try {
      // Retrieve token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String code = prefs.getString('token') ?? '';

      // Hash or encrypt everything
      final key = encrypt.Key.fromLength(32); // 32 bytes for AES256 encryption
      final iv = encrypt.IV.fromLength(16); // 16 bytes for AES
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final String hashedPassword;
      if (password == pwcheck) {
        hashedPassword = generateHashCode(password);
      } else {
        throw Exception("Passwords don't match");
      }

      String encryptedGender = 'empty';
      if (gender.isNotEmpty) {
        encryptedGender = encrypter.encrypt(gender, iv: iv).base64;
      }

      String encryptedPrefGame = 'empty';
      if (prefgame.isNotEmpty) {
        encryptedPrefGame = encrypter.encrypt(prefgame, iv: iv).base64;
      }

      // Throw everything into the database
      await APIService.updateMember(code, nickname, hashedPassword,
          selectedImage.toString(), gender, prefgame);

      // Attempt login
      await APIService.login(nickname, hashedPassword);

      // Navigate to the home page after successful login
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pushNamed(context, '/');
    } catch (e) {
      print('Registering member failed! $e');
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
                              hintText: 'Nickname*',
                              obscureText: false,
                              errorText: errors.isNotEmpty ? errors[0] : null,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: passwordController,
                              hintText: 'Password*',
                              obscureText: true,
                              errorText: errors.isNotEmpty ? errors[1] : null,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: pwcheckController,
                              hintText: 'Repeat Password*',
                              obscureText: true,
                              errorText: errors.isNotEmpty ? errors[2] : null,
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: genderController,
                              hintText: 'Gender',
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
                              images: images,
                              onImageSelected: (String? image) {
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

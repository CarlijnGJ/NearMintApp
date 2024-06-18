import 'dart:convert';
import 'dart:math';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/components/textfield.dart';
import 'package:app/components/button.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:app/services/api_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  bool isError = false;
  String errorMessage = '';
  List<String?> errors = [];
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phonenumberController = TextEditingController();
  var secret = '';

  String generateRandomCode() {
    const String chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var random = Random();
    String code = '';
    int prevIndex = -1; // Store the index of the previously selected character

    for (int i = 0; i < 6; i++) {
      int index;
      do {
        index = random.nextInt(chars.length);
      } while (index == prevIndex ||
          (i > 0 &&
              code[i - 1] ==
                  chars[
                      index])); // Repeat if the current character is the same as the previous one

      code += chars[index];
      prevIndex = index;
    }

    return code;
  }

  String generateHashCode(String code) {
    var bytes = utf8.encode(code); // Convert the code to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return digest.toString(); // Convert the digest to a string
  }

  void addMember() async {
    final username = usernameController.text;
    final email = emailController.text;
    final phoneNumber = phonenumberController.text;

    errors = List.filled(3, null);
    if (!ValidateUser.validateBasicString(username)) {
      errors[0] = 'Invalid username';
    }

    if (!ValidateUser().validateEmail(email)) {
      errors[1] = 'Invalid email';
    }

    if (!ValidateUser().validatePhoneNumber(phoneNumber)) {
      errors[2] = 'Invalid phone number';
    }

    if (errors.any((error) => error != null)) {
      setState(() {
        print('Errors: $errors'); // Debugging check
      });
      return;
    }

    try {
      final key = encrypt.Key.fromLength(32); // 32 bytes for AES256 encryption
      final iv = encrypt.IV.fromLength(16); // 16 bytes for AES
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      secret = generateRandomCode();
      
      String hashedSecret = generateHashCode(secret);
      // final encryptedUsername = encrypter.encrypt(username, iv: iv).base64;
      final encryptedEmail = encrypter.encrypt(email, iv: iv).base64;
      final encryptedPhoneNumber =
          encrypter.encrypt(phoneNumber, iv: iv).base64;
      await APIService.addMember(
          username, email, phoneNumber, hashedSecret);
      setState(() {
        
      });
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'Adding member failed: $e';
      });
    }
  }

  Future<String> fetchRole() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        return APIService.getRole(sessionKey);
      }
      throw 'User';
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'Failed to fetch member data: $e';
      });
    }
    return 'User';
  }

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    String role = await fetchRole();
    print(role);
    if (role != 'Admin') {
      setState(() {
        isError = true;
        errorMessage = 'Please login again'; // User is not an admin
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: isError
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            )
          : Stack(
              children: [
                SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Add Member',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: usernameController,
                          hintText: 'Username',
                          obscureText: false,
                          errorText: errors.isNotEmpty ? errors[0] : null,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          errorText: errors.length > 1 ? errors[1] : null,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: phonenumberController,
                          hintText: 'Phone number',
                          obscureText: false,
                          errorText: errors.length > 2 ? errors[2] : null,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(text: 'Send code', onTap: addMember),
                        Text(secret ?? ''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

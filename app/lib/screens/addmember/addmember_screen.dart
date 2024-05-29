
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


class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
    List<String?> errors = [];
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phonenumberController = TextEditingController();

  String generateRandomCode() {
    var random = Random();
    int code = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
    return code.toString();
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
  if (!ValidateUser().validateUsername(username)) {
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

    try{
      final key = encrypt.Key.fromLength(32); // 32 bytes for AES256 encryption
      final iv = encrypt.IV.fromLength(16); // 16 bytes for AES
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final secret = generateRandomCode();
      print(secret);
      String hashedSecret = generateHashCode(secret);
      final encryptedUsername = encrypter.encrypt(username, iv: iv).base64;
      final encryptedEmail = encrypter.encrypt(email, iv: iv).base64;
      final encryptedPhoneNumber = encrypter.encrypt(phoneNumber, iv: iv).base64;
      await APIService.addMember(encryptedUsername, encryptedEmail, encryptedPhoneNumber, hashedSecret);
    }

    catch(e){
      print('Adding member failed!');
    }
  }

    @override
  void initState() {
    super.initState();
    // check role
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
                      'Add Member',
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
                      errorText: errors.isNotEmpty ? errors[0] : null,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
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
                  ],
                ),
              ),
            ),
          ],
        ));
  }


}
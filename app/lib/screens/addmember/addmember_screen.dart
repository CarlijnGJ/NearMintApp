
import 'dart:convert';
import 'dart:math';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/components/textfield.dart';
import 'package:app/components/button.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';


class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
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

    List<String> errors = [];

    if (!ValidateUser().validateUsername(username)) {
      errors.add('Invalid username');
    }

    if (!ValidateUser().validateEmail(email)) {
      errors.add('Invalid email');
    }

    if (!ValidateUser().validatePhoneNumber(phoneNumber)) {
      errors.add('Invalid phone number');
    }

    if (errors.isNotEmpty) {
      errors.forEach((error) => print(error));
      // Show the errors to the user
      return;
    }

    final secret = generateRandomCode();
    String hashedSecret = generateHashCode(secret);

    try{
      await APIService.addMember(username, email, phoneNumber, hashedSecret);
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
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    CustomTextField(
                      controller: phonenumberController,
                      hintText: 'Phone number',
                      obscureText: false,
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
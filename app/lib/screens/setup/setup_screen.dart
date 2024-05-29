import 'dart:developer';

import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/textfield.dart';
import 'package:app/components/button.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  final String name;

  const SetupPage(this.name, {Key? key}) : super(key: key);

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
    {'name': 'Magic', 'path': '../../Images/ProfilePics/PFP1.png'},
    {'name': 'Sea', 'path': '../../Images/ProfilePics/PFP2.png'},
    {'name': 'Skull', 'path': '../../Images/ProfilePics/PFP3.png'},
    {'name': 'Vanguard', 'path': '../../Images/ProfilePics/PFP4.png'},
    {'name': 'Lorcana', 'path': '../../Images/ProfilePics/PFP5.png'},
    {'name': 'OnePiece', 'path': '../../Images/ProfilePics/PFP6.png'},
  ];

  void finishRegister() {
    log("Data: ${nicknameController.text}, ${passwordController.text}, ${pwcheckController.text}, ${genderController.text}, ${gameController.text}.");
    errors = List.filled(5, null);
    if (!ValidateUser().validateBasicString(nicknameController.text)) {
      errors[0] = 'Invalid username';
    }

    if (!ValidateUser().validatePassword(passwordController.text)) {
      errors[1] = 'Invalid password';
    }

    if (pwcheckController.text != passwordController.text) {
      errors[2] = 'Passwords don\'t match';
    }

    if (!ValidateUser().validateBasicString(genderController.text) && genderController.text != '') {
      errors[3] = 'Invalid gender';
    }

    if (!ValidateUser().validateBasicString(gameController.text) && gameController.text != '') {
      errors[4] = 'Invalid prefered game';
    }
    

    if (errors.any((error) => error != null)) {
      setState(() {
        print('Errors: $errors'); // Debugging check
      });
      return;
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const TealGradLeft(),
                    const TealGradRight(),

                    SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),

                          Text(
                            'Hello, ${widget.name}',
                            style: const TextStyle(
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
                            hintText: 'Nickname',
                            obscureText: false,
                            errorText: errors.isNotEmpty ? errors[0] : null,
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                  errorText: errors.isNotEmpty ? errors[1] : null,

                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: CustomTextField(
                                  controller: pwcheckController,
                                  hintText: 'Repeat Password',
                                  obscureText: true,
                                  errorText: errors.isNotEmpty ? errors[2] : null,

                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          const Divider(),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: genderController,
                                  hintText: 'Gender*',
                                  obscureText: false,
                                  errorText: errors.isNotEmpty ? errors[3] : null,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: CustomTextField(
                                  controller: gameController,
                                  hintText: 'Preferred Game*',
                                  obscureText: false,
                                  errorText: errors.isNotEmpty ? errors[4] : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          if (selectedImage != null && selectedImage!.isNotEmpty)
                            Image.asset(selectedImage!, width: 200, height: 200)
                          else
                            const SizedBox.shrink(),

                          const SizedBox(height: 10),

                          DropdownButton<String>(
                            hint: const Text('Select an image'),
                            value: selectedImage,
                            items: images.map((image) {
                              return DropdownMenuItem<String>(
                                value: image['path'],
                                child: Row(
                                  children: [
                                    Image.asset(
                                      image['path']!,
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(image['name']!),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedImage = newValue.toString();
                              });
                            },
                          ),

                          const Text(
                            '* = Optional',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          CustomButton(text: 'Finish registration', onTap: finishRegister)
                        ],
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
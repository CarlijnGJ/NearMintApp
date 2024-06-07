import 'dart:convert';
import 'dart:developer';

import 'package:app/components/customexception.dart';
import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/textfield.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/services/api_service.dart';
import 'package:app/util/error_util.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:app/components/button.dart';
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

  late List<TextEditingController> controllers;


  @override
  void initState() {
    super.initState();

    controllers = [
      nicknameController,
      passwordController,
      pwcheckController,
      genderController,
      gameController,
    ];
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
    
    errors = ErrorUtil.generateSetupErrors(controllers);
    

    if (errors.any((error) => error != null)) {
      setState(() {
        print('Errors: $errors'); // Debugging check
      });
      return;
    }
    setState((){});

    try{
      //Retrieve token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String code = prefs.getString('token').toString();
      //Hash or encrypt everything
      final key = encrypt.Key.fromLength(32); // 32 bytes for AES256 encryption
      final iv = encrypt.IV.fromLength(16); // 16 bytes for AES
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      // final encryptedNickname = encrypter.encrypt(nickname, iv: iv).base64;
      final String hashedPassword;
      if (password == pwcheck) {
        hashedPassword = generateHashCode(password);
      } else {
        throw Exception("Passwords don't match");
      }
      String encryptedGender = 'empty';
      if(gender != '') {
        encryptedGender = encrypter.encrypt(gender, iv: iv).base64;
      }
      
      String encryptedPrefGame = 'empty';
      if(prefgame != '') {
        encryptedPrefGame = encrypter.encrypt(prefgame, iv: iv).base64;
      }

      //Throw everything into the database
      await APIService.updateMember(code, nickname, hashedPassword, selectedImage.toString(), encryptedGender, encryptedPrefGame);
            // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login');
    }

    catch(e){
      if (e is HttpExceptionWithStatusCode) {
        errors[0] = "This nickname is already in use";
        setState(() {
          
        });
      }

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
                    const TealGradLeft(),
                    const TealGradRight(),

                    SafeArea(
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

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: passwordController,
                                  hintText: 'Password*',
                                  obscureText: true,
                                  errorText: errors.isNotEmpty ? errors[1] : null,

                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: CustomTextField(
                                  controller: pwcheckController,
                                  hintText: 'Repeat Password*',
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
                                  hintText: 'Gender',
                                  obscureText: false,
                                  errorText: errors.isNotEmpty ? errors[3] : null,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: 'None',
                                  decoration: InputDecoration(
                                    labelText: 'Preferred Game',
                                    errorText: errors.isNotEmpty ? errors[4] : null,
                                  ),
                                  items: <String>[
                                    'None',
                                    'Magic the Gathering',
                                    'Warhammer',
                                    'One piece card game',
                                    'Vanguard',
                                    'The Pokemon Trading Card Game',
                                    'Disney Lorcana',
                                    'Video Games',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      gameController.text = newValue!;
                                    });
                                  },
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
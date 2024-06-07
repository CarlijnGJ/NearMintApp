  import 'package:app/components/button.dart';
  import 'package:app/components/textfield.dart';
  import 'package:app/services/api_service.dart';
import 'package:app/util/error_util.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/rendering.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class EditMemberPage extends StatefulWidget {

    const EditMemberPage({Key? key}) : super(key: key);

    @override
    _EditMemberPageState createState() =>
        _EditMemberPageState();
  }

  class _EditMemberPageState extends State<EditMemberPage> {
    String accountInfo = '';
    late TextEditingController nicknameController;
    late TextEditingController genderController;
    late TextEditingController prefgameController;
    late String nickname = '';
    late String gender = '';
    late String prefgame= '';
    late String avatar ='';


    String? selectedImage;

    late List<String?> errors = [];
    late List<TextEditingController> controllers;

    final List<Map<String, String>> images = [
      {'name': 'Magic', 'path': '../../Images/ProfilePics/PFP1.png'},
      {'name': 'Sea', 'path': '../../Images/ProfilePics/PFP2.png'},
      {'name': 'Skull', 'path': '../../Images/ProfilePics/PFP3.png'},
      {'name': 'Vanguard', 'path': '../../Images/ProfilePics/PFP4.png'},
      {'name': 'Lorcana', 'path': '../../Images/ProfilePics/PFP5.png'},
      {'name': 'OnePiece', 'path': '../../Images/ProfilePics/PFP6.png'},
    ];

    List<String> gameOptions = [
    'None',
    'Magic the Gathering',
    'Warhammer',
    'One piece card game',
    'Vanguard',
    'The Pokemon Trading Card Game',
    'Disney Lorcana',
    'Video Games',
  ];

  // Ensure prefgame is not null and is present in gameOptions
  String initialValue = 'None';

    @override
    void initState() {
      super.initState();
      nicknameController = TextEditingController(text: accountInfo);
      genderController = TextEditingController(text: accountInfo);
      prefgameController = TextEditingController(text: accountInfo);

      controllers = [
        nicknameController,
        genderController,
        prefgameController,
      ];

      fetchMemberData();
    }

    @override
    void dispose() {
      nicknameController.dispose();
      genderController.dispose();
      prefgameController.dispose();
      super.dispose();
    }
  //reuse
  Future<void> fetchMemberData() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final sessionKey = prefs.getString('session_key');
        if (sessionKey != null) {
          Map<String, dynamic> memberData = await APIService.getMember(sessionKey);
          setState(() {
            nickname = memberData['nickname'];
            avatar = memberData['avatar'];
            bool avatarExistsInList = images.any((element) => element['path'] == avatar);
  if (!avatarExistsInList && avatar.isNotEmpty) {
    images.insert(0, {'name': 'Avatar', 'path': avatar});

  }    selectedImage = avatar; // Set selectedImage to the avatar path

            gender = memberData['gender'];
            prefgame = memberData['prefgame'];
            initialValue = gameOptions.contains(prefgame) ? prefgame : 'None';
            // isLoading = false;
            // isError = false;
          });
        } else {
          setState(() {
            // isLoading = false;
            // isError = true;
            // errorMessage = 'Please login again'; //Session key is not available
          });
        }
      } catch (e) {
        setState(() {
          // isLoading = false;
          // isError = true;
          // errorMessage = 'Failed to fetch member data: $e';
        });
      }
    }  

    Future<void> updateAccountInfo(String newInfo) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final sessionKey = prefs.getString('session_key');

        errors = ErrorUtil.generateEditErrors(controllers);
    

        if (errors.any((error) => error != null)) {
          setState(() {
            print('Errors: $errors'); // Debugging check
          });
          return;
        }
        setState((){});

        await APIService.editMember(
          sessionKey: sessionKey!,
          nickname: nicknameController.text.isNotEmpty ? nicknameController.text : null,
          gender: genderController.text.isNotEmpty ? genderController.text : null,
          prefgame: prefgameController.text.isNotEmpty ? prefgameController.text : null,
          avatar: selectedImage,
        );

        Navigator.pushReplacementNamed(context, '/profile');

      }
      catch(e) {
        print(e);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Member'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: nicknameController,
                labelText: 'Nickname', 
                obscureText: false,
                hintText: nickname,
                errorText: errors.isNotEmpty ? errors[0] : null,
              ),
              CustomTextField(
                controller: genderController,
                labelText: 'Gender', 
                obscureText: false,
                hintText: gender,
                errorText: errors.isNotEmpty ? errors[1] : null,
              ),
              Row(
                children: [


              Expanded(
                child: DropdownButtonFormField<String>(
                  value: initialValue,
                  decoration: InputDecoration(
                    labelText: 'Preferred Game',
                    // errorText: errors.isNotEmpty ? errors[4] : null,
                  ),
                  items: gameOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      prefgameController.text = newValue!;
                    });
                  },
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  hint: const Text('Select an image'),
                  value: selectedImage,
                  items: images.map((image) {
                    return DropdownMenuItem<String>(
                      value: image['path'],
                      child: Row(
                        children: [
                          if (image['name'] == 'Avatar')
                            CircleAvatar(
                              backgroundImage: AssetImage(image['path']!),
                              radius: 25,
                            )
                          else
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
                      selectedImage = newValue.toString(); // Update selectedImage
                    });
                  },
                ),
              ),


                  SizedBox(width: 20), // Add some spacing between the dropdowns and the avatar

                ],
              ),     
              SizedBox(height: 20),
              CustomButton(
                onTap: () {
                  updateAccountInfo('');
                }, text: 'Save Changes',
              ),
            ],
          ),
        ),
      );
    }
  }
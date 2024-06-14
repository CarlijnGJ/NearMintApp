import 'package:app/components/button.dart';
import 'package:app/components/textfield.dart';
import 'package:app/screens/setup/components/prefered_game_picker.dart';
import 'package:app/screens/setup/components/profile_image_picker.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMemberPage extends StatefulWidget {
  const EditMemberPage({Key? key}) : super(key: key);

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  String accountInfo = '';
  late TextEditingController nicknameController;
  late TextEditingController genderController;
  late TextEditingController prefgameController;
  late String nickname = '';
  late String gender = '';
  late String prefgame = '';
  late String avatar = '';

  String? selectedImage;

  final List<Map<String, String>> images = [
    {'name': 'Magic', 'path': '../../Images/ProfilePics/PFP1.png'},
    {'name': 'Sea', 'path': '../../Images/ProfilePics/PFP2.png'},
    {'name': 'Skull', 'path': '../../Images/ProfilePics/PFP3.png'},
    {'name': 'Vanguard', 'path': '../../Images/ProfilePics/PFP4.png'},
    {'name': 'Lorcana', 'path': '../../Images/ProfilePics/PFP5.png'},
    {'name': 'OnePiece', 'path': '../../Images/ProfilePics/PFP6.png'},
  ];

  // Ensure prefgame is not null and is present in gameOptions
  String initialValue = 'None';

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController(text: accountInfo);
    genderController = TextEditingController(text: accountInfo);
    prefgameController = TextEditingController(text: accountInfo);
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
        Map<String, dynamic> memberData =
            await APIService.getMember(sessionKey);
        setState(() {
          nickname = memberData['nickname'];
          avatar = memberData['avatar'];
          bool avatarExistsInList =
              images.any((element) => element['path'] == avatar);
          if (!avatarExistsInList && avatar.isNotEmpty) {
            images.insert(0, {'name': 'Avatar', 'path': avatar});
          }
          selectedImage = avatar; // Set selectedImage to the avatar path

          gender = memberData['gender'];
          prefgame = memberData['prefgame'];
          initialValue = prefgame ?? 'None';
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

      await APIService.editMember(
        sessionKey: sessionKey!,
        nickname:
            nicknameController.text.isNotEmpty ? nicknameController.text : null,
        gender: genderController.text.isNotEmpty ? genderController.text : null,
        prefgame:
            prefgameController.text.isNotEmpty ? prefgameController.text : null,
        avatar: selectedImage,
      );

      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
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
            ),
            CustomTextField(
              controller: genderController,
              labelText: 'Gender',
              obscureText: false,
              hintText: gender,
            ),
            Center(
              child: Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: PreferredGameDropdown(
                        initialValue: 'None',
                        onChanged: (String? newValue) {
                          setState(() {
                            prefgameController.text = newValue ?? 'None';
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: ProfileImagePicker(
                        selectedImage: selectedImage,
                        images: images,
                        onImageSelected: (String? image) {
                          setState(() {
                            selectedImage = image;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onTap: () {
                updateAccountInfo('');
              },
              text: 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }
}

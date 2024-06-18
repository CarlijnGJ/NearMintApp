import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/components/button.dart';
import 'package:app/components/textfield.dart';
import 'package:app/screens/setup/components/prefered_game_picker.dart';
import 'package:app/screens/setup/components/profile_image_picker.dart';
import 'package:app/services/api_service.dart';

class EditMemberPage extends StatefulWidget {
  const EditMemberPage({Key? key}) : super(key: key);

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  late TextEditingController nicknameController;
  late TextEditingController genderController;
  late TextEditingController prefgameController;
  String nickname = '';
  String gender = '';
  String prefgame = '';
  Map<String, String>? avatar;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController();
    genderController = TextEditingController();
    prefgameController = TextEditingController();
    fetchMemberData();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    genderController.dispose();
    prefgameController.dispose();
    super.dispose();
  }

  Future<void> fetchMemberData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        Map<String, dynamic> memberData =
            await APIService.getMember(sessionKey);
        setState(() {
          nickname = memberData['nickname'];
          avatar = {'name': 'Avatar', 'path': memberData['avatar']};
          gender = memberData['gender'];
          prefgame = memberData['prefgame'] ?? '';
          nicknameController.text = nickname;
          genderController.text = gender;
          prefgameController.text = prefgame;
        });
      } else {
        // Handle session key not available
      }
    } catch (e) {
      // Handle fetch failure
    }
  }

  Future<void> updateAccountInfo() async {
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
        avatar: avatar != null ? avatar!['path'] : null,
      );
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      print('Failed to update member: $e');
      // Handle update failure
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
          
          children: [
            CustomTextField(
              controller: nicknameController,
              labelText: 'Nickname',
              obscureText: false,
              hintText: 'Enter nickname',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: genderController,
              labelText: 'Gender',
              obscureText: false,
              hintText: 'Enter gender',
            ),
            const SizedBox(height: 10),
            PreferredGameDropdown(
              initialValue: 'None',
              onChanged: (String? newValue) {
                setState(() {
                  prefgameController.text = newValue ?? 'None';
                });
              },
            ),
            const SizedBox(height: 10),
            ProfileImagePicker(
              selectedImage: avatar,
              onImageSelected: (Map<String, String>? image) {
                setState(() {
                  avatar = image;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {
                updateAccountInfo();
              },
              text: 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }
}

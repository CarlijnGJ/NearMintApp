import 'package:app/util/auth_check_util.dart';
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
  // ignore: library_private_types_in_public_api
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
    CheckAuthUtil.MemberOrAdmin(context);
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
          nicknameController.text = '';
          genderController.text = '';
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
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/profile');
    // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          
          children: [
            CustomTextField(
              controller: nicknameController,
              labelText: 'Nickname',
              obscureText: false,
              hintText: nickname,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: genderController,
              labelText: 'Gender',
              obscureText: false,
              hintText: gender,
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

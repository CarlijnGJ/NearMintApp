import 'package:app/components/button.dart';
import 'package:app/components/textfield.dart';
import 'package:flutter/material.dart';

class EditMemberPage extends StatefulWidget {
  final String sessionKey;

  const EditMemberPage({required this.sessionKey});

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  String accountInfo = '';
  late TextEditingController _textEditingController;
    String? selectedImage;

  final List<Map<String, String>> images = [
    {'name': 'Magic', 'path': '../../Images/ProfilePics/PFP1.png'},
    {'name': 'Sea', 'path': '../../Images/ProfilePics/PFP2.png'},
    {'name': 'Skull', 'path': '../../Images/ProfilePics/PFP3.png'},
    {'name': 'Vanguard', 'path': '../../Images/ProfilePics/PFP4.png'},
    {'name': 'Lorcana', 'path': '../../Images/ProfilePics/PFP5.png'},
    {'name': 'OnePiece', 'path': '../../Images/ProfilePics/PFP6.png'},
  ];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: accountInfo);
    retrieveAccountInfo();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void retrieveAccountInfo() {
    // Your API call here
  }

  void updateAccountInfo(String newInfo) {
    // Your API call here
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
              controller: _textEditingController,
              labelText: 'Nickname', 
              obscureText: false
            ),
            CustomTextField(
              controller: _textEditingController,
              labelText: 'Gender', 
              obscureText: false
            ),
Row(
  children: [
    Expanded(
      child: DropdownButtonFormField<String>(
        value: 'None',
        decoration: InputDecoration(
          labelText: 'Preferred Game',
          // errorText: errors.isNotEmpty ? errors[4] : null,
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
            _textEditingController.text = newValue!;
          });
        },
      ),
    ),
    SizedBox(width: 20), // Add some spacing between the dropdowns
    Expanded(
      child: DropdownButton<String>(
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
    ),
  ],
),           
            SizedBox(height: 20),
            CustomButton(
              onTap: () {
                updateAccountInfo(_textEditingController.text);
              }, text: 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }
}
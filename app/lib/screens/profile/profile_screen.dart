import 'package:app/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? nickname;
  String? name;
  String? avatar;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Fetch member data when the profile page initializes
    fetchMemberData();
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
          name = memberData['name'];
          avatar = memberData['avatar'];
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = 'Please login again'; //Session key is not available
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = 'Failed to fetch member data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      avatar != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Image.asset(
                                // Use the local asset path
                                avatar!,
                                width: 100,
                                height: 100,
                                // You can set other properties like fit, etc.
                              ),
                            )
                          : SizedBox(), // Placeholder if no avatar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.only(bottom: 16.0)),
                          Text(
                            'Nickname: ${nickname ?? ''}',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          Text(
                            'Name: ${name ?? ''}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

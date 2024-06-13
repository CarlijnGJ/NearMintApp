import 'package:flutter/material.dart';

class ProfileInformation extends StatelessWidget {
  final String? avatar;
  final String? nickname;
  final String? name;
  final String? gender;
  final String? preferedGame;

  ProfileInformation({
    this.avatar,
    this.nickname,
    this.name,
    this.gender,
    this.preferedGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          avatar!,
                          width: 50,
                          height: 50,
                        ),
                      )
                    : const Icon(Icons.person, size: 50),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, '/editmember');
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nickname: ${nickname ?? 'Empty'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Name: ${name ?? 'Empty'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Gender: ${gender ?? 'Empty'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Preferred game: ${preferedGame ?? 'Empty'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
                            
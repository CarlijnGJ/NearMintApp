import 'package:flutter/material.dart';

class ProfileInformation extends StatelessWidget {
  final String? avatar;
  final String? nickname;
  final String? name;
  final String? gender;
  final String? preferedGame;

  const ProfileInformation({super.key, 
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
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar or default icon and edit button
                Column(
                  children: [
                    if (avatar != null) Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Image.asset(
                              avatar!,
                              width: 50,
                              height: 50,
                            ),
                          ) else const Icon(Icons.person, size: 50),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(context, '/editmember');
                      },
                    ),
                  ],
                ),
                // Profile information details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nickname
                      Text(
                        'Nickname: ${nickname ?? 'Empty'}',
                        style: const TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Name
                      Text(
                        'Name: ${name ?? 'Empty'}',
                        style: const TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Gender
                      Text(
                        'Gender: ${gender ?? 'Empty'}',
                        style: const TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Preferred game
                      Text(
                        'Preferred game: ${preferedGame ?? 'Empty'}',
                        style: const TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

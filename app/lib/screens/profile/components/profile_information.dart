import 'package:flutter/material.dart';

class ProfileInformation extends StatelessWidget {
  final String? avatar;
  final String? nickname;
  final String? name;
  final String? gender;
  final String? preferredGame;

  const ProfileInformation({
    Key? key,
    this.avatar,
    this.nickname,
    this.name,
    this.gender,
    this.preferredGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: avatar != null
                ? Image.asset(
                    avatar!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                  ),
          ),
          const SizedBox(width: 16),
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
                  'Preferred game: ${preferredGame ?? 'Empty'}',
                  style: const TextStyle(fontSize: 14.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Edit button
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/editmember');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

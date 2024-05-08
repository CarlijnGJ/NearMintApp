import 'package:flutter/material.dart';

import 'package:app/components/titlesection.dart';
import 'package:app/components/textsection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight), // Adjust based on app bar height
          const TitleSection(
            name: 'Welcome!',
          ),
          const SizedBox(height: 16.0),
          const TextSection(
            description:
            'We are thrilled to invite players of all levels and interests to come '
            'and experience our brand new store. Our doors are open 7 days a week '
            'from 12:00-22:00, offering a convenient and welcoming destination for '
            'gamers to gather and enjoy their favorite games. Whether you\'re a '
            'seasoned player or new to the world of gaming, Near Mint Gaming has '
            'something for everyone. Our store features a wide selection of games, '
            'tournaments, and events that are sure to appeal to players of all ages '
            'and skill levels. So if you\'re looking for a fun and inclusive community '
            'to join, look no further than Near Mint Gaming! We\'re excited to meet '
            'you, and can\'t wait to see you at our store soon.',
          ),
          const SizedBox(height: 16.0),
          const TextSection(
            description:
            'At Near Mint Gaming, we believe that everyone should be able to enjoy '
            'the fun and excitement of gaming, regardless of their skill level or '
            'experience. That\'s why we welcome players of all backgrounds and '
            'abilities to come and participate in our free play tournaments or simply '
            'hang out and enjoy the atmosphere. Our store is designed to be a safe '
            'and inclusive space where gamers can come together to connect, compete, '
            'and have fun. Whether you\'re a competitive player looking to test your '
            'skills, or a casual gamer looking for a relaxed and friendly environment, '
            'you\'ll find exactly what you\'re looking for at Near Mint Gaming. \n\n'
            'So don\'t be shy - come on down and join us for a game or two! We can\'t '
            'wait to meet you and welcome you to our growing community of gamers.',
          ),
        ],
      ),
    );
  }
}

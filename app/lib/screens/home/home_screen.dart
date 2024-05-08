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
            name: 'Near Mint Mobile',
            location: 'Steenwijk, Nederland',
          ),
          const SizedBox(height: 16.0),
          const TextSection(
            description:
            'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
            'Bernese Alps. Situated 1,578 meters above sea level, it '
            'is one of the larger Alpine Lakes. A gondola ride from '
            'Kandersteg, followed by a half-hour walk through pastures '
            'and pine forest, leads you to the lake, which warms to 20 '
            'degrees Celsius in the summer. Activities enjoyed here '
            'include rowing, and riding the summer toboggan run.',
          ),
        ],
      ),
    );
  }
}

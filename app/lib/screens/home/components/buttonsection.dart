import 'package:flutter/material.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({
    super.key,
    required this.assetname,
    required this.description,
  });

  final String assetname;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color.fromRGBO(0, 0, 0, 0.25),
          child: Column(
            children: [
              Image.asset(assetname),
              Text(
                description,
                style: const TextStyle(fontSize: 32),
              )
            ],
          )
        ),
      )
    );
  }
}
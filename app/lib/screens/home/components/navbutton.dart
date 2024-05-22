import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.assetname,
    required this.description,
    required this.url,
  });

  final String assetname;
  final String description;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, url);
        },
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
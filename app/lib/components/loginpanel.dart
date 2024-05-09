import 'package:flutter/material.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromRGBO(0, 0, 0, 0.25),
        child: Text(
          description,
          softWrap: true,
        )
      )
    );
  }
}
import 'package:flutter/material.dart';

class TealGradRight extends StatelessWidget {
  const TealGradRight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Colors.teal],
            stops: [0.5, 1],
          ),
        ),
      ),
    );
  }
}
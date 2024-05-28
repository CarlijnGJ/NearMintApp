import 'package:flutter/material.dart';

class TealGradLeft extends StatelessWidget {
  const TealGradLeft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [Colors.teal, Colors.transparent],
              stops: [0.0, 0.5],
            ),
          ),
        ),
      ),
    );
  }
}
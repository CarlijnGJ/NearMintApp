import 'package:flutter/material.dart';

class LoginErrorWidget extends StatelessWidget {
  const LoginErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text('Error 401'),
      ),
      body: const Center(
        child: Column(
          children: [
          SizedBox(height: 20), // Adjust the spacing between icon and text
          Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(width: 8), // Adjust the spacing between icon and text
        Text(
          'Not authorized to access this page.',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
          ],
        ),
      ),
    );

  }
}

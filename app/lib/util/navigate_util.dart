import 'package:flutter/material.dart';

class NavigateUtil {
  // Navigate to home to refresh and clean the navigation stack
  static void navigateToHome(BuildContext context) {
    try {
      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
    } catch (e) {
      throw ('Error popping context: $e');
    }
  }
}

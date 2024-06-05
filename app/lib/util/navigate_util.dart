import 'package:flutter/material.dart';

class NavigateUtil {
  static void navigateTo(BuildContext context, String route) {
    try {
      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
    } catch (e) {
      print('Error popping context: $e');
    }
    Navigator.pushNamed(context, route);
  }
}

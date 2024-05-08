import 'package:flutter/material.dart';

final ThemeData mainTheme = ThemeData (
  // Define the default brightness and colors.
  colorScheme: const ColorScheme(
    primary: Color(0xFF4E4E4E),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 0, 75, 16),
    onSecondary: Colors.white,
    tertiary: Colors.black,
    onTertiary: Colors.white,
    background: Color(0xFF4E4E4E),
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.dark
  )
);
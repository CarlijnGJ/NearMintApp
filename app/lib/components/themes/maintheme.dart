import 'package:flutter/material.dart';

final ThemeData mainTheme = ThemeData (
  // Define the default brightness and colors.
  colorScheme: const ColorScheme(
    primary: Color.fromRGBO(0, 60, 67, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(19, 93, 102, 1),
    onSecondary: Colors.white,
    tertiary: Color.fromRGBO(119, 176, 170, 1),
    onTertiary: Colors.black,
    background: Color.fromRGBO(0, 60, 67, 1),
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.dark
  )
);
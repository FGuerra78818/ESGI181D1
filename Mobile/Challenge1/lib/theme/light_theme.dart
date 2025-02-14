import 'package:flutter/material.dart';

ThemeData lightTheme1 = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xFF555555),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFFF0C2),        // Your primary color
    onPrimary: Colors.black87,      // Color for text/icons on primary
    secondary: Color(0xFFBDBDBD),      // Your secondary color
    onSecondary: Color(0xFFE0E0E0),    // Color for text/icons on secondary
    tertiary: Colors.black87,
    error: Color(0xFFB00020),          // Error color
    onError: Color(0xFFFFFFFF),        // Color for text/icons on error
    surface: Color(0xFFFFFFFF),        // Surface color for cards, sheets, etc.
    onSurface: Colors.black,      // Color for text on surface
  ),
);
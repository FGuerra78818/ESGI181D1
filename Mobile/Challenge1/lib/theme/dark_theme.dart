import 'package:flutter/material.dart';

ThemeData darkTheme1 = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.dark,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xFF717171),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF141F2A), // Vibrant purple for primary
    onPrimary: Colors.white70, // Darker shade for text/icons on primary
    secondary: Color(0xFF1B2937), // Teal for accents
    onSecondary: Color(0xFF223344), // Dark teal for text/icons on secondary
    tertiary: Color(0xFF437589), // Teal for accents
    error: Color(0xFFCF6679), // Soft red for errors
    onError: Color(0xFF1C1C1E), // Dark background for error text/icons
    surface: Color(0xFF151B23), // Slightly lighter surface color for cards/sheets
    onSurface: Color(0xFFE4E4E4), // Light grey text/icons on surfaces
  ),
);

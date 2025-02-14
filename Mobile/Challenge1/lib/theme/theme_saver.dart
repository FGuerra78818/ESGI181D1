import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSaver {
  static const String _themeKey = 'theme_mode';

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.toString());
  }

  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey) ?? ThemeMode.system.toString();
    return ThemeMode.values.firstWhere((e) => e.toString() == themeModeString);
  }
}

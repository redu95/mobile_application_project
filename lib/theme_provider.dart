import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> updateUserThemePreference(String userId, bool isDarkModeEnabled) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'isDarkModeEnabled': isDarkModeEnabled,
  });
}
class ThemeSettings extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();  // Default theme is light
  ThemeData get currentTheme => _currentTheme;  // Getter for the current theme
  bool _isDarkModeEnabled = false;// Flag to track if dark mode is enabled
  bool get isDarkModeEnabled => _isDarkModeEnabled;

  ThemeSettings(bool isDark) {
    _isDarkModeEnabled = isDark;
    if (_isDarkModeEnabled) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }
  }


Future<void> setThemeMode(ThemeMode themeMode, String userId) async {
  if (themeMode == ThemeMode.dark) {
    _isDarkModeEnabled = true;
    _currentTheme = ThemeData.dark();
  } else {
    _isDarkModeEnabled = false;
    _currentTheme = ThemeData.light();
  }
  notifyListeners();
  await updateUserThemePreference(userId, _isDarkModeEnabled);// Notify the listeners (typically the UI) that the theme has changed
}
}


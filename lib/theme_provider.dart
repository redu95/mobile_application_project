import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


void setThemeMode(ThemeMode themeMode) {
  if (themeMode == ThemeMode.dark) {
    _isDarkModeEnabled = true;
    _currentTheme = ThemeData.dark();
  } else {
    _isDarkModeEnabled = false;
    _currentTheme = ThemeData.light();
  }
  notifyListeners(); // Notify the listeners (typically the UI) that the theme has changed
}
}


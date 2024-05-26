import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  ThemeSettings() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
          'users').doc(user.uid).get();
      if (userDoc.exists) {
        _isDarkModeEnabled = userDoc['isDarkModeEnabled'] ?? false;
        _currentTheme =
        _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light();
        notifyListeners();
      }
    }
  }
  Future<void> setThemeMode(bool isDarkMode, String userId) async {
    _isDarkModeEnabled = isDarkMode;
    _currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isDarkModeEnabled': isDarkMode,
    });
  }
}


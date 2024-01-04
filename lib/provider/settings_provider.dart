import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

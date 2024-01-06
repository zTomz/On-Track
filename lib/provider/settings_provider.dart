import 'package:flutter/material.dart';
import 'package:planer/models/storage.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _themeMode = Storage.loadThemeMode();
  }

  // ignore: prefer_final_fields
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;

    await Storage.saveThemeMode(themeMode);

    notifyListeners();
  }
}

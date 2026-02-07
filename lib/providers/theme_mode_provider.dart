import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    _mode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

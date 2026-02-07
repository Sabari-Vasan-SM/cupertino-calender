import 'package:flutter/foundation.dart';

class ThemeModeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void setDarkMode(bool enabled) {
    _isDark = enabled;
    notifyListeners();
  }
}

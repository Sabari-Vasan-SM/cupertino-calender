import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  static const String _storageKey = 'is_dark_mode';

  bool _isDark = false;

  ThemeModeProvider() {
    _loadFromPrefs();
  }

  bool get isDark => _isDark;

  void setDarkMode(bool enabled) {
    _isDark = enabled;
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_storageKey);
    if (saved == null) {
      return;
    }
    _isDark = saved;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, _isDark);
  }
}

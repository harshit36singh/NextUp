import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _themeKey = 'isDarkMode';
  
  bool _isDarkMode = true;
  Box? _box;

  bool get isDarkMode => _isDarkMode;

  Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);
    _isDarkMode = _box?.get(_themeKey, defaultValue: true) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _box?.put(_themeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

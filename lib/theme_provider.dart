import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _accentColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;

  ThemeProvider() {
    _loadThemePreferences();
  }

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString());
  }

  void setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', color.value);
  }

  void setBackgroundColor(Color color) async {
    _backgroundColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('backgroundColor', color.value);
  }

  void setTextColor(Color color) async {
    _textColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('textColor', color.value);
  }

  Future<void> _loadThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString =
        prefs.getString('themeMode') ?? ThemeMode.light.toString();
    _themeMode =
        ThemeMode.values.firstWhere((e) => e.toString() == themeModeString);
    _accentColor = Color(prefs.getInt('accentColor') ?? Colors.blue.value);
    _backgroundColor =
        Color(prefs.getInt('backgroundColor') ?? Colors.white.value);
    _textColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
    notifyListeners();
  }
}

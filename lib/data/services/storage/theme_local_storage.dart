import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalStorage {
  static const String _themeKey = 'app_theme_mode';

  Future<String?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }
}
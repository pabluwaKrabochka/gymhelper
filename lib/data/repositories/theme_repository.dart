import '../services/storage/theme_local_storage.dart';

class ThemeRepository {
  final ThemeLocalStorage storage;

  ThemeRepository(this.storage);

  Future<String?> getSavedTheme() => storage.loadTheme();

  Future<void> saveTheme(String themeName) => storage.saveTheme(themeName);
}
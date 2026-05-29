import '../../data/repositories/theme_repository.dart';

class LoadThemeUseCase {
  final ThemeRepository repository;

  LoadThemeUseCase(this.repository);

  Future<String?> call() => repository.getSavedTheme();
}

class SaveThemeUseCase {
  final ThemeRepository repository;

  SaveThemeUseCase(this.repository);

  Future<void> call(String theme) => repository.saveTheme(theme);
}
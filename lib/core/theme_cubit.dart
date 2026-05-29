import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/core/constants/color_constants.dart';
import '../../domain/usecases/theme_usecases.dart';


class ThemeCubit extends Cubit<ThemeMode> {
  final LoadThemeUseCase loadTheme;
  final SaveThemeUseCase saveTheme;

  ThemeCubit({required this.loadTheme, required this.saveTheme}) : super(ThemeMode.system);

  Future<void> init() async {
    final saved = await loadTheme();
    ThemeMode mode;
    switch (saved) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
    }
    
    _updateStaticColors(mode);
    emit(mode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    _updateStaticColors(mode);
    emit(mode);

    await saveTheme(
      mode == ThemeMode.light
          ? 'light'
          : mode == ThemeMode.dark
          ? 'dark'
          : 'system',
    );
  }

  // Синхронізуємо ThemeMode з твоїм статичним AppColors
  void _updateStaticColors(ThemeMode mode) {
    if (mode == ThemeMode.dark) {
      AppColors.isDarkMode = true;
    } else if (mode == ThemeMode.light) {
      AppColors.isDarkMode = false;
    } else {
      // Якщо ThemeMode.system, перевіряємо системні налаштування телефону
      var brightness = PlatformDispatcher.instance.platformBrightness;
      AppColors.isDarkMode = brightness == Brightness.dark;
    }
  }
}
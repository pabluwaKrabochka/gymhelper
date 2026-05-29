import 'package:flutter/material.dart';
import 'package:gymhelper/core/constants/color_constants.dart';


class AppTheme {
  // Світла тема
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      // ВКАЗУЄМО НАШ НОВИЙ ШРИФТ ГЛОБАЛЬНО
      fontFamily: 'ScienceGothic', 

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        // Заголовок AppBar завжди Bold:
        titleTextStyle: TextStyle(
          fontFamily: 'ScienceGothic',
          fontSize: 20,
          fontWeight: FontWeight.bold, // Flutter автоматично візьме PlusJakartaSans-Bold.ttf
          color: AppColors.textPrimary,
        ),
      ),
      
      // ВИПРАВЛЕНО: Використовуємо DialogThemeData
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  // Темна тема (на майбутнє)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: AppColors.primary,
      
      // Не забуваємо і для темної теми
      fontFamily: 'ScienceGothic', 

      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'ScienceGothic',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // Для темної теми також DialogThemeData, але з темним фоном
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey[850], 
      ),
    );
  }
}
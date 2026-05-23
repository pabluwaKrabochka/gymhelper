import 'package:flutter/material.dart';

class AppColors {
  // Основний колір (бірюзово-синій) - використовується для кнопок, заголовків
static const Color primary = Color(0xFF2563EB); // Сучасний синій
  // Світлий відтінок основного кольору (для фону слайдів привітання)
  static const Color primaryLight = Color(0xFFE3F2FD);
  // Колір акценту (наприклад, для індикаторів)
  static const Color accent = Color(0xFFFDD835);

  // Стандартні кольори
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color card = Colors.white;
  // Кольори для транзакцій (не забудь поправити їх у DatabaseService пізніше)
  static const Color income = Color(0xFF10B981); // М'який зелений
  static const Color expense = Color(0xFFEF4444); // М'який червоний

  static const Color background = Color(0xFFF3F4F6); // Світло-сірий фон екранів
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
}
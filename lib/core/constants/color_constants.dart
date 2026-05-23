import 'package:flutter/material.dart';

class AppColors {
  // Базові кольори
  static const Color primary = Color(0xFF6366F1); // Трендовий індиго
  static const Color accent = Color(0xFF10B981);  // Свіжий зелений (для балансу)
  static const Color background = Color(0xFFF8FAFC); // Чистий світлий фон
  static const Color surface = Color(0xFFFFFFFF);    // Колір карток
  
  // Текст
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Преміальні градієнти
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)], // Від Індиго до Циану
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)], // М'який пастельний градієнт для порад
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
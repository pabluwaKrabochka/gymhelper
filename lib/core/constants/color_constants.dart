import 'package:flutter/material.dart';

class AppColors {
  // Глобальний прапорець для теми (ним буде керувати Cubit)
  static bool isDarkMode = false;

  // Базові кольори (динамічно змінюються)
  static Color get primary => isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF6366F1); 
  static Color get accent => isDarkMode ? const Color(0xFF34D399) : const Color(0xFF10B981);  
  
  static Color get background => isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC); 
  static Color get surface => isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);  
  static Color get lamp => const Color.fromARGB(255, 255, 210, 63);

  // Текст
  static Color get textPrimary => isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  static Color get textSecondary => isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  // Преміальні градієнти
  static LinearGradient get premiumGradient => LinearGradient(
    colors: isDarkMode 
        ? [const Color(0xFF6366F1), const Color(0xFF06B6D4)] 
        : [const Color(0xFF4F46E5), const Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get cardGradient => LinearGradient(
    colors: isDarkMode 
        ? [const Color(0xFF1E293B), const Color(0xFF334155)] 
        : [const Color(0xFFEEF2FF), const Color(0xFFE0F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
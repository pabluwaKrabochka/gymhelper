import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class DialogUtils {
  /// Показує вікно підтвердження і повертає [true] (якщо натиснуто "Так") або [false] ("Ні").
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Видалити',
    String cancelText = 'Скасувати',
    bool isDestructive = true, // Якщо true, кнопка буде червоною
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title, 
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          // Додаємо відступи для блоку з кнопками
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          actions: [
            Row(
              children: [
                // ЛІВОРУЧ: Кнопка "Скасувати"
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(cancelText, style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 8),
                // ПРАВОРУЧ: Кнопка "Видалити"
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDestructive ? Colors.red.shade500 : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(confirmText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    return result ?? false; 
  }
}
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/theme/app_colors.dart';

class CategoryEmptyState extends StatelessWidget {
  const CategoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, // Ідеальне центрування
      padding: const EdgeInsets.only(bottom: 120.0), // Відступ знизу, щоб підняти текст над кнопкою "Створити"
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/categoryEmptyState.json', height: 180), // Трохи зменшили розмір анімації
              const SizedBox(height: 24),
              const Text(
                'Категорій ще немає', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
              ),
              const SizedBox(height: 8),
              const Text(
                'Створіть першу категорію, щоб почати контролювати свої витрати та доходи',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ФАЙЛ: lib/features/categories/ui/categories_screen.dart

import 'dart:ui' as ui; // <--- ДОДАНО ДЛЯ ЕФЕКТУ СКЛА
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/categories/widgets/add_category_form.dart';
import 'package:gymhelper/features/categories/widgets/categories_empty_state.dart';
import 'package:gymhelper/features/categories/widgets/category_list_item.dart';
import 'package:gymhelper/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:gymhelper/features/transactions/presentation/cubit/transaction_state.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../app/theme/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Категорії', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (transactions, categories, totalBalance, date, currencyRates) {
              
            if (categories.isEmpty) {
                return const CategoryEmptyState();
              }

              // ДОДАЄМО ShaderMask ДЛЯ ПЛАВНОГО ЗНИКНЕННЯ
              return ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white.withAlpha(0), // Стає повністю прозорим
                      Colors.white.withAlpha(0), // Залишається прозорим до самого низу екрана
                    ],
                    stops: [
                      0.0,
                      (1.0 - (180 / bounds.height)).clamp(0.0, 1.0), // Починає зникати
                      (1.0 - (90 / bounds.height)).clamp(0.0, 1.0),  // Повністю зникає тут
                      1.0,
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 190), 
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryListItem(category: categories[index]);
                  },
                ),
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildGlassFAB(context),
    );
  }

 // --- КОМПАКТНА СКЛЯНА КНОПКА СТВОРИТИ ---
  Widget _buildGlassFAB(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 110.0, right: 16.0),
      child: ClipOval(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(200),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(70), width: 1.5),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => AddCategoryForm.show(context), // <--- Виклик форми категорій
                customBorder: const CircleBorder(),
                splashColor: Colors.white.withAlpha(50),
                child: const Center(
                  child: Icon(IconsaxPlusLinear.add, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
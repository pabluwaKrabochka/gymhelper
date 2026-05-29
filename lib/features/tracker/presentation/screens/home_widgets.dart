import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/meals/screens/add_meal_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/meal_record_model.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/food_database.dart';
import '../cubit/tracker_cubit.dart';


class HomeWidgets {
  static String getLocalizedFoodName(String savedName, String langCode) {
    try {
      final food = foodDatabase.firstWhere((f) => f.nameUk.toLowerCase() == savedName.toLowerCase() || f.nameEn.toLowerCase() == savedName.toLowerCase());
      return food.getName(langCode);
    } catch (_) {
      try { return addonDatabase.firstWhere((f) => f.nameUk.toLowerCase() == savedName.toLowerCase() || f.nameEn.toLowerCase() == savedName.toLowerCase()).getName(langCode); } catch (_) {}
      try { return drinkDatabase.firstWhere((f) => f.nameUk.toLowerCase() == savedName.toLowerCase() || f.nameEn.toLowerCase() == savedName.toLowerCase()).getName(langCode); } catch (_) {}
      return savedName; 
    }
  }

  static IconData getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast: return Icons.wb_sunny_rounded; 
      case MealType.lunch: return Icons.lunch_dining_rounded; 
      case MealType.dinner: return Icons.nights_stay_rounded; 
      case MealType.snack: return Icons.apple_rounded;        
    }
  }

  static Color getMealColor(MealType type) {
    switch (type) {
      case MealType.breakfast: return Colors.orange;
      case MealType.lunch: return Colors.green;
      case MealType.dinner: return Colors.indigo;
      case MealType.snack: return Colors.red;
    }
  }

  static String getMealTypeName(MealType type) {
    return 'meal_types.${type.name}'.tr(); 
  }

  static Widget buildDateSelector(BuildContext context, DateTime currentDate, double hPadding, bool tablet) {
    final formatter = DateFormat('dd MMMM yyyy', context.locale.languageCode == 'en' ? 'en_US' : 'uk_UA');
    final isToday = DateUtils.isSameDay(currentDate, DateTime.now());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(IconsaxPlusLinear.arrow_square_left, size: tablet ? 32 : 24, color: AppColors.textPrimary),
            onPressed: () => context.read<TrackerCubit>().changeDate(currentDate.subtract(const Duration(days: 1))),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isToday ? 'home.today'.tr() : formatter.format(currentDate),
              key: ValueKey(currentDate.toIso8601String() + context.locale.languageCode),
              style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
          IconButton(
            icon: Icon(IconsaxPlusLinear.arrow_square_right, size: tablet ? 32 : 24, color: AppColors.textPrimary),
            onPressed: isToday ? null : () => context.read<TrackerCubit>().changeDate(currentDate.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }

  static Widget buildCalorieProgress(int consumed, int goal, bool isOverLimit, BuildContext context, bool tablet) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    final color = isOverLimit ? Colors.red : AppColors.primary;
    final circleSize = tablet ? 220.0 : 150.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: circleSize, height: circleSize,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => CircularProgressIndicator(
              value: value, strokeWidth: tablet ? 18.0 : 12.0, 
              backgroundColor: AppColors.textSecondary.withAlpha(30), color: color
            ),
          ),
        ),
        Column(
          children: [
            Text('$consumed', style: TextStyle(fontSize: tablet ? 48 : 32, fontWeight: FontWeight.bold, color: color)),
            Text('/ $goal ${'units.kcal'.tr()}', style: TextStyle(color: AppColors.textSecondary, fontSize: tablet ? 18 : 14)),
          ],
        ),
      ],
    );
  }

  static Widget buildMacroItem(BuildContext context, String title, double consumed, double goal, Color color, bool tablet) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: tablet ? 16 : 12, color: AppColors.textPrimary)),
            SizedBox(height: tablet ? 12 : 8),
            LinearProgressIndicator(value: progress, backgroundColor: AppColors.textSecondary.withAlpha(30), color: color, minHeight: tablet ? 12 : 8, borderRadius: BorderRadius.circular(4)),
            SizedBox(height: tablet ? 12 : 8),
            Text('${consumed.toInt()} / ${goal.toInt()} ${'units.g'.tr()}', style: TextStyle(fontSize: tablet ? 14 : 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  static Widget buildMacroBadge(String text, Color color, bool tablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tablet ? 8 : 6, vertical: tablet ? 4 : 2),
      decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(tablet ? 8 : 6)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: tablet ? 13 : 11)),
    );
  }

  static void showMealActionSheet(BuildContext context, MealRecordModel meal, bool tablet) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => Material(
        color: AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withAlpha(30), shape: BoxShape.circle), child: Icon(IconsaxPlusLinear.info_circle, color: AppColors.primary)),
                title: Text('Деталі прийому їжі', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)), 
                onTap: () { Navigator.pop(ctx); showMealDetailsSheet(context, meal, tablet); },
              ),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withAlpha(30), shape: BoxShape.circle), child: const Icon(IconsaxPlusLinear.edit_2, color: Colors.orange)),
                title: Text('Редагувати', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)), 
                onTap: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => AddMealScreen(mealToEdit: meal))); },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static void showMealDetailsSheet(BuildContext context, MealRecordModel meal, bool tablet) {
    final langCode = context.locale.languageCode;
    int addonsCals = meal.addons.fold(0, (sum, item) => sum + item.calories);
    int drinksCals = meal.drinks.fold(0, (sum, item) => sum + item.calories);
    int baseCalories = meal.calories - addonsCals - drinksCals;
    
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Material(
        color: AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20, top: 24, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: getMealColor(meal.mealType).withAlpha(30), shape: BoxShape.circle), child: Icon(getMealIcon(meal.mealType), color: getMealColor(meal.mealType), size: 32)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(getMealTypeName(meal.mealType), style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)), Text(getLocalizedFoodName(meal.foodName, langCode), style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold))])),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.withAlpha(30), shape: BoxShape.circle), child: Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20))),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.textSecondary.withAlpha(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Склад прийому їжі", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text("• ${getLocalizedFoodName(meal.foodName, langCode)}", style: TextStyle(color: AppColors.textSecondary, fontSize: 15))), Text("$baseCalories ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold))]),
                    if (meal.addons.isNotEmpty) ...[
                      Padding(padding: const EdgeInsets.only(top: 8, bottom: 4), child: Text("Добавки:", style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold))),
                      ...meal.addons.map((a) => Padding(padding: const EdgeInsets.only(bottom: 6.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text("  + ${getLocalizedFoodName(a.foodName, langCode)} (${a.weight.toInt()}г)", style: TextStyle(color: AppColors.textSecondary, fontSize: 14))), Text("${a.calories} ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold))]))),
                    ],
                    if (meal.drinks.isNotEmpty) ...[
                      Padding(padding: const EdgeInsets.only(top: 8, bottom: 4), child: Text("Напої:", style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold))),
                      ...meal.drinks.map((d) => Padding(padding: const EdgeInsets.only(bottom: 6.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text("  + ${getLocalizedFoodName(d.foodName, langCode)} (${d.weight.toInt()}мл)", style: TextStyle(color: AppColors.textSecondary, fontSize: 14))), Text("${d.calories} ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold))]))),
                    ],
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider()),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Усього:", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)), Text("${meal.calories} ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 20))]),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
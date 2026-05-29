import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/app/utils/custom_snackbar.dart';
import 'package:gymhelper/app/utils/dialog_utils.dart';
import 'package:gymhelper/core/theme_cubit.dart';
import 'package:gymhelper/features/meals/screens/add_meal_screen.dart'; 
import 'package:gymhelper/shared/theme_switcher.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart'; 
import '../cubit/tracker_cubit.dart';
import '../cubit/tracker_state.dart';
import '../../../../data/models/meal_record_model.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/food_database.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  // Шукаємо правильний переклад
  String _getLocalizedFoodName(String savedName, String langCode) {
    try {
      final food = foodDatabase.firstWhere(
        (f) => f.nameUk.toLowerCase() == savedName.toLowerCase() || 
               f.nameEn.toLowerCase() == savedName.toLowerCase()
      );
      return food.getName(langCode);
    } catch (_) {
      try {
        final addon = addonDatabase.firstWhere((f) => f.nameUk.toLowerCase() == savedName.toLowerCase() || f.nameEn.toLowerCase() == savedName.toLowerCase());
        return addon.getName(langCode);
      } catch (_) {}
      try {
        final drink = drinkDatabase.firstWhere((f) => f.nameUk.toLowerCase() == savedName.toLowerCase() || f.nameEn.toLowerCase() == savedName.toLowerCase());
        return drink.getName(langCode);
      } catch (_) {}

      return savedName; 
    }
  }

  // --- МЕНЮ ПРИ НАТИСКАННІ НА КАРТКУ (Деталі / Редагувати) ---
  void _showMealActionSheet(BuildContext context, MealRecordModel meal, bool tablet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 24),
                ListTile(
                  leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withAlpha(30), shape: BoxShape.circle), child: Icon(IconsaxPlusLinear.info_circle, color: AppColors.primary)),
                  title: Text('home.meal_details'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)), 
                  onTap: () {
                    Navigator.pop(ctx);
                    _showMealDetailsSheet(context, meal, tablet);
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withAlpha(30), shape: BoxShape.circle), child: const Icon(IconsaxPlusLinear.edit_2, color: Colors.orange)),
                  title: Text('home.edit'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)), 
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddMealScreen(mealToEdit: meal)));
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- ВІКНО ДЕТАЛЕЙ (З ХРЕСТИКОМ) ---
  void _showMealDetailsSheet(BuildContext context, MealRecordModel meal, bool tablet) {
    final langCode = context.locale.languageCode;
    
    // ПІДРАХУНОК КАЛОРІЙ ОСНОВНОЇ СТРАВИ
    int addonsCals = meal.addons.fold(0, (sum, item) => sum + item.calories);
    int drinksCals = meal.drinks.fold(0, (sum, item) => sum + item.calories);
    int baseCalories = meal.calories - addonsCals - drinksCals;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              top: 24, left: 24, right: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ШАПКА: Іконка + Назва + Хрестик
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: _getMealColor(meal.mealType).withAlpha(30), shape: BoxShape.circle),
                      child: Icon(_getMealIcon(meal.mealType), color: _getMealColor(meal.mealType), size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getMealTypeName(meal.mealType), style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(_getLocalizedFoodName(meal.foodName, langCode), style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey.withAlpha(30), shape: BoxShape.circle),
                        child: Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // БЛОК ІЗ СКЛАДОМ
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.textSecondary.withAlpha(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("home.meal_composition".tr(), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      
                      // Основна страва
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text("• ${_getLocalizedFoodName(meal.foodName, langCode)}", style: TextStyle(color: AppColors.textSecondary, fontSize: 15))),
                          Text("$baseCalories ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)), 
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Відображаємо добавки, якщо вони є
                      if (meal.addons.isNotEmpty) ...[
                        Padding(padding: const EdgeInsets.only(top: 8, bottom: 4), child: Text("${'add_meal.addons'.tr()}:", style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold))),
                        ...meal.addons.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("  + ${_getLocalizedFoodName(a.foodName, langCode)} (${a.weight.toInt()}г)", style: TextStyle(color: AppColors.textSecondary, fontSize: 14))),
                              Text("${a.calories} ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                      ],

                      // Відображаємо напої, якщо вони є
                      if (meal.drinks.isNotEmpty) ...[
                        Padding(padding: const EdgeInsets.only(top: 8, bottom: 4), child: Text("${'add_meal.drinks'.tr()}:", style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold))),
                        ...meal.drinks.map((d) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("  + ${_getLocalizedFoodName(d.foodName, langCode)} (${d.weight.toInt()}мл)", style: TextStyle(color: AppColors.textSecondary, fontSize: 14))),
                              Text("${d.calories} ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                      ],

                      const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider()),
                      
                      // Усього
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${'home.total'.tr()}:", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("${meal.calories} ${'units.kcal'.tr()}", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final hPadding = tablet ? screenWidth * 0.1 : 16.0;
    final langCode = context.locale.languageCode;

    return BlocBuilder<TrackerCubit, TrackerState>(
      builder: (context, state) {
        final cubit = context.read<TrackerCubit>();

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final goalCalories = state.user?.dailyCalories ?? 2000;
        final goalProteins = state.user?.dailyProteins ?? 150;
        final goalFats = state.user?.dailyFats ?? 70;
        final goalCarbs = state.user?.dailyCarbs ?? 250;

        final consumedCalories = cubit.totalDailyCalories;
        final isOverLimit = consumedCalories > goalCalories;

        final streak = state.streak;
        double fireSize = 24.0;
        Color streakColor;
        Color bgColor;
        Widget fireWidget;

        if (streak >= 30) {
          fireSize = 36.0; 
          streakColor = Colors.red;
          bgColor = Colors.red.withAlpha(30);
          fireWidget = Lottie.asset('assets/fire.json', fit: BoxFit.contain);
        } else if (streak >= 20) {
          fireSize = 32.0;
          streakColor = Colors.deepOrange;
          bgColor = Colors.deepOrange.withAlpha(30);
          fireWidget = Lottie.asset('assets/fire.json', fit: BoxFit.contain);
        } else if (streak >= 10) {
          fireSize = 28.0;
          streakColor = Colors.orange.shade800;
          bgColor = Colors.orange.shade800.withAlpha(30);
          fireWidget = Lottie.asset('assets/fire.json', fit: BoxFit.contain);
        } else if (streak >= 3) {
          fireSize = 24.0;
          streakColor = Colors.orange;
          bgColor = Colors.orange.withAlpha(30);
          fireWidget = Lottie.asset('assets/fire.json', fit: BoxFit.contain);
        } else {
          fireSize = 24.0;
          streakColor = Colors.grey;
          bgColor = Colors.grey.withAlpha(30);
          fireWidget = const Icon(Icons.local_fire_department_rounded, color: Colors.grey, size: 20);
        }

        if (tablet) fireSize *= 1.3;

        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return Scaffold(
              backgroundColor: Colors.transparent, 
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leadingWidth: 85, 
                leading: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: ThemeSwitcher(), 
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'home.my_day'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: tablet ? 26 : 20)
                    ), 
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showStreakInfoDialog(context, streak, tablet),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: EdgeInsets.symmetric(horizontal: tablet ? 12 : 8, vertical: tablet ? 6 : 4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: fireSize,
                              height: fireSize,
                              alignment: Alignment.center,
                              child: fireWidget, 
                            ),
                            const SizedBox(width: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 400),
                              style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold, color: streakColor),
                              child: Text('$streak'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (context.locale.languageCode == 'uk') {
                            context.setLocale(const Locale('en'));
                          } else {
                            context.setLocale(const Locale('uk'));
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400), 
                          curve: Curves.easeInOutCubic,
                          padding: EdgeInsets.symmetric(horizontal: tablet ? 12 : 10, vertical: tablet ? 8 : 6),
                          decoration: BoxDecoration(
                            color: AppColors.surface, 
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.textSecondary.withAlpha(20)),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 400), 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: tablet ? 16 : 14, 
                              color: AppColors.textPrimary 
                            ),
                            child: Text(context.locale.languageCode == 'en' ? '🇺🇸 EN' : '🇺🇦 UK'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Column(
                  key: ValueKey(context.locale.languageCode), 
                  children: [
                    _buildDateSelector(context, state.selectedDate, hPadding, tablet),
                    SizedBox(height: tablet ? 30 : 20),

                    _buildCalorieProgress(consumedCalories, goalCalories, isOverLimit, context, tablet),
                    SizedBox(height: tablet ? 30 : 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMacroItem(context, 'analytics.proteins'.tr(), cubit.totalDailyProteins, goalProteins.toDouble(), Colors.blue, tablet),
                          _buildMacroItem(context, 'analytics.fats'.tr(), cubit.totalDailyFats, goalFats.toDouble(), Colors.orange, tablet),
                          _buildMacroItem(context, 'analytics.carbs'.tr(), cubit.totalDailyCarbs, goalCarbs.toDouble(), Colors.green, tablet),
                        ],
                      ),
                    ),

                    SizedBox(height: tablet ? 30 : 20),
                    const Divider(),

                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: state.meals.isEmpty
                            ? Center(
                                key: const ValueKey('empty_food'), 
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/food.json', width: tablet ? 250 : 180, height: tablet ? 250 : 180, repeat: false),
                                    SizedBox(height: tablet ? 24 : 16),
                                    Text(
                                      'home.no_meals'.tr(), 
                                      style: TextStyle(color: Colors.grey, fontSize: tablet ? 20 : 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: tablet ? 150 : 100),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                key: const ValueKey('list'), 
                                padding: EdgeInsets.only(left: hPadding, right: hPadding, bottom: tablet ? 200 : 160), 
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.meals.length,
                                itemBuilder: (context, index) {
                                  final meal = state.meals[index];
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Dismissible(
                                      key: ValueKey(meal.id),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade400,
                                          borderRadius: BorderRadius.circular(20), 
                                        ),
                                        child: Icon(IconsaxPlusLinear.trash, color: Colors.white, size: tablet ? 32 : 24),
                                      ),
                                      confirmDismiss: (direction) async {
                                        return await DialogUtils.showConfirmDialog(
                                          context,
                                          title: 'home.delete_entry'.tr(),
                                          content: 'home.delete_confirm'.tr(namedArgs: {'name': _getLocalizedFoodName(meal.foodName, langCode)}),
                                          confirmText: 'home.delete'.tr(),
                                          cancelText: 'home.cancel'.tr(),
                                        );
                                      },
                                      onDismissed: (direction) {
                                        if (meal.id != null) {
                                          context.read<TrackerCubit>().deleteMealRecord(meal.id!);
                                          CustomSnackbar.showSuccess(context, 'home.deleted_success'.tr(namedArgs: {'name': _getLocalizedFoodName(meal.foodName, langCode)}));
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOutCubic,
                                        decoration: BoxDecoration(
                                          color: AppColors.surface, 
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.textSecondary.withAlpha(15), 
                                              blurRadius: 10, 
                                              offset: const Offset(0, 4)
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: tablet ? 24 : 16, vertical: tablet ? 12 : 8),
                                              leading: Container(
                                                padding: EdgeInsets.all(tablet ? 16 : 12),
                                                decoration: BoxDecoration(
                                                  color: _getMealColor(meal.mealType).withAlpha(30), 
                                                  shape: BoxShape.circle
                                                ),
                                                child: Icon(_getMealIcon(meal.mealType), color: _getMealColor(meal.mealType), size: tablet ? 32 : 24),
                                              ),
                                              title: Text(
                                                _getLocalizedFoodName(meal.foodName, langCode), 
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 20 : 16, color: AppColors.textPrimary)
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Wrap(
                                                  spacing: 6, 
                                                  runSpacing: 4,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      _getMealTypeName(meal.mealType),
                                                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: tablet ? 14 : 12),
                                                    ),
                                                    _buildMacroBadge('${meal.proteins} ${'units.p'.tr()}', Colors.blue, tablet),
                                                    _buildMacroBadge('${meal.fats} ${'units.f'.tr()}', Colors.orange, tablet),
                                                    _buildMacroBadge('${meal.carbs} ${'units.c'.tr()}', Colors.green, tablet),
                                                  ],
                                                ),
                                              ),
                                              trailing: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${meal.calories}',
                                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: tablet ? 24 : 18, color: AppColors.textPrimary),
                                                  ),
                                                  Text(
                                                    'units.kcal'.tr(),
                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: tablet ? 14 : 11, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                _showMealActionSheet(context, meal, tablet);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildMacroBadge(String text, Color color, bool tablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tablet ? 8 : 6, vertical: tablet ? 4 : 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(tablet ? 8 : 6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: tablet ? 13 : 11),
      ),
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast: return Icons.wb_sunny_rounded; 
      case MealType.lunch: return Icons.lunch_dining_rounded; 
      case MealType.dinner: return Icons.nights_stay_rounded; 
      case MealType.snack: return Icons.apple_rounded;        
    }
  }

  Color _getMealColor(MealType type) {
    switch (type) {
      case MealType.breakfast: return Colors.orange;
      case MealType.lunch: return Colors.green;
      case MealType.dinner: return Colors.indigo;
      case MealType.snack: return Colors.red;
    }
  }

  void _showStreakInfoDialog(BuildContext context, int streak, bool tablet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(
                streak >= 3 ? Icons.local_fire_department_rounded : Icons.local_fire_department_outlined, 
                color: streak >= 3 ? Colors.orange : Colors.grey,
                size: tablet ? 36 : 28,
              ),
              SizedBox(width: tablet ? 12 : 8),
              Expanded(
                child: Text('home.streak_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20, color: AppColors.textPrimary)),
              ),
            ],
          ),
          content: Text(
            'home.streak_desc'.tr(),
            style: TextStyle(fontSize: tablet ? 18 : 15, height: 1.4, color: AppColors.textSecondary),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: tablet ? 24 : 16, vertical: tablet ? 16 : 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('home.streak_btn'.tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: tablet ? 18 : 16)),
            )
          ],
        );
      }
    );
  }

  Widget _buildDateSelector(BuildContext context, DateTime currentDate, double hPadding, bool tablet) {
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
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
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

  Widget _buildCalorieProgress(int consumed, int goal, bool isOverLimit, BuildContext context, bool tablet) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    final color = isOverLimit ? Colors.red : AppColors.primary;

    final circleSize = tablet ? 220.0 : 150.0;
    final strokeWidth = tablet ? 18.0 : 12.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value, 
                strokeWidth: strokeWidth, 
                backgroundColor: AppColors.textSecondary.withAlpha(30), 
                color: color
              );
            },
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

  Widget _buildMacroItem(BuildContext context, String title, double consumed, double goal, Color color, bool tablet) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: tablet ? 16 : 12, color: AppColors.textPrimary)),
            SizedBox(height: tablet ? 12 : 8),
            LinearProgressIndicator(
              value: progress, 
              backgroundColor: AppColors.textSecondary.withAlpha(30), 
              color: color, 
              minHeight: tablet ? 12 : 8, 
              borderRadius: BorderRadius.circular(4)
            ),
            SizedBox(height: tablet ? 12 : 8),
            Text(
              '${consumed.toInt()} / ${goal.toInt()} ${'units.g'.tr()}', 
              style: TextStyle(fontSize: tablet ? 14 : 10, color: AppColors.textSecondary)
            ),
          ],
        ),
      ),
    );
  }

  String _getMealTypeName(MealType type) {
    return 'meal_types.${type.name}'.tr(); 
  }
}
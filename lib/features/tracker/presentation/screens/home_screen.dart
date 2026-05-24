import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/app/utils/custom_snackbar.dart';
import 'package:gymhelper/app/utils/dialog_utils.dart'; // ПІДКЛЮЧАЄМО НАШ ДІАЛОГ
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../cubit/tracker_cubit.dart';
import '../cubit/tracker_state.dart';
import '../../../../data/models/meal_record_model.dart';
import 'add_meal_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій день'),
        centerTitle: true,
      ),
      body: BlocBuilder<TrackerCubit, TrackerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<TrackerCubit>();
          
          final goalCalories = state.user?.dailyCalories ?? 2000;
          final goalProteins = state.user?.dailyProteins ?? 150;
          final goalFats = state.user?.dailyFats ?? 70;
          final goalCarbs = state.user?.dailyCarbs ?? 250;

          final consumedCalories = cubit.totalDailyCalories;
          final isOverLimit = consumedCalories > goalCalories;

          return Column(
            children: [
              _buildDateSelector(context, state.selectedDate),
              const SizedBox(height: 20),

              // Анімовані кільця калорій
              _buildCalorieProgress(consumedCalories, goalCalories, isOverLimit, context),
              const SizedBox(height: 20),

              // Анімовані смужки БЖВ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMacroItem(context, 'Білки', cubit.totalDailyProteins, goalProteins.toDouble(), Colors.blue),
                    _buildMacroItem(context, 'Жири', cubit.totalDailyFats, goalFats.toDouble(), Colors.orange),
                    _buildMacroItem(context, 'Вуглеводи', cubit.totalDailyCarbs, goalCarbs.toDouble(), Colors.green),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: state.meals.isEmpty
                      ? const Center(
                          key: ValueKey('empty'), 
                          child: Text('Сьогодні ви ще нічого не записували.')
                        )
                      : ListView.builder(
                          key: const ValueKey('list'), 
                          itemCount: state.meals.length,
                          itemBuilder: (context, index) {
                            final meal = state.meals[index];
                            
                            return Dismissible(
                              key: ValueKey(meal.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.red.shade400,
                                child: const Icon(IconsaxPlusLinear.trash, color: Colors.white),
                              ),
                              // ДОДАНО: Викликаємо вікно підтвердження ПЕРЕД видаленням
                              confirmDismiss: (direction) async {
                                return await DialogUtils.showConfirmDialog(
                                  context,
                                  title: 'Видалити запис?',
                                  content: 'Ви впевнені, що хочете видалити "${meal.foodName}"?',
                                );
                              },
                              // Виконається ТІЛЬКИ якщо confirmDismiss повернув true
                              onDismissed: (direction) {
                                if (meal.id != null) {
                                  context.read<TrackerCubit>().deleteMealRecord(meal.id!);
                                  CustomSnackbar.showSuccess(context, '${meal.foodName} видалено');
                                }
                              },
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(IconsaxPlusLinear.reserve),
                                ),
                                title: Text(meal.foodName),
                                subtitle: Text(
                                  '${_getMealTypeName(meal.mealType)} • ${meal.proteins} Б ${meal.fats} Ж ${meal.carbs} В',
                                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                                ),
                                trailing: Text(
                                  '${meal.calories} ккал',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddMealScreen(mealToEdit: meal),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, DateTime currentDate) {
    final formatter = DateFormat('dd MMMM yyyy', 'uk_UA');
    final isToday = DateUtils.isSameDay(currentDate, DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_square_left),
            onPressed: () {
              context.read<TrackerCubit>().changeDate(
                currentDate.subtract(const Duration(days: 1)),
              );
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: Text(
              isToday ? 'Сьогодні' : formatter.format(currentDate),
              key: ValueKey(currentDate.toIso8601String()),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_square_right),
            onPressed: isToday ? null : () {
              context.read<TrackerCubit>().changeDate(
                currentDate.add(const Duration(days: 1)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieProgress(int consumed, int goal, bool isOverLimit, BuildContext context) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    final color = isOverLimit ? Colors.red : Theme.of(context).colorScheme.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: Colors.grey.shade200,
                color: color,
              );
            },
          ),
        ),
        Column(
          children: [
            Text(
              '$consumed',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '/ $goal ккал',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroItem(BuildContext context, String title, double consumed, double goal, Color color) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text('${consumed.toInt()} / ${goal.toInt()} г', 
                 style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _getMealTypeName(MealType type) {
    switch (type) {
      case MealType.breakfast: return 'Сніданок';
      case MealType.lunch: return 'Обід';
      case MealType.dinner: return 'Вечеря';
      case MealType.snack: return 'Перекус';
    }
  }
}
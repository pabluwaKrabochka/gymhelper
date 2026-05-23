import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          
          // Беремо цілі з профілю або ставимо стандартні заглушки
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

              // Прогрес калорій
              _buildCalorieProgress(consumedCalories, goalCalories, isOverLimit, context),
              const SizedBox(height: 20),

              // Прогрес БЖВ
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

              // Список їжі
              Expanded(
                child: state.meals.isEmpty
                    ? const Center(child: Text('Сьогодні ви ще нічого не записували.'))
                    : ListView.builder(
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
                            onDismissed: (direction) {
                              if (meal.id != null) {
                                context.read<TrackerCubit>().deleteMealRecord(meal.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${meal.foodName} видалено')),
                                );
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
                              subtitle: Text('${_getMealTypeName(meal.mealType)} • ${meal.proteins}Б ${meal.fats}Ж ${meal.carbs}В'),
                              trailing: Text(
                                '${meal.calories} ккал',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            icon: const Icon(IconsaxPlusLinear.arrow_left_2),
            onPressed: () {
              context.read<TrackerCubit>().changeDate(
                currentDate.subtract(const Duration(days: 1)),
              );
            },
          ),
          Text(
            isToday ? 'Сьогодні' : formatter.format(currentDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_right_3),
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
    final progress = (consumed / goal).clamp(0.0, 1.0);
    final color = isOverLimit ? Colors.red : Theme.of(context).colorScheme.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 12,
            backgroundColor: Colors.grey.shade200,
            color: color,
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
    final progress = (consumed / goal).clamp(0.0, 1.0);
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text('${consumed.toInt()} / ${goal.toInt()} г', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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
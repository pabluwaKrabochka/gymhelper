import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/app/utils/custom_snackbar.dart';
import 'package:gymhelper/app/utils/dialog_utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart'; 
import '../cubit/tracker_cubit.dart';
import '../cubit/tracker_state.dart';
import '../../../../data/models/meal_record_model.dart';
import 'add_meal_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

        // --- ЛОГІКА РОЗМІРУ, КОЛЬОРУ ТА СТАНУ ВОГНИКУ ---
        final streak = state.streak;
        double fireSize = 24.0;
        Color streakColor;
        Color bgColor;
        Widget fireWidget;

        if (streak >= 30) {
          fireSize = 36.0; // Максимальний розмір
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
          // Якщо менше 3 днів (1 або 2) - сіра заглушка
          fireSize = 24.0;
          streakColor = Colors.grey;
          bgColor = Colors.grey.withAlpha(30);
          fireWidget = const Icon(Icons.local_fire_department_rounded, color: Colors.grey, size: 20);
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('home.my_day'.tr()), 
                const SizedBox(width: 8),
                // --- СТРІК ВІДЖЕТ ---
                GestureDetector(
                  onTap: () => _showStreakInfoDialog(context, streak),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: streakColor),
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
                child: ActionChip(
                  label: Text(
                    context.locale.languageCode == 'en' ? '🇺🇸 EN' : '🇺🇦 UK',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  side: BorderSide.none,
                  onPressed: () {
                    if (context.locale.languageCode == 'uk') {
                      context.setLocale(const Locale('en'));
                    } else {
                      context.setLocale(const Locale('uk'));
                    }
                  },
                ),
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Column(
              key: ValueKey(context.locale.languageCode), 
              children: [
                _buildDateSelector(context, state.selectedDate),
                const SizedBox(height: 20),

                _buildCalorieProgress(consumedCalories, goalCalories, isOverLimit, context),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMacroItem(context, 'analytics.proteins'.tr(), cubit.totalDailyProteins, goalProteins.toDouble(), Colors.blue),
                      _buildMacroItem(context, 'analytics.fats'.tr(), cubit.totalDailyFats, goalFats.toDouble(), Colors.orange),
                      _buildMacroItem(context, 'analytics.carbs'.tr(), cubit.totalDailyCarbs, goalCarbs.toDouble(), Colors.green),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
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
                                Lottie.asset('assets/food.json', width: 180, height: 180, repeat: false),
                                const SizedBox(height: 16),
                                Text(
                                  'home.no_meals'.tr(), 
                                  style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
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
                                confirmDismiss: (direction) async {
                                  return await DialogUtils.showConfirmDialog(
                                    context,
                                    title: 'home.delete_entry'.tr(),
                                    content: 'home.delete_confirm'.tr(namedArgs: {'name': meal.foodName}),
                                    confirmText: 'home.delete'.tr(),
                                    cancelText: 'home.cancel'.tr(),
                                  );
                                },
                                onDismissed: (direction) {
                                  if (meal.id != null) {
                                    context.read<TrackerCubit>().deleteMealRecord(meal.id!);
                                    CustomSnackbar.showSuccess(context, 'home.deleted_success'.tr(namedArgs: {'name': meal.foodName}));
                                  }
                                },
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
                                    child: const Icon(IconsaxPlusLinear.reserve),
                                  ),
                                  title: Text(meal.foodName),
                                  subtitle: Text(
                                    '${_getMealTypeName(meal.mealType)} • ${meal.proteins} ${'units.p'.tr()} ${meal.fats} ${'units.f'.tr()} ${meal.carbs} ${'units.c'.tr()}',
                                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                                  ),
                                  trailing: Text(
                                    '${meal.calories} ${'units.kcal'.tr()}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddMealScreen(mealToEdit: meal)));
                                  },
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
      },
    );
  }

  // --- ДІАЛОГОВЕ ВІКНО СТРІКУ ---
  void _showStreakInfoDialog(BuildContext context, int streak) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(
                streak >= 3 ? Icons.local_fire_department_rounded : Icons.local_fire_department_outlined, 
                color: streak >= 3 ? Colors.orange : Colors.grey,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('home.streak_title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: Text(
            'home.streak_desc'.tr(),
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('home.streak_btn'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        );
      }
    );
  }

  Widget _buildDateSelector(BuildContext context, DateTime currentDate) {
    final formatter = DateFormat('dd MMMM yyyy', context.locale.languageCode == 'en' ? 'en_US' : 'uk_UA');
    final isToday = DateUtils.isSameDay(currentDate, DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_square_left),
            onPressed: () => context.read<TrackerCubit>().changeDate(currentDate.subtract(const Duration(days: 1))),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: Text(
              isToday ? 'home.today'.tr() : formatter.format(currentDate),
              key: ValueKey(currentDate.toIso8601String() + context.locale.languageCode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_square_right),
            onPressed: isToday ? null : () => context.read<TrackerCubit>().changeDate(currentDate.add(const Duration(days: 1))),
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
              return CircularProgressIndicator(value: value, strokeWidth: 12, backgroundColor: Colors.grey.shade200, color: color);
            },
          ),
        ),
        Column(
          children: [
            Text('$consumed', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            Text('/ $goal ${'units.kcal'.tr()}', style: const TextStyle(color: Colors.grey)),
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
            LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: color, minHeight: 8, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 8),
            Text('${consumed.toInt()} / ${goal.toInt()} ${'units.g'.tr()}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _getMealTypeName(MealType type) {
    return 'meal_types.${type.name}'.tr(); 
  }
}
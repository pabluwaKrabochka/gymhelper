import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/app/utils/custom_snackbar.dart';
import 'package:gymhelper/app/utils/dialog_utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart'; 
import '../../../../core/constants/color_constants.dart';
import '../../tracker/presentation/cubit/tracker_cubit.dart';
import '../../tracker/presentation/cubit/tracker_state.dart';
import '../../../../data/models/meal_record_model.dart';
import '../../../../data/models/weight_record_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('analytics.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildCustomTabBar(),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _selectedTab == 0 ? _buildNutritionAnalytics(context) : _buildWeightAnalytics(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: AppColors.textSecondary.withAlpha(20), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              alignment: _selectedTab == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'analytics.nutrition_tab'.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: _selectedTab == 0 ? Colors.white : AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'analytics.weight_tab'.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: _selectedTab == 1 ? Colors.white : AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionAnalytics(BuildContext context) {
    return BlocBuilder<TrackerCubit, TrackerState>(
      key: const ValueKey(0),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = context.read<TrackerCubit>();
        int breakfastCals = 0, lunchCals = 0, dinnerCals = 0, snackCals = 0;
        
        for (var m in state.meals) {
          if (m.mealType == MealType.breakfast) {
            breakfastCals += m.calories;
          }
          if (m.mealType == MealType.lunch) {
            lunchCals += m.calories;
          }
          if (m.mealType == MealType.dinner) {
            dinnerCals += m.calories;
          }
          if (m.mealType == MealType.snack) {
            snackCals += m.calories;
          }
        }

        final goalPro = state.user?.dailyProteins ?? 150;
        final goalFat = state.user?.dailyFats ?? 70;
        final goalCarb = state.user?.dailyCarbs ?? 250;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('analytics.macros_distribution'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              _buildMacroCard('analytics.proteins'.tr(), cubit.totalDailyProteins, goalPro.toDouble(), Colors.blue, 'analytics.proteins_hint'.tr()),
              const SizedBox(height: 12),
              _buildMacroCard('analytics.fats'.tr(), cubit.totalDailyFats, goalFat.toDouble(), Colors.orange, 'analytics.fats_hint'.tr()),
              const SizedBox(height: 12),
              _buildMacroCard('analytics.carbs'.tr(), cubit.totalDailyCarbs, goalCarb.toDouble(), Colors.green, 'analytics.carbs_hint'.tr()),
              
              const SizedBox(height: 32),
              Text('analytics.calories_by_meal'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildMealTypeCard('meal_types.breakfast'.tr(), breakfastCals, cubit.totalDailyCalories, IconsaxPlusLinear.sun_1)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMealTypeCard('meal_types.lunch'.tr(), lunchCals, cubit.totalDailyCalories, IconsaxPlusLinear.clock_1)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildMealTypeCard('meal_types.dinner'.tr(), dinnerCals, cubit.totalDailyCalories, IconsaxPlusLinear.moon)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMealTypeCard('meal_types.snack'.tr(), snackCals, cubit.totalDailyCalories, Icons.cookie_outlined)),
                ],
              ),
              const SizedBox(height: 90), 
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroCard(String title, double consumed, double goal, Color color, String hint) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.textSecondary.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              // ВИПРАВЛЕНО: Замінили хардкод "г" на 'units.g'.tr()
              Text('${consumed.toInt()} / ${goal.toInt()} ${'units.g'.tr()}', style: TextStyle(fontWeight: FontWeight.w600, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(color)),
          ),
          const SizedBox(height: 8),
          Text(hint, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMealTypeCard(String title, int calories, int totalCalories, IconData icon) {
    final percent = totalCalories > 0 ? ((calories / totalCalories) * 100).toInt() : 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.textSecondary.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('$calories ${'units.kcal'.tr()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('$percent ${'analytics.percent_of_daily'.tr()}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildWeightAnalytics(BuildContext context) {
    return BlocBuilder<TrackerCubit, TrackerState>(
      key: const ValueKey(1),
      builder: (context, state) {
        final history = state.weightHistory.toList()..sort((a, b) => b.date.compareTo(a.date)); 

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    Text('analytics.current_weight'.tr(), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    // ВИПРАВЛЕНО: Замінили хардкод "кг" на 'units.kg'.tr()
                    Text(
                      history.isNotEmpty ? '${history.first.weight} ${'units.kg'.tr()}' : '-- ${'units.kg'.tr()}', 
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showWeightDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(IconsaxPlusLinear.add),
                      label: Text('analytics.add_weighing'.tr()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: history.isEmpty
                ? Center(
                    key: const ValueKey('empty_scale'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/scale.json', width: 160, height: 160, repeat: false),
                        const SizedBox(height: 16),
                        Text('analytics.empty_weight_history'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 90), 
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 90), 
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final record = history[index];
                      final formatter = DateFormat('dd MMM yyyy, HH:mm', context.locale.languageCode == 'en' ? 'en_US' : 'uk_UA');
                      double diff = index < history.length - 1 ? record.weight - history[index + 1].weight : 0.0;

                      return Dismissible(
                        key: ValueKey(record.id ?? record.date.toIso8601String()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
                          child: const Icon(IconsaxPlusLinear.trash, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await DialogUtils.showConfirmDialog(
                            context,
                            title: 'analytics.delete_record_title'.tr(),
                            content: 'analytics.delete_weight_content'.tr(namedArgs: {'weight': record.weight.toString()}),
                            confirmText: 'analytics.delete'.tr(),
                            cancelText: 'analytics.cancel'.tr(),
                          );
                        },
                        onDismissed: (_) {
                          if (record.id != null) {
                            context.read<TrackerCubit>().deleteWeightRecord(record.id!);
                            CustomSnackbar.showSuccess(context, 'analytics.record_deleted'.tr());
                          }
                        },
                        child: GestureDetector(
                          onTap: () => _showWeightDialog(context, recordToEdit: record),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ВИПРАВЛЕНО: Замінили хардкод "кг" на 'units.kg'.tr()
                                    Text('${record.weight} ${'units.kg'.tr()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    const SizedBox(height: 4),
                                    Text(formatter.format(record.date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  ],
                                ),
                                if (index < history.length - 1)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: diff > 0 ? Colors.red.withAlpha(30) : (diff < 0 ? Colors.green.withAlpha(30) : Colors.grey.withAlpha(30)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1),
                                      style: TextStyle(color: diff > 0 ? Colors.red : (diff < 0 ? Colors.green : Colors.grey), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        );
      },
    );
  }

  void _showWeightDialog(BuildContext context, {WeightRecordModel? recordToEdit}) {
    final isEditing = recordToEdit != null;
    final TextEditingController weightController = TextEditingController(text: isEditing ? recordToEdit.weight.toString() : '');
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(isEditing ? 'analytics.update'.tr() : 'analytics.new_weighing'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'analytics.your_weight_kg'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('analytics.cancel'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      final w = double.tryParse(weightController.text.replaceAll(',', '.'));
                      if (w != null && w > 0) {
                        if (isEditing && recordToEdit.id != null) {
                          context.read<TrackerCubit>().updateWeightRecord(recordToEdit.id!, w, recordToEdit.date);
                        } else {
                          context.read<TrackerCubit>().addWeightRecord(w);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(isEditing ? 'analytics.update'.tr() : 'analytics.save'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
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

  // ДОДАНО: Перевірка на планшет (ширина більше 600 пікселів)
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    // Отримуємо розміри екрану для відсоткових відступів
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final tablet = isTablet(context);

    // Відсоткові відступи по боках: 6% для телефону, 10% для планшету
    final horizontalPadding = tablet ? screenWidth * 0.1 : screenWidth * 0.06;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'analytics.title'.tr(), 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            _buildCustomTabBar(horizontalPadding, tablet),
            SizedBox(height: screenHeight * 0.02),
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
                child: _selectedTab == 0 
                    ? _buildNutritionAnalytics(context, horizontalPadding, tablet) 
                    : _buildWeightAnalytics(context, horizontalPadding, tablet),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTabBar(double hPadding, bool tablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      child: Container(
        height: tablet ? 60 : 50, // Більша висота на планшеті
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
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
                    borderRadius: BorderRadius.circular(30),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: tablet ? 18 : 14,
                          color: _selectedTab == 0 ? Colors.white : AppColors.textSecondary
                        ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: tablet ? 18 : 14,
                          color: _selectedTab == 1 ? Colors.white : AppColors.textSecondary
                        ),
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

  Widget _buildNutritionAnalytics(BuildContext context, double hPadding, bool tablet) {
    return BlocBuilder<TrackerCubit, TrackerState>(
      key: const ValueKey(0),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = context.read<TrackerCubit>();
        int breakfastCals = 0, lunchCals = 0, dinnerCals = 0, snackCals = 0;
        
        for (var m in state.meals) {
          if (m.mealType == MealType.breakfast) breakfastCals += m.calories;
          if (m.mealType == MealType.lunch) lunchCals += m.calories;
          if (m.mealType == MealType.dinner) dinnerCals += m.calories;
          if (m.mealType == MealType.snack) snackCals += m.calories;
        }

        final goalPro = state.user?.dailyProteins ?? 150;
        final goalFat = state.user?.dailyFats ?? 70;
        final goalCarb = state.user?.dailyCarbs ?? 250;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 10.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('analytics.macros_distribution'.tr(), style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: tablet ? 24 : 16),
              
              // Для планшету картки макросів можна поставити в ряд, але залишаємо в стовпець, щоб не ламати дизайн. Просто робимо їх вищими.
              _buildMacroCard('analytics.proteins'.tr(), cubit.totalDailyProteins, goalPro.toDouble(), Colors.blue, 'analytics.proteins_hint'.tr(), tablet),
              SizedBox(height: tablet ? 16 : 12),
              _buildMacroCard('analytics.fats'.tr(), cubit.totalDailyFats, goalFat.toDouble(), Colors.orange, 'analytics.fats_hint'.tr(), tablet),
              SizedBox(height: tablet ? 16 : 12),
              _buildMacroCard('analytics.carbs'.tr(), cubit.totalDailyCarbs, goalCarb.toDouble(), Colors.green, 'analytics.carbs_hint'.tr(), tablet),
              
              SizedBox(height: tablet ? 48 : 32),
              Text('analytics.calories_by_meal'.tr(), style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: tablet ? 24 : 16),

              // АДАПТАЦІЯ ПІД ПЛАНШЕТ: 1 ряд з 4 елементів, або 2 ряди по 2 для телефону
              if (tablet) 
                Row(
                  children: [
                    Expanded(child: _buildMealTypeCard('meal_types.breakfast'.tr(), breakfastCals, cubit.totalDailyCalories, IconsaxPlusLinear.sun_1, tablet)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMealTypeCard('meal_types.lunch'.tr(), lunchCals, cubit.totalDailyCalories, IconsaxPlusLinear.clock_1, tablet)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMealTypeCard('meal_types.dinner'.tr(), dinnerCals, cubit.totalDailyCalories, IconsaxPlusLinear.moon, tablet)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMealTypeCard('meal_types.snack'.tr(), snackCals, cubit.totalDailyCalories, Icons.cookie_outlined, tablet)),
                  ],
                )
              else 
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildMealTypeCard('meal_types.breakfast'.tr(), breakfastCals, cubit.totalDailyCalories, IconsaxPlusLinear.sun_1, tablet)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMealTypeCard('meal_types.lunch'.tr(), lunchCals, cubit.totalDailyCalories, IconsaxPlusLinear.clock_1, tablet)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildMealTypeCard('meal_types.dinner'.tr(), dinnerCals, cubit.totalDailyCalories, IconsaxPlusLinear.moon, tablet)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMealTypeCard('meal_types.snack'.tr(), snackCals, cubit.totalDailyCalories, Icons.cookie_outlined, tablet)),
                      ],
                    ),
                  ],
                ),
                
              const SizedBox(height: 90), 
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroCard(String title, double consumed, double goal, Color color, String hint, bool tablet) {
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    return Container(
      padding: EdgeInsets.all(tablet ? 24 : 16),
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
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 18 : 16)),
              Text('${consumed.toInt()} / ${goal.toInt()} ${'units.g'.tr()}', style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: tablet ? 18 : 16)),
            ],
          ),
          SizedBox(height: tablet ? 16 : 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress, minHeight: tablet ? 14 : 10, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(color)),
          ),
          SizedBox(height: tablet ? 12 : 8),
          Text(hint, style: TextStyle(fontSize: tablet ? 14 : 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMealTypeCard(String title, int calories, int totalCalories, IconData icon, bool tablet) {
    final percent = totalCalories > 0 ? ((calories / totalCalories) * 100).toInt() : 0;
    return Container(
      padding: EdgeInsets.all(tablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.textSecondary.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: tablet ? 32 : 24),
          SizedBox(height: tablet ? 16 : 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: tablet ? 16 : 14)),
          const SizedBox(height: 4),
          Text('$calories ${'units.kcal'.tr()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 18, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('$percent ${'analytics.percent_of_daily'.tr()}', style: TextStyle(fontSize: tablet ? 14 : 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildWeightAnalytics(BuildContext context, double hPadding, bool tablet) {
    return BlocBuilder<TrackerCubit, TrackerState>(
      key: const ValueKey(1),
      builder: (context, state) {
        final history = state.weightHistory.toList()..sort((a, b) => b.date.compareTo(a.date)); 

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(tablet ? 30 : 20),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGradient,
                  borderRadius: BorderRadius.circular(tablet ? 30 : 20),
                  boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    Text('analytics.current_weight'.tr(), style: TextStyle(color: Colors.white70, fontSize: tablet ? 18 : 14)),
                    SizedBox(height: tablet ? 12 : 8),
                    Text(
                      history.isNotEmpty ? '${history.first.weight} ${'units.kg'.tr()}' : '-- ${'units.kg'.tr()}', 
                      style: TextStyle(color: Colors.white, fontSize: tablet ? 56 : 36, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: tablet ? 24 : 16),
                    ElevatedButton.icon(
                      onPressed: () => _showWeightDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(horizontal: tablet ? 30 : 20, vertical: tablet ? 16 : 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: Icon(IconsaxPlusLinear.add, size: tablet ? 24 : 20),
                      label: Text('analytics.add_weighing'.tr(), style: TextStyle(fontSize: tablet ? 18 : 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: tablet ? 32 : 24),
            
            Expanded(
              child: history.isEmpty
                ? Center(
                    key: const ValueKey('empty_scale'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/scale.json', 
                          width: MediaQuery.of(context).size.width * (tablet ? 0.3 : 0.45), 
                          repeat: false
                        ),
                        const SizedBox(height: 16),
                        Text('analytics.empty_weight_history'.tr(), style: TextStyle(color: AppColors.textSecondary, fontSize: tablet ? 20 : 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 90), 
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: hPadding, right: hPadding, bottom: 90), 
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
                            padding: EdgeInsets.all(tablet ? 24 : 16),
                            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${record.weight} ${'units.kg'.tr()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 22 : 18)),
                                    const SizedBox(height: 4),
                                    Text(formatter.format(record.date), style: TextStyle(color: AppColors.textSecondary, fontSize: tablet ? 14 : 12)),
                                  ],
                                ),
                                if (index < history.length - 1)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: tablet ? 12 : 8, vertical: tablet ? 8 : 4),
                                    decoration: BoxDecoration(
                                      color: diff > 0 ? Colors.red.withAlpha(30) : (diff < 0 ? Colors.green.withAlpha(30) : Colors.grey.withAlpha(30)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: diff > 0 ? Colors.red : (diff < 0 ? Colors.green : Colors.grey), 
                                        fontWeight: FontWeight.bold,
                                        fontSize: tablet ? 16 : 14
                                      ),
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
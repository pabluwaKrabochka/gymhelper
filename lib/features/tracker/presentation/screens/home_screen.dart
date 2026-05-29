import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/core/theme_cubit.dart';
import 'package:gymhelper/features/tracker/presentation/screens/home_widgets.dart'; 
import 'package:gymhelper/shared/theme_switcher.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:iconsax_plus/iconsax_plus.dart';
import '../cubit/tracker_cubit.dart';
import '../cubit/tracker_state.dart';
import '../../../../core/constants/color_constants.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final hPadding = tablet ? MediaQuery.of(context).size.width * 0.1 : 16.0;
    final langCode = context.locale.languageCode;

    return BlocBuilder<TrackerCubit, TrackerState>(
      builder: (context, state) {
        final cubit = context.read<TrackerCubit>();

        if (state.isLoading) return const Center(child: CircularProgressIndicator());

        final goalCals = state.user?.dailyCalories ?? 2000;
        final consumedCals = cubit.totalDailyCalories;

        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return Scaffold(
              backgroundColor: Colors.transparent, 
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0, scrolledUnderElevation: 0, leadingWidth: 85, 
                leading: const Center(child: Padding(padding: EdgeInsets.only(left: 16.0), child: ThemeSwitcher())),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('home.my_day'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: tablet ? 26 : 20)), 
                    const SizedBox(width: 8),
                    Container( // Спрощений стрік для краси коду
                      padding: EdgeInsets.symmetric(horizontal: tablet ? 12 : 8, vertical: tablet ? 6 : 4),
                      decoration: BoxDecoration(color: Colors.orange.withAlpha(30), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: tablet ? 28 : 20),
                          const SizedBox(width: 4),
                          Text('${state.streak}', style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
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
                        onTap: () => context.setLocale(Locale(langCode == 'uk' ? 'en' : 'uk')),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: tablet ? 12 : 10, vertical: tablet ? 8 : 6),
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.textSecondary.withAlpha(20))),
                          child: Text(langCode == 'en' ? '🇺🇸 EN' : '🇺🇦 UK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 16 : 14, color: AppColors.textPrimary)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  HomeWidgets.buildDateSelector(context, state.selectedDate, hPadding, tablet),
                  SizedBox(height: tablet ? 30 : 20),
                  HomeWidgets.buildCalorieProgress(consumedCals, goalCals, consumedCals > goalCals, context, tablet),
                  SizedBox(height: tablet ? 30 : 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeWidgets.buildMacroItem(context, 'analytics.proteins'.tr(), cubit.totalDailyProteins, (state.user?.dailyProteins ?? 150).toDouble(), Colors.blue, tablet),
                        HomeWidgets.buildMacroItem(context, 'analytics.fats'.tr(), cubit.totalDailyFats, (state.user?.dailyFats ?? 70).toDouble(), Colors.orange, tablet),
                        HomeWidgets.buildMacroItem(context, 'analytics.carbs'.tr(), cubit.totalDailyCarbs, (state.user?.dailyCarbs ?? 250).toDouble(), Colors.green, tablet),
                      ],
                    ),
                  ),
                  SizedBox(height: tablet ? 30 : 20),
                  const Divider(),
                  Expanded(
                    child: state.meals.isEmpty
                      ? Center(child: Lottie.asset('assets/food.json', width: 200))
                      : ListView.builder(
                          padding: EdgeInsets.only(left: hPadding, right: hPadding, bottom: 160), 
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.meals.length,
                          itemBuilder: (context, index) {
                            final meal = state.meals[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Dismissible(
                                key: ValueKey(meal.id), direction: DismissDirection.endToStart,
                                background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(20)), child: const Icon(IconsaxPlusLinear.trash, color: Colors.white)),
                                onDismissed: (_) { if (meal.id != null) cubit.deleteMealRecord(meal.id!); },
                                child: Container(
                                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.textSecondary.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: tablet ? 24 : 16, vertical: tablet ? 12 : 8),
                                        leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: HomeWidgets.getMealColor(meal.mealType).withAlpha(30), shape: BoxShape.circle), child: Icon(HomeWidgets.getMealIcon(meal.mealType), color: HomeWidgets.getMealColor(meal.mealType))),
                                        title: Text(HomeWidgets.getLocalizedFoodName(meal.foodName, langCode), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 20 : 16, color: AppColors.textPrimary)),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Wrap(
                                            spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              Text(HomeWidgets.getMealTypeName(meal.mealType), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: tablet ? 14 : 12)),
                                              HomeWidgets.buildMacroBadge('${meal.proteins} ${'units.p'.tr()}', Colors.blue, tablet),
                                              HomeWidgets.buildMacroBadge('${meal.fats} ${'units.f'.tr()}', Colors.orange, tablet),
                                              HomeWidgets.buildMacroBadge('${meal.carbs} ${'units.c'.tr()}', Colors.green, tablet),
                                            ],
                                          ),
                                        ),
                                        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${meal.calories}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: tablet ? 24 : 18, color: AppColors.textPrimary)), Text('units.kcal'.tr(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: tablet ? 14 : 11, color: Colors.grey))]),
                                        onTap: () => HomeWidgets.showMealActionSheet(context, meal, tablet),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
}
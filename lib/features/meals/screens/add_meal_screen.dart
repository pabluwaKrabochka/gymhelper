import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:gymhelper/core/constants/food_database.dart';
import 'package:gymhelper/features/meals/presentation/cubit/add_meal_cubit.dart';
import 'package:gymhelper/features/meals/presentation/cubit/add_meal_state.dart';
import 'package:gymhelper/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../data/models/meal_record_model.dart';
import '../../../../core/constants/color_constants.dart';

import 'add_extra_item_screen.dart'; 

class AddMealScreen extends StatelessWidget {
  final MealRecordModel? mealToEdit;

  const AddMealScreen({super.key, this.mealToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMealCubit()..init(mealToEdit),
      child: const _AddMealScreenView(),
    );
  }
}

class _AddMealScreenView extends StatefulWidget {
  const _AddMealScreenView();

  @override
  State<_AddMealScreenView> createState() => _AddMealScreenViewState();
}

class _AddMealScreenViewState extends State<_AddMealScreenView> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController? _autoCompleteController; 
  late TextEditingController _weightGramsController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinsController;
  late TextEditingController _fatsController;
  late TextEditingController _carbsController;

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

 @override
  void initState() {
    super.initState();
    _weightGramsController = TextEditingController();
    _caloriesController = TextEditingController();
    _proteinsController = TextEditingController();
    _fatsController = TextEditingController();
    _carbsController = TextEditingController();
   
  }

  @override
  void dispose() {
    _weightGramsController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<AddMealCubit>().state;
      final trackerCubit = context.read<TrackerCubit>();

      final mainFoodName = state.mainFood != null 
          ? state.mainFood!.nameUk 
          : (_autoCompleteController?.text.trim() ?? 'Прийом їжі');

      // ВИПРАВЛЕНО: Додано "final savedAddons =" та "final savedDrinks ="
      final savedAddons = state.selectedAddons.map((a) => ExtraItemRecord(
        foodName: a.food.nameUk,
        weight: a.weight,
        calories: a.calories,
      )).toList();

      final savedDrinks = state.selectedDrinks.map((d) => ExtraItemRecord(
        foodName: d.food.nameUk, 
        weight: d.weight,
        calories: d.calories,
      )).toList();

      final calories = int.tryParse(_caloriesController.text.replaceAll(',', '.').trim()) ?? 0;
      final proteins = double.tryParse(_proteinsController.text.replaceAll(',', '.').trim()) ?? 0.0;
      final fats = double.tryParse(_fatsController.text.replaceAll(',', '.').trim()) ?? 0.0;
      final carbs = double.tryParse(_carbsController.text.replaceAll(',', '.').trim()) ?? 0.0;

      if (state.mealToEdit != null) {
        trackerCubit.updateMealRecord(
          id: state.mealToEdit!.id!,
          foodName: mainFoodName, 
          calories: calories,
          proteins: proteins,
          fats: fats,
          carbs: carbs,
          mealType: state.mealType,
          date: state.mealToEdit!.date,
          addons: savedAddons, 
          drinks: savedDrinks, 
        );
      } else {
        trackerCubit.addMealRecord(
          foodName: mainFoodName, 
          calories: calories,
          proteins: proteins,
          fats: fats,
          carbs: carbs,
          mealType: state.mealType,
          addons: savedAddons, 
          drinks: savedDrinks, 
        );
      }
      Navigator.pop(context);
    }
  }

  String? _validateMacro(String? value) {
    if (value == null || value.trim().isEmpty) return 'profile.error_value'.tr();
    final val = double.tryParse(value.replaceAll(',', '.'));
    if (val == null || val <= 0) return '> 0';
    return null;
  }

  Future<void> _navigateToAddExtra(bool isDrink) async {
    final result = await Navigator.push<SelectedFoodItem>(
      context,
      MaterialPageRoute(builder: (_) => AddExtraItemScreen(isDrink: isDrink)),
    );

    if (result != null && mounted) {
      if (isDrink) {
        context.read<AddMealCubit>().addDrink(result);
      } else {
        context.read<AddMealCubit>().addAddon(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    final horizontalPadding = tablet ? screenWidth * 0.15 : 20.0;
    final contentPadding = EdgeInsets.symmetric(vertical: tablet ? 20 : 16, horizontal: 16);

    return BlocConsumer<AddMealCubit, AddMealState>(
      listener: (context, state) {
        if (_caloriesController.text != state.totalCalories.toString()) {
          _caloriesController.text = state.totalCalories.toString();
          _proteinsController.text = state.totalProteins.toStringAsFixed(1);
          _fatsController.text = state.totalFats.toStringAsFixed(1);
          _carbsController.text = state.totalCarbs.toStringAsFixed(1);
        }
        // Коли Cubit вирахує вагу основної страви, показуємо її
        if (state.mainWeight > 0 && _weightGramsController.text.isEmpty) {
          _weightGramsController.text = state.mainWeight.round().toString();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddMealCubit>();
        final isEditing = state.mealToEdit != null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              isEditing ? 'add_meal.edit_title'.tr() : 'add_meal.add_title'.tr(),
              style: TextStyle(fontSize: tablet ? 24 : 20, fontWeight: FontWeight.bold)
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: tablet ? 30.0 : 20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Autocomplete<FoodItemData>(
                        initialValue: TextEditingValue(text: state.foodName),
                        optionsBuilder: (TextEditingValue text) {
                          if (text.text.isEmpty) return const Iterable<FoodItemData>.empty();
                          return foodDatabase.where((f) => f.getName(langCode).toLowerCase().contains(text.text.toLowerCase()));
                        },
                        displayStringForOption: (FoodItemData option) => option.getName(langCode),
                        onSelected: (FoodItemData selection) {
                          cubit.selectMainFood(selection);
                          FocusScope.of(context).unfocus(); 
                        },
                        fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
                          _autoCompleteController = textController;
                          return TextFormField(
                            controller: textController,
                            focusNode: focusNode,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: tablet ? 18 : 16, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'add_meal.what_did_you_eat'.tr(),
                              hintText: 'add_meal.example_food'.tr(),
                              prefixIcon: Icon(IconsaxPlusLinear.reserve, size: tablet ? 28 : 24),
                              filled: true,
                              fillColor: AppColors.surface,
                              contentPadding: contentPadding,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            ),
                            onChanged: (val) => cubit.updateName(val),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'add_meal.please_enter_name'.tr() : null,
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.surface,
                              child: SizedBox(
                                width: screenWidth - (horizontalPadding * 2),
                                height: tablet ? 300 : 200,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option.getName(langCode), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                      subtitle: Text('${option.calories} ${'add_meal.kcal_per_100g'.tr()}', style: TextStyle(color: AppColors.textSecondary)),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: tablet ? 24 : 16),

                      TextFormField(
                        controller: _weightGramsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*'))],
                        maxLength: 5,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 22 : 18, color: AppColors.primary),
                        decoration: InputDecoration(
                          counterText: '',
                          labelText: 'add_meal.portion_weight'.tr(),
                          hintText: '150',
                          prefixIcon: Icon(IconsaxPlusLinear.weight_1, size: tablet ? 28 : 24),
                          filled: true,
                          fillColor: AppColors.primary.withAlpha(25), 
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        onChanged: (val) {
                          final weight = double.tryParse(val.replaceAll(',', '.')) ?? 0;
                          cubit.updateMainWeight(weight);
                        },
                        validator: _validateMacro,
                      ),
                      SizedBox(height: tablet ? 24 : 16),

                      Text("Добавки", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Додати'),
                              backgroundColor: AppColors.primary.withAlpha(30),
                              side: BorderSide.none,
                              onPressed: () => _navigateToAddExtra(false),
                            ),
                            const SizedBox(width: 8),
                            ...state.selectedAddons.map((addon) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Chip(
                                label: Text('${addon.food.getName(langCode)} (${addon.weight.toInt()}г)'),
                                deleteIcon: const Icon(Icons.close_rounded, size: 16),
                                onDeleted: () => cubit.removeAddon(addon),
                                backgroundColor: AppColors.surface,
                                side: BorderSide(color: AppColors.textSecondary.withAlpha(50)),
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: tablet ? 24 : 16),

                      Text("Напої", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Додати'),
                              backgroundColor: AppColors.primary.withAlpha(30),
                              side: BorderSide.none,
                              onPressed: () => _navigateToAddExtra(true),
                            ),
                            const SizedBox(width: 8),
                            ...state.selectedDrinks.map((drink) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Chip(
                                label: Text('${drink.food.getName(langCode)} (${drink.weight.toInt()}мл)'),
                                deleteIcon: const Icon(Icons.close_rounded, size: 16),
                                onDeleted: () => cubit.removeDrink(drink),
                                backgroundColor: AppColors.surface,
                                side: BorderSide(color: AppColors.textSecondary.withAlpha(50)),
                              ),
                            )),
                          ],
                        ),
                      ),

                      SizedBox(height: tablet ? 32 : 24),
                      const Divider(),
                      SizedBox(height: tablet ? 24 : 16),

                      TextFormField(
                        controller: _caloriesController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        maxLength: 5, 
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*'))],
                        style: TextStyle(fontSize: tablet ? 18 : 16, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          counterText: '',
                          labelText: 'add_meal.calories'.tr(),
                          prefixIcon: Icon(IconsaxPlusLinear.flash, size: tablet ? 28 : 24),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        validator: _validateMacro,
                      ),
                      SizedBox(height: tablet ? 24 : 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _proteinsController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              maxLength: 5,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*'))],
                              style: TextStyle(fontSize: tablet ? 18 : 16, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: 'add_meal.proteins'.tr(),
                                filled: true,
                                fillColor: AppColors.surface,
                                contentPadding: contentPadding,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                              validator: _validateMacro,
                            ),
                          ),
                          SizedBox(width: tablet ? 16 : 10),
                          Expanded(
                            child: TextFormField(
                              controller: _fatsController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              maxLength: 5,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*'))],
                              style: TextStyle(fontSize: tablet ? 18 : 16, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: 'add_meal.fats'.tr(),
                                filled: true,
                                fillColor: AppColors.surface,
                                contentPadding: contentPadding,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                              validator: _validateMacro,
                            ),
                          ),
                          SizedBox(width: tablet ? 16 : 10),
                          Expanded(
                            child: TextFormField(
                              controller: _carbsController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              maxLength: 5,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*'))],
                              style: TextStyle(fontSize: tablet ? 18 : 16, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: 'add_meal.carbs'.tr(),
                                filled: true,
                                fillColor: AppColors.surface,
                                contentPadding: contentPadding,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                              validator: _validateMacro,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: tablet ? 32 : 24),
                      Text('add_meal.meal_type'.tr(), style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      SizedBox(height: tablet ? 16 : 12),
                      
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: MealType.values.map((type) {
                            final isSelected = state.mealType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text('meal_types.${type.name}'.tr()),
                                selected: isSelected,
                                padding: EdgeInsets.symmetric(horizontal: tablet ? 16 : 8, vertical: tablet ? 12 : 8),
                                onSelected: (selected) {
                                  if (selected) cubit.updateMealType(type);
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: tablet ? 18 : 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      
                      SizedBox(height: tablet ? 60 : 40),
                      
                      Container(
                        width: double.infinity,
                        height: tablet ? 65 : 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _saveMeal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            isEditing ? 'add_meal.update'.tr() : 'add_meal.save'.tr(), 
                            style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
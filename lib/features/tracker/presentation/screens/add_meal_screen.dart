import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:gymhelper/core/constants/food_database.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../data/models/meal_record_model.dart';
import '../../../../core/constants/color_constants.dart';
import '../cubit/tracker_cubit.dart';

class AddMealScreen extends StatefulWidget {
  final MealRecordModel? mealToEdit;

  const AddMealScreen({super.key, this.mealToEdit});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController? _autoCompleteController; 
  
  late TextEditingController _weightGramsController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinsController;
  late TextEditingController _fatsController;
  late TextEditingController _carbsController;
  late MealType _selectedMealType;
  
  FoodItemData? _selectedFoodFromDb; 

  bool get isEditing => widget.mealToEdit != null;

  // Допоміжна функція для визначення розміру екрану
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  void initState() {
    super.initState();
    
    _caloriesController = TextEditingController(text: widget.mealToEdit?.calories.toString() ?? '');
    _proteinsController = TextEditingController(text: widget.mealToEdit?.proteins.toString() ?? '');
    _fatsController = TextEditingController(text: widget.mealToEdit?.fats.toString() ?? '');
    _carbsController = TextEditingController(text: widget.mealToEdit?.carbs.toString() ?? '');
    
    _selectedMealType = widget.mealToEdit?.mealType ?? MealType.breakfast;

    String initialWeight = '';

    if (isEditing) {
      try {
        _selectedFoodFromDb = foodDatabase.firstWhere(
          (food) => food.nameUk.toLowerCase() == widget.mealToEdit!.foodName.toLowerCase() || 
                    food.nameEn.toLowerCase() == widget.mealToEdit!.foodName.toLowerCase()
        );
        
        if (_selectedFoodFromDb!.calories > 0) {
          double grams = (widget.mealToEdit!.calories / _selectedFoodFromDb!.calories) * 100;
          initialWeight = grams.round().toString();
        } else if (_selectedFoodFromDb!.proteins > 0) {
          double grams = (widget.mealToEdit!.proteins / _selectedFoodFromDb!.proteins) * 100;
          initialWeight = grams.round().toString();
        }
      } catch (e) {
        // Страва не з бази (введена вручну)
      }
    }

    _weightGramsController = TextEditingController(text: initialWeight); 
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

  void _calculateMacros() {
    if (_selectedFoodFromDb == null) return;
    if (!mounted) return;

    final grams = double.tryParse(_weightGramsController.text.trim()) ?? 0;
    if (grams <= 0) {
      if (mounted) { 
        setState(() {
          _caloriesController.clear();
          _proteinsController.clear();
          _fatsController.clear();
          _carbsController.clear();
        });
      }
      return;
    }

    final multiplier = grams / 100;

    if (mounted) {
      setState(() {
        _caloriesController.text = (_selectedFoodFromDb!.calories * multiplier).round().toString();
        _proteinsController.text = (_selectedFoodFromDb!.proteins * multiplier).toStringAsFixed(1);
        _fatsController.text = (_selectedFoodFromDb!.fats * multiplier).toStringAsFixed(1);
        _carbsController.text = (_selectedFoodFromDb!.carbs * multiplier).toStringAsFixed(1);
      });
    }
  }

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final name = _autoCompleteController?.text.trim() ?? '';
      
      final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
      final proteins = double.tryParse(_proteinsController.text.trim()) ?? 0.0;
      final fats = double.tryParse(_fatsController.text.trim()) ?? 0.0;
      final carbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;

      if (isEditing) {
        context.read<TrackerCubit>().updateMealRecord(
          id: widget.mealToEdit!.id!,
          foodName: name,
          calories: calories,
          proteins: proteins,
          fats: fats,
          carbs: carbs,
          mealType: _selectedMealType,
          date: widget.mealToEdit!.date,
        );
      } else {
        context.read<TrackerCubit>().addMealRecord(
          foodName: name,
          calories: calories,
          proteins: proteins,
          fats: fats,
          carbs: carbs,
          mealType: _selectedMealType,
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Робимо красивий відступ для планшетів (щоб поля не були на весь екран)
    final horizontalPadding = tablet ? screenWidth * 0.15 : 20.0;
    // Відступи всередині полів вводу (для зручності натискання)
    final contentPadding = EdgeInsets.symmetric(vertical: tablet ? 20 : 16, horizontal: 16);

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
                    initialValue: TextEditingValue(text: widget.mealToEdit?.foodName ?? ''),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<FoodItemData>.empty();
                      }
                      return foodDatabase.where((food) => 
                        food.getName(langCode).toLowerCase().contains(textEditingValue.text.toLowerCase())
                      );
                    },
                    displayStringForOption: (FoodItemData option) => option.getName(langCode),
                    onSelected: (FoodItemData selection) {
                      _selectedFoodFromDb = selection;
                      _calculateMacros(); 
                      FocusScope.of(context).unfocus(); 
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                      _autoCompleteController = textEditingController;
                      
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: tablet ? 18 : 16),
                        decoration: InputDecoration(
                          labelText: 'add_meal.what_did_you_eat'.tr(),
                          labelStyle: TextStyle(fontSize: tablet ? 18 : 16),
                          hintText: 'add_meal.example_food'.tr(),
                          prefixIcon: Icon(IconsaxPlusLinear.reserve, size: tablet ? 28 : 24),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: contentPadding,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          _selectedFoodFromDb = null; 
                        },
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'add_meal.please_enter_name'.tr() : null,
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            // Адаптивна ширина підказок
                            width: screenWidth - (horizontalPadding * 2),
                            height: tablet ? 300 : 200,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              physics: const BouncingScrollPhysics(),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: tablet ? 24 : 16, vertical: tablet ? 8 : 4),
                                  title: Text(option.getName(langCode), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 18 : 16)),
                                  subtitle: Text('${option.calories} ${'add_meal.kcal_per_100g'.tr()}', style: TextStyle(fontSize: tablet ? 16 : 14)),
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
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 22 : 18, color: AppColors.primary),
                    decoration: InputDecoration(
                      labelText: 'add_meal.portion_weight'.tr(),
                      labelStyle: TextStyle(fontSize: tablet ? 18 : 16),
                      hintText: '150',
                      prefixIcon: Icon(IconsaxPlusLinear.weight_1, size: tablet ? 28 : 24),
                      filled: true,
                      fillColor: AppColors.primary.withAlpha(25), 
                      contentPadding: contentPadding,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => _calculateMacros(), 
                  ),
                  SizedBox(height: tablet ? 32 : 24),
                  const Divider(),
                  SizedBox(height: tablet ? 24 : 16),

                  TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: tablet ? 18 : 16),
                    decoration: InputDecoration(
                      labelText: 'add_meal.calories'.tr(),
                      labelStyle: TextStyle(fontSize: tablet ? 18 : 16),
                      prefixIcon: Icon(IconsaxPlusLinear.flash, size: tablet ? 28 : 24),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: contentPadding,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  SizedBox(height: tablet ? 24 : 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _proteinsController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: tablet ? 18 : 16),
                          decoration: InputDecoration(
                            labelText: 'add_meal.proteins'.tr(),
                            labelStyle: TextStyle(fontSize: tablet ? 16 : 14),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: contentPadding,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(width: tablet ? 16 : 10),
                      Expanded(
                        child: TextFormField(
                          controller: _fatsController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: tablet ? 18 : 16),
                          decoration: InputDecoration(
                            labelText: 'add_meal.fats'.tr(),
                            labelStyle: TextStyle(fontSize: tablet ? 16 : 14),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: contentPadding,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(width: tablet ? 16 : 10),
                      Expanded(
                        child: TextFormField(
                          controller: _carbsController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: tablet ? 18 : 16),
                          decoration: InputDecoration(
                            labelText: 'add_meal.carbs'.tr(),
                            labelStyle: TextStyle(fontSize: tablet ? 16 : 14),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: contentPadding,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: tablet ? 32 : 24),
                  Text('add_meal.meal_type'.tr(), style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: tablet ? 16 : 12),
                  
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: MealType.values.map((type) {
                        final isSelected = _selectedMealType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(_getMealTypeName(type)),
                            selected: isSelected,
                            padding: EdgeInsets.symmetric(horizontal: tablet ? 16 : 8, vertical: tablet ? 12 : 8),
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedMealType = type);
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

  String _getMealTypeName(MealType type) {
    return 'meal_types.${type.name}'.tr();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/meals/food_database.dart';
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
  
  late TextEditingController _nameController;
  late TextEditingController _weightGramsController; 
  
  late TextEditingController _caloriesController;
  late TextEditingController _proteinsController;
  late TextEditingController _fatsController;
  late TextEditingController _carbsController;
  
  late MealType _selectedMealType;
  FoodItemData? _selectedFoodFromDb; 

  bool get isEditing => widget.mealToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.mealToEdit?.foodName ?? '');
    _weightGramsController = TextEditingController(text: isEditing ? '100' : ''); 
    
    _caloriesController = TextEditingController(text: widget.mealToEdit?.calories.toString() ?? '');
    _proteinsController = TextEditingController(text: widget.mealToEdit?.proteins.toString() ?? '');
    _fatsController = TextEditingController(text: widget.mealToEdit?.fats.toString() ?? '');
    _carbsController = TextEditingController(text: widget.mealToEdit?.carbs.toString() ?? '');
    
    _selectedMealType = widget.mealToEdit?.mealType ?? MealType.breakfast;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightGramsController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _calculateMacros() {
    if (_selectedFoodFromDb == null) return;
    
    final grams = double.tryParse(_weightGramsController.text.trim()) ?? 0;
    if (grams <= 0) {
      _caloriesController.clear();
      _proteinsController.clear();
      _fatsController.clear();
      _carbsController.clear();
      return;
    }

    final multiplier = grams / 100;

    setState(() {
      _caloriesController.text = (_selectedFoodFromDb!.calories * multiplier).round().toString();
      _proteinsController.text = (_selectedFoodFromDb!.proteins * multiplier).toStringAsFixed(1);
      _fatsController.text = (_selectedFoodFromDb!.fats * multiplier).toStringAsFixed(1);
      _carbsController.text = (_selectedFoodFromDb!.carbs * multiplier).toStringAsFixed(1);
    });
  }

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Редагувати запис' : 'Додати прийом їжі'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Autocomplete<FoodItemData>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<FoodItemData>.empty();
                      }
                      return foodDatabase.where((food) => 
                        food.name.toLowerCase().contains(textEditingValue.text.toLowerCase())
                      );
                    },
                    displayStringForOption: (FoodItemData option) => option.name,
                    onSelected: (FoodItemData selection) {
                      _selectedFoodFromDb = selection;
                      _nameController.text = selection.name;
                      _calculateMacros(); 
                      FocusScope.of(context).unfocus(); 
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                      if (!isEditing && _nameController.text.isEmpty) {
                        _nameController = textEditingController;
                      }
                      
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'Що ви з\'їли? (Почніть вводити)',
                          hintText: 'Наприклад: Гречка',
                          prefixIcon: const Icon(IconsaxPlusLinear.reserve),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          _nameController.text = val;
                          _selectedFoodFromDb = null; 
                        },
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Будь ласка, введіть назву' : null,
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 200,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('${option.calories} ккал / 100г'),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _weightGramsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                    decoration: InputDecoration(
                      labelText: 'Вага порції (грами)',
                      hintText: 'Наприклад: 150',
                      prefixIcon: const Icon(IconsaxPlusLinear.weight_1),
                      filled: true,
                      fillColor: AppColors.primary.withAlpha(25), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => _calculateMacros(), 
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Калорійність (ккал)',
                      prefixIcon: const Icon(IconsaxPlusLinear.flash),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _proteinsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Білки (г)',
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _fatsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Жири (г)',
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _carbsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Вуглев. (г)',
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('Тип прийому їжі', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: MealType.values.map((type) {
                        final isSelected = _selectedMealType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(_getMealTypeName(type)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedMealType = type);
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Container(
                    width: double.infinity,
                    height: 56,
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
                      child: Text(isEditing ? 'Оновити' : 'Зберегти', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
    switch (type) {
      case MealType.breakfast: return 'Сніданок';
      case MealType.lunch: return 'Обід';
      case MealType.dinner: return 'Вечеря';
      case MealType.snack: return 'Перекус';
    }
  }
}
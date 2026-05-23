import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../data/models/meal_record_model.dart';
import '../cubit/tracker_cubit.dart';

class AddMealScreen extends StatefulWidget {
  final MealRecordModel? mealToEdit;

  const AddMealScreen({super.key, this.mealToEdit});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Контролери для тексту
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinsController;
  late TextEditingController _fatsController;
  late TextEditingController _carbsController;
  
  late MealType _selectedMealType;

  bool get isEditing => widget.mealToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.mealToEdit?.foodName ?? '');
    _caloriesController = TextEditingController(text: widget.mealToEdit?.calories.toString() ?? '');
    
    // Заповнюємо БЖВ, якщо редагуємо
    _proteinsController = TextEditingController(text: widget.mealToEdit?.proteins.toString() ?? '');
    _fatsController = TextEditingController(text: widget.mealToEdit?.fats.toString() ?? '');
    _carbsController = TextEditingController(text: widget.mealToEdit?.carbs.toString() ?? '');
    
    _selectedMealType = widget.mealToEdit?.mealType ?? MealType.breakfast;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
      
      // Парсимо БЖВ (якщо пусто, то 0.0)
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
      appBar: AppBar(
        title: Text(isEditing ? 'Редагувати запис' : 'Додати прийом їжі'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView( // Додав скрол, щоб клавіатура не перекривала поля
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Що ви з\'їли?',
                      prefixIcon: const Icon(IconsaxPlusLinear.reserve),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Будь ласка, введіть назву' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Калорійність (ккал)',
                      prefixIcon: const Icon(IconsaxPlusLinear.flash),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Введіть кількість калорій';
                      if (int.tryParse(value.trim()) == null) return 'Введіть коректне число';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Рядок для вводу БЖВ (Білки, Жири, Вуглеводи)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _proteinsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Білки (г)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('Тип прийому їжі', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: MealType.values.map((type) {
                      final isSelected = _selectedMealType == type;
                      return ChoiceChip(
                        label: Text(_getMealTypeName(type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedMealType = type);
                        },
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveMeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(isEditing ? 'Оновити' : 'Зберегти', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
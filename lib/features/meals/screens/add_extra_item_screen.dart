import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymhelper/core/constants/food_database.dart';
import 'package:gymhelper/features/meals/presentation/cubit/add_meal_state.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/constants/color_constants.dart';


class AddExtraItemScreen extends StatefulWidget {
  final bool isDrink;

  const AddExtraItemScreen({super.key, required this.isDrink});

  @override
  State<AddExtraItemScreen> createState() => _AddExtraItemScreenState();
}

class _AddExtraItemScreenState extends State<AddExtraItemScreen> {
  final _formKey = GlobalKey<FormState>();
  FoodItemData? _selectedFood;
  final TextEditingController _weightController = TextEditingController();

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  void _save() {
    if (_formKey.currentState!.validate() && _selectedFood != null) {
      final weight = double.parse(_weightController.text.replaceAll(',', '.').trim());
      
      final result = SelectedFoodItem(food: _selectedFood!, weight: weight);
      Navigator.pop(context, result);
    } else if (_selectedFood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('add_meal.please_select_item'.tr())), // Локалізовано!
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = tablet ? screenWidth * 0.15 : 20.0;
    
    final database = widget.isDrink ? drinkDatabase : addonDatabase;
    
    // Локалізовані заголовки
    final title = widget.isDrink ? 'add_meal.add_drink'.tr() : 'add_meal.add_addon'.tr();
    final weightLabel = widget.isDrink ? 'add_meal.volume_ml'.tr() : 'add_meal.weight_g'.tr();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: tablet ? 24 : 20, fontWeight: FontWeight.bold)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Autocomplete<FoodItemData>(
                  optionsBuilder: (TextEditingValue text) {
                    if (text.text.isEmpty) return const Iterable<FoodItemData>.empty();
                    return database.where((f) => f.getName(langCode).toLowerCase().contains(text.text.toLowerCase()));
                  },
                  displayStringForOption: (FoodItemData option) => option.getName(langCode),
                  onSelected: (FoodItemData selection) {
                    setState(() => _selectedFood = selection);
                    FocusScope.of(context).unfocus(); 
                  },
                  fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: textController,
                      focusNode: focusNode,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: tablet ? 18 : 16, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'add_meal.search'.tr(), // Локалізовано!
                        prefixIcon: Icon(widget.isDrink ? Icons.local_cafe_rounded : Icons.water_drop_rounded, size: tablet ? 28 : 24),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      onChanged: (val) => setState(() => _selectedFood = null),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'profile.error_value'.tr() : null,
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
                              // Формуємо рядок типу "ккал / 100 г" або "ккал / 100 мл"
                              final unit = widget.isDrink ? 'add_meal.per_100ml'.tr() : 'add_meal.per_100g'.tr();
                              return ListTile(
                                title: Text(option.getName(langCode), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                subtitle: Text('${option.calories} ${'add_meal.kcal_per_100g'.tr()} $unit', style: TextStyle(color: AppColors.textSecondary)),
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

                if (_selectedFood != null) ...[
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d*'))],
                    maxLength: 4,
                    autofocus: true,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 22 : 18, color: AppColors.primary),
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: weightLabel,
                      prefixIcon: Icon(IconsaxPlusLinear.weight_1, size: tablet ? 28 : 24),
                      filled: true,
                      fillColor: AppColors.primary.withAlpha(25),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'profile.error_value'.tr();
                      final val = double.tryParse(v.replaceAll(',', '.'));
                      if (val == null || val <= 0) return '> 0';
                      return null;
                    },
                  ),
                ],
                
                const Spacer(),
                
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
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('add_meal.save'.tr(), style: TextStyle(fontSize: tablet ? 22 : 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:gymhelper/core/constants/food_database.dart';
import '../../../../data/models/meal_record_model.dart';

// Допоміжний клас для зберігання страви + її ваги + розрахованих макросів
class SelectedFoodItem {
  final FoodItemData food;
  final double weight; // грами або мілілітри

  SelectedFoodItem({required this.food, required this.weight});

  int get calories => (food.calories * weight / 100).round();
  double get proteins => food.proteins * weight / 100;
  double get fats => food.fats * weight / 100;
  double get carbs => food.carbs * weight / 100;
}

class AddMealState {
  final MealRecordModel? mealToEdit;
  final MealType mealType;
  final String foodName;
  final FoodItemData? mainFood;
  final double mainWeight;
  
  // Тепер списки містять не просто FoodItemData, а SelectedFoodItem (з вагою)
  final List<SelectedFoodItem> selectedAddons;
  final List<SelectedFoodItem> selectedDrinks;

  final int totalCalories;
  final double totalProteins;
  final double totalFats;
  final double totalCarbs;

  const AddMealState({
    this.mealToEdit,
    this.mealType = MealType.breakfast,
    this.foodName = '',
    this.mainFood,
    this.mainWeight = 0.0,
    this.selectedAddons = const [],
    this.selectedDrinks = const [],
    this.totalCalories = 0,
    this.totalProteins = 0.0,
    this.totalFats = 0.0,
    this.totalCarbs = 0.0,
  });

  AddMealState copyWith({
    MealRecordModel? mealToEdit,
    MealType? mealType,
    String? foodName,
    FoodItemData? mainFood,
    double? mainWeight,
    List<SelectedFoodItem>? selectedAddons,
    List<SelectedFoodItem>? selectedDrinks,
    int? totalCalories,
    double? totalProteins,
    double? totalFats,
    double? totalCarbs,
  }) {
    return AddMealState(
      mealToEdit: mealToEdit ?? this.mealToEdit,
      mealType: mealType ?? this.mealType,
      foodName: foodName ?? this.foodName,
      mainFood: mainFood ?? this.mainFood,
      mainWeight: mainWeight ?? this.mainWeight,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      selectedDrinks: selectedDrinks ?? this.selectedDrinks,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteins: totalProteins ?? this.totalProteins,
      totalFats: totalFats ?? this.totalFats,
      totalCarbs: totalCarbs ?? this.totalCarbs,
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/core/constants/food_database.dart';
import '../../../../data/models/meal_record_model.dart';
import 'add_meal_state.dart';

class AddMealCubit extends Cubit<AddMealState> {
  AddMealCubit() : super(const AddMealState());

  void init(MealRecordModel? meal) {
    if (meal != null) {
      // 1. Відновлюємо добавки зі збережених даних
      List<SelectedFoodItem> loadedAddons = meal.addons.map((a) {
        final food = addonDatabase.firstWhere(
          (f) => f.nameUk == a.foodName || f.nameEn == a.foodName,
          orElse: () => FoodItemData(nameUk: a.foodName, nameEn: a.foodName, calories: 0, proteins: 0, fats: 0, carbs: 0),
        );
        return SelectedFoodItem(food: food, weight: a.weight);
      }).toList();

      // 2. Відновлюємо напої
      List<SelectedFoodItem> loadedDrinks = meal.drinks.map((d) {
        final food = drinkDatabase.firstWhere(
          (f) => f.nameUk == d.foodName || f.nameEn == d.foodName,
          orElse: () => FoodItemData(nameUk: d.foodName, nameEn: d.foodName, calories: 0, proteins: 0, fats: 0, carbs: 0),
        );
        return SelectedFoodItem(food: food, weight: d.weight);
      }).toList();

      // 3. Відновлюємо основну страву та вираховуємо її вагу
      FoodItemData? mainFood;
      double mainWeight = 0;
      
      int addonsCals = loadedAddons.fold(0, (sum, item) => sum + item.calories);
      int drinksCals = loadedDrinks.fold(0, (sum, item) => sum + item.calories);
      int baseCalories = meal.calories - addonsCals - drinksCals;

      try {
        mainFood = foodDatabase.firstWhere((f) => f.nameUk == meal.foodName || f.nameEn == meal.foodName);
        if (mainFood.calories > 0) {
          mainWeight = (baseCalories / mainFood.calories) * 100;
        }
      } catch (_) {}

      emit(state.copyWith(
        mealToEdit: meal,
        mealType: meal.mealType,
        foodName: meal.foodName,
        mainFood: mainFood,
        mainWeight: mainWeight,
        selectedAddons: loadedAddons,
        selectedDrinks: loadedDrinks,
        totalCalories: meal.calories,
        totalProteins: meal.proteins,
        totalFats: meal.fats,
        totalCarbs: meal.carbs,
      ));
    }
  }

  void updateMealType(MealType type) => emit(state.copyWith(mealType: type));
  void updateName(String name) => emit(state.copyWith(foodName: name));
  void selectMainFood(FoodItemData food) { emit(state.copyWith(mainFood: food, foodName: food.nameUk)); _recalculateTotals(); }
  void updateMainWeight(double weight) { emit(state.copyWith(mainWeight: weight)); _recalculateTotals(); }
  void addAddon(SelectedFoodItem addon) { emit(state.copyWith(selectedAddons: List.from(state.selectedAddons)..add(addon))); _recalculateTotals(); }
  void removeAddon(SelectedFoodItem addon) { emit(state.copyWith(selectedAddons: List.from(state.selectedAddons)..remove(addon))); _recalculateTotals(); }
  void addDrink(SelectedFoodItem drink) { emit(state.copyWith(selectedDrinks: List.from(state.selectedDrinks)..add(drink))); _recalculateTotals(); }
  void removeDrink(SelectedFoodItem drink) { emit(state.copyWith(selectedDrinks: List.from(state.selectedDrinks)..remove(drink))); _recalculateTotals(); }

  void _recalculateTotals() {
    double calories = 0, proteins = 0, fats = 0, carbs = 0;

    if (state.mainFood != null && state.mainWeight > 0) {
      final m = state.mainWeight / 100;
      calories += state.mainFood!.calories * m; proteins += state.mainFood!.proteins * m; fats += state.mainFood!.fats * m; carbs += state.mainFood!.carbs * m;
    }
    for (var a in state.selectedAddons) { calories += a.calories; proteins += a.proteins; fats += a.fats; carbs += a.carbs; }
    for (var d in state.selectedDrinks) { calories += d.calories; proteins += d.proteins; fats += d.fats; carbs += d.carbs; }

    emit(state.copyWith(totalCalories: calories.round(), totalProteins: proteins, totalFats: fats, totalCarbs: carbs));
  }
}
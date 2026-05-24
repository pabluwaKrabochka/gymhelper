import '../../../data/models/meal_record_model.dart';
import '../../../data/models/weight_record_model.dart';

abstract class TrackerRepository {
  // Робота з їжею
  Future<void> addMeal(MealRecordModel meal);
  Future<List<MealRecordModel>> getMealsForDate(DateTime date);
  Future<void> deleteMeal(int id);
  Future<void> updateMeal(MealRecordModel meal);
  
  // Робота з вагою
  Future<void> addWeight(WeightRecordModel weight);
  Future<List<WeightRecordModel>> getWeightHistory();
  
  // ДОДАНО НОВІ МЕТОДИ ДЛЯ ВАГИ:
  Future<void> updateWeight(WeightRecordModel weight);
  Future<void> deleteWeight(int id);
}
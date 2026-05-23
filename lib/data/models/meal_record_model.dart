import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_record_model.freezed.dart';
part 'meal_record_model.g.dart';

enum MealType { breakfast, lunch, dinner, snack }

@freezed
class MealRecordModel with _$MealRecordModel {
  const factory MealRecordModel({
    int? id,
    required String foodName,
    required int calories,
    required double proteins, // Нове
    required double fats,     // Нове
    required double carbs,    // Нове
    required DateTime date,
    required MealType mealType,
  }) = _MealRecordModel;

  factory MealRecordModel.fromJson(Map<String, dynamic> json) => 
      _$MealRecordModelFromJson(json);
}
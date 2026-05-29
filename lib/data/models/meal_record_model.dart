import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_record_model.freezed.dart';
part 'meal_record_model.g.dart';

enum MealType { breakfast, lunch, dinner, snack }

// Нова модель для збереження добавок та напоїв
@freezed
class ExtraItemRecord with _$ExtraItemRecord {
  const factory ExtraItemRecord({
    required String foodName, // Укр. назва з бази (ключ для локалізації)
    required double weight,   // Вага або об'єм (г/мл)
    required int calories,    // Калорії саме цієї добавки/напою
  }) = _ExtraItemRecord;

  factory ExtraItemRecord.fromJson(Map<String, dynamic> json) => 
      _$ExtraItemRecordFromJson(json);
}

@freezed
class MealRecordModel with _$MealRecordModel {
  const factory MealRecordModel({
    int? id,
    required String foodName, // Тільки назва основної страви
    required int calories,    // Загальні калорії (страва + добавки + напої)
    required double proteins, // Загальні білки
    required double fats,     // Загальні жири
    required double carbs,    // Загальні вуглеводи
    required DateTime date,
    required MealType mealType,
    
    // Списки добавок та напоїв (за замовчуванням порожні, щоб не зламати старі дані)
    @Default([]) List<ExtraItemRecord> addons,
    @Default([]) List<ExtraItemRecord> drinks,
  }) = _MealRecordModel;

  factory MealRecordModel.fromJson(Map<String, dynamic> json) => 
      _$MealRecordModelFromJson(json);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtraItemRecordImpl _$$ExtraItemRecordImplFromJson(
  Map<String, dynamic> json,
) => _$ExtraItemRecordImpl(
  foodName: json['foodName'] as String,
  weight: (json['weight'] as num).toDouble(),
  calories: (json['calories'] as num).toInt(),
);

Map<String, dynamic> _$$ExtraItemRecordImplToJson(
  _$ExtraItemRecordImpl instance,
) => <String, dynamic>{
  'foodName': instance.foodName,
  'weight': instance.weight,
  'calories': instance.calories,
};

_$MealRecordModelImpl _$$MealRecordModelImplFromJson(
  Map<String, dynamic> json,
) => _$MealRecordModelImpl(
  id: (json['id'] as num?)?.toInt(),
  foodName: json['foodName'] as String,
  calories: (json['calories'] as num).toInt(),
  proteins: (json['proteins'] as num).toDouble(),
  fats: (json['fats'] as num).toDouble(),
  carbs: (json['carbs'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
  addons:
      (json['addons'] as List<dynamic>?)
          ?.map((e) => ExtraItemRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  drinks:
      (json['drinks'] as List<dynamic>?)
          ?.map((e) => ExtraItemRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MealRecordModelImplToJson(
  _$MealRecordModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'foodName': instance.foodName,
  'calories': instance.calories,
  'proteins': instance.proteins,
  'fats': instance.fats,
  'carbs': instance.carbs,
  'date': instance.date.toIso8601String(),
  'mealType': _$MealTypeEnumMap[instance.mealType]!,
  'addons': instance.addons,
  'drinks': instance.drinks,
};

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};

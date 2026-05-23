// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeightRecordModelImpl _$$WeightRecordModelImplFromJson(
  Map<String, dynamic> json,
) => _$WeightRecordModelImpl(
  id: (json['id'] as num?)?.toInt(),
  weight: (json['weight'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$WeightRecordModelImplToJson(
  _$WeightRecordModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'weight': instance.weight,
  'date': instance.date.toIso8601String(),
};

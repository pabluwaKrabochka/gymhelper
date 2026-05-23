// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      iconCode: (json['iconCode'] as num).toInt(),
      colorHex: json['colorHex'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconCode': instance.iconCode,
      'colorHex': instance.colorHex,
      'type': instance.type,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      name: json['name'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      goal: $enumDecode(_$UserGoalEnumMap, json['goal']),
      avatarPath: json['avatarPath'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
      'height': instance.height,
      'goal': _$UserGoalEnumMap[instance.goal]!,
      'avatarPath': instance.avatarPath,
    };

const _$UserGoalEnumMap = {
  UserGoal.loseWeight: 'loseWeight',
  UserGoal.maintain: 'maintain',
  UserGoal.gainWeight: 'gainWeight',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: (json['id'] as num?)?.toInt(),
  amount: (json['amount'] as num).toDouble(),
  timestamp: (json['timestamp'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  currency: json['currency'] as String,
  note: json['note'] as String?,
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'timestamp': instance.timestamp,
  'categoryId': instance.categoryId,
  'currency': instance.currency,
  'note': instance.note,
};

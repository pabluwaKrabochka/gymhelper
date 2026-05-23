import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_record_model.freezed.dart';
part 'weight_record_model.g.dart';

@freezed
class WeightRecordModel with _$WeightRecordModel {
  const factory WeightRecordModel({
    int? id,
    required double weight,
    required DateTime date,
  }) = _WeightRecordModel;

  factory WeightRecordModel.fromJson(Map<String, dynamic> json) => 
      _$WeightRecordModelFromJson(json);
}
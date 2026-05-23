import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/meal_record_model.dart';
import '../../../../data/models/weight_record_model.dart';
import '../../../../data/models/user_model.dart'; // Додали імпорт

part 'tracker_state.freezed.dart';

@freezed
class TrackerState with _$TrackerState {
  const factory TrackerState({
    required DateTime selectedDate,
    @Default([]) List<MealRecordModel> meals,
    @Default([]) List<WeightRecordModel> weightHistory,
    @Default(false) bool isLoading,
    UserModel? user, // Зберігаємо тут дані користувача
    String? errorMessage,
  }) = _TrackerState;
}
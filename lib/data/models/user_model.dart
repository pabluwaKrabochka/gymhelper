import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserGoal { loseWeight, maintain, gainWeight }

@freezed
class UserModel with _$UserModel {
  const UserModel._(); // Дозволяє додавати власні методи (гетери) у Freezed

  const factory UserModel({
    required String name,
    required double weight,
    required double height,
    required UserGoal goal,
    String? avatarPath,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // Розрахунок норми Білків
  int get dailyProteins {
    switch (goal) {
      case UserGoal.maintain: return (weight * 1.3).round(); // Легкий фітнес (1.2-1.4)
      case UserGoal.gainWeight: return (weight * 1.7).round(); // Силові для маси (1.6-1.8)
      case UserGoal.loseWeight: return (weight * 2.0).round(); // Сушка / інтенсив (1.8-2.2)
    }
  }

  // Розрахунок норми Жирів
 int get dailyFats {
    switch (goal) {
      case UserGoal.loseWeight: return (weight * 0.8).round();
      case UserGoal.maintain: return (weight * 1.0).round();
      case UserGoal.gainWeight: return (weight * 1.0).round();
    }
  }

  // Розрахунок норми Вуглеводів
int get dailyCarbs {
    switch (goal) {
      case UserGoal.loseWeight: return (weight * 2.0).round();
      case UserGoal.maintain: return (weight * 3.0).round();
      case UserGoal.gainWeight: return (weight * 4.0).round();
    }
  }
  // Розрахунок загальних Калорій
 int get dailyCalories {
    return (dailyProteins * 4) + (dailyFats * 9) + (dailyCarbs * 4);
  }
}
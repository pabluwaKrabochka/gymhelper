import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/profile/data/profile_repository.dart';
import '../../../../data/models/meal_record_model.dart';
import '../../../../data/models/weight_record_model.dart';
import '../../../../data/models/user_model.dart';
import '../../domain/tracker_repository.dart';

import 'tracker_state.dart';

class TrackerCubit extends Cubit<TrackerState> {
  final TrackerRepository _repository;
  final ProfileRepository _profileRepository;

  TrackerCubit(this._repository, this._profileRepository)
      : super(TrackerState(selectedDate: DateTime.now())) {
    _init();
  }

  void _init() {
    loadUserProfile();
    loadDailyData();
    loadWeightHistory();
  }

  // --- РОБОТА З ПРОФІЛЕМ ---
  void loadUserProfile() {
    final user = _profileRepository.getUser();
    emit(state.copyWith(user: user));
  }

  Future<void> saveUserProfile(UserModel user) async {
    await _profileRepository.saveUser(user);
    emit(state.copyWith(user: user));
  }

  // --- ПІДРАХУНОК МАКРОСІВ (КБЖВ) ЗА ДЕНЬ ---
  int get totalDailyCalories => state.meals.fold(0, (sum, item) => sum + item.calories);
  double get totalDailyProteins => state.meals.fold(0.0, (sum, item) => sum + item.proteins);
  double get totalDailyFats => state.meals.fold(0.0, (sum, item) => sum + item.fats);
  double get totalDailyCarbs => state.meals.fold(0.0, (sum, item) => sum + item.carbs);

  // --- РОБОТА З ЇЖЕЮ ---
  Future<void> loadDailyData({DateTime? date}) async {
    final targetDate = date ?? state.selectedDate;
    emit(state.copyWith(isLoading: true, selectedDate: targetDate, errorMessage: null));
    try {
      final dailyMeals = await _repository.getMealsForDate(targetDate);
      emit(state.copyWith(meals: dailyMeals, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void changeDate(DateTime newDate) {
    loadDailyData(date: newDate);
  }

  Future<void> addMealRecord({
    required String foodName,
    required int calories,
    required double proteins,
    required double fats,
    required double carbs,
    required MealType mealType,
  }) async {
    try {
      final newMeal = MealRecordModel(
        foodName: foodName,
        calories: calories,
        proteins: proteins,
        fats: fats,
        carbs: carbs,
        date: state.selectedDate,
        mealType: mealType,
      );
      await _repository.addMeal(newMeal);
      await loadDailyData();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateMealRecord({
    required int id,
    required String foodName,
    required int calories,
    required double proteins,
    required double fats,
    required double carbs,
    required MealType mealType,
    required DateTime date,
  }) async {
    try {
      final updatedMeal = MealRecordModel(
        id: id,
        foodName: foodName,
        calories: calories,
        proteins: proteins,
        fats: fats,
        carbs: carbs,
        date: date,
        mealType: mealType,
      );
      await _repository.updateMeal(updatedMeal);
      await loadDailyData();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteMealRecord(int id) async {
    try {
      await _repository.deleteMeal(id);
      await loadDailyData();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // --- РОБОТА З ВАГОЮ ---
  Future<void> loadWeightHistory() async {
    try {
      final history = await _repository.getWeightHistory();
      emit(state.copyWith(weightHistory: history));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> addWeightRecord(double weight) async {
    try {
      final newWeight = WeightRecordModel(weight: weight, date: DateTime.now());
      await _repository.addWeight(newWeight);
      await loadWeightHistory();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
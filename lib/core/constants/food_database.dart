import 'dart:convert';
import 'package:flutter/services.dart';

class FoodItemData {
  final String nameUk;
  final String nameEn;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  const FoodItemData({
    required this.nameUk,
    required this.nameEn,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  String getName(String langCode) => langCode == 'en' ? nameEn : nameUk;

  factory FoodItemData.fromJson(Map<String, dynamic> json) {
    return FoodItemData(
      nameUk: json['nameUk'] ?? '',
      nameEn: json['nameEn'] ?? '',
      calories: json['calories'] ?? 0,
      proteins: (json['proteins'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
    );
  }
}

// Глобальні змінні для зберігання завантаженої бази
List<FoodItemData> foodDatabase = [];
List<FoodItemData> drinkDatabase = [];
List<FoodItemData> addonDatabase = [];

// Цю функцію треба викликати в main.dart перед runApp()
Future<void> loadFoodDatabase() async {
  try {
    // Читаємо файл
    final String jsonString = await rootBundle.loadString('assets/foodnew.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Парсимо їжу
    if (jsonData['foods'] != null) {
      foodDatabase = (jsonData['foods'] as List).map((i) => FoodItemData.fromJson(i)).toList();
    }
    
    // Парсимо напої
    if (jsonData['drinks'] != null) {
      drinkDatabase = (jsonData['drinks'] as List).map((i) => FoodItemData.fromJson(i)).toList();
    }
    
    // Парсимо добавки
    if (jsonData['addons'] != null) {
      addonDatabase = (jsonData['addons'] as List).map((i) => FoodItemData.fromJson(i)).toList();
    }
    
    // ignore: avoid_print
    print('✅ Успішно завантажено: ${foodDatabase.length} страв, ${drinkDatabase.length} напоїв, ${addonDatabase.length} добавок.');
  } catch (e) {
    // ignore: avoid_print
    print('❌ Помилка завантаження бази даних їжі: $e');
  }
}
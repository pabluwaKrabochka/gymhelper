import '../../../data/models/meal_record_model.dart';
import '../../../data/models/weight_record_model.dart';
import '../../../data/services/storage/database_service.dart';
import '../domain/tracker_repository.dart';

class TrackerRepositoryImpl implements TrackerRepository {
  final DatabaseService _dbService;

  TrackerRepositoryImpl(this._dbService);

  @override
  Future<void> addMeal(MealRecordModel meal) async {
    final db = await _dbService.database;
    await db.insert('meals', {
      'foodName': meal.foodName,
      'calories': meal.calories,
      'proteins': meal.proteins, 
      'fats': meal.fats,         
      'carbs': meal.carbs,       
      'date': meal.date.toIso8601String(),
      'mealType': meal.mealType.name,
    });
  }

  @override
  Future<List<MealRecordModel>> getMealsForDate(DateTime date) async {
    final db = await _dbService.database;
    
    final startOfDay = DateTime(date.year, date.month, date.day).toIso8601String();
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'date DESC',
    );

    return maps.map((map) => MealRecordModel(
      id: map['id'] as int,
      foodName: map['foodName'] as String,
      calories: map['calories'] as int,
      proteins: map['proteins'] as double, 
      fats: map['fats'] as double,         
      carbs: map['carbs'] as double,       
      date: DateTime.parse(map['date'] as String),
      mealType: MealType.values.firstWhere((e) => e.name == map['mealType'] as String),
    )).toList();
  }

  @override
  Future<void> deleteMeal(int id) async {
    final db = await _dbService.database;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateMeal(MealRecordModel meal) async {
    final db = await _dbService.database;
    await db.update(
      'meals',
      {
        'foodName': meal.foodName,
        'calories': meal.calories,
        'proteins': meal.proteins, 
        'fats': meal.fats,         
        'carbs': meal.carbs,       
        'mealType': meal.mealType.name,
      },
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  @override
  Future<void> addWeight(WeightRecordModel weight) async {
    final db = await _dbService.database;
    await db.insert('weight_records', {
      'weight': weight.weight,
      'date': weight.date.toIso8601String(),
    });
  }

  @override
  Future<List<WeightRecordModel>> getWeightHistory() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'weight_records',
      orderBy: 'date ASC',
    );

    return maps.map((map) => WeightRecordModel(
      id: map['id'] as int,
      weight: map['weight'] as double,
      date: DateTime.parse(map['date'] as String),
    )).toList();
  }

  // --- ДОДАНО РЕАЛІЗАЦІЮ НОВИХ МЕТОДІВ ---

  @override
  Future<void> updateWeight(WeightRecordModel weight) async {
    final db = await _dbService.database;
    await db.update(
      'weight_records',
      {
        'weight': weight.weight,
        'date': weight.date.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [weight.id],
    );
  }

  @override
  Future<void> deleteWeight(int id) async {
    final db = await _dbService.database;
    await db.delete('weight_records', where: 'id = ?', whereArgs: [id]);
  }
}
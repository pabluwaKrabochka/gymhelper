import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_tracker_v2.db'); // Змінили назву файлу
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        foodName TEXT NOT NULL,
        calories INTEGER NOT NULL,
        proteins REAL NOT NULL,
        fats REAL NOT NULL,
        carbs REAL NOT NULL,
        date TEXT NOT NULL,
        mealType TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE weight_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }
}
// ФАЙЛ: lib/data/services/storage/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:iconsax_plus/iconsax_plus.dart'; // Імпортуємо нові іконки

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // Вмикаємо підтримку Foreign Keys для каскадного видалення
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        iconCode INTEGER NOT NULL,
        colorHex TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        timestamp INTEGER NOT NULL,
        categoryId INTEGER NOT NULL,
        currency TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
    
    // Додаємо стартові категорії з використанням IconsaxPlus
    await db.insert('categories', {
      'name': 'Продукти', 
      'iconCode': IconsaxPlusLinear.shopping_cart.codePoint, // Сучасна іконка кошика
      'colorHex': '0xFFEF4444', // Червоний колір (AppColors.expense)
      'type': 'expense'
    });
    
    await db.insert('categories', {
      'name': 'Зарплата', 
      'iconCode': IconsaxPlusLinear.money_2.codePoint, // Сучасна іконка грошей
      'colorHex': '0xFF10B981', // Зелений колір (AppColors.income)
      'type': 'income'
    });
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/product_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products (id INTEGER PRIMARY KEY, title TEXT, price REAL)",
        );
      },
    );
  }

  Future<void> insertProducts(List<Product> products) async {
    final db = await database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert('products', product.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}

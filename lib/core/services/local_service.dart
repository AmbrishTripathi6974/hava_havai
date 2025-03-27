import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/cart_model.dart';
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

  /// Insert or update cart item
  Future<void> upsertCartItem(CartItem item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all cart items
  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    return List.generate(maps.length, (i) => CartItem.fromJson(maps[i]));
  }

  /// Delete cart item
  Future<void> removeCartItem(String id) async {
    final db = await database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [id]);
  }

  /// Clear all cart items
  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }
}

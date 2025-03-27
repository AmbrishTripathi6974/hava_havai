import 'dart:isolate';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';

Future<void> cacheProducts(List<Product> newProducts) async {
  // Encode JSON in an isolate
  final encodedData = await Isolate.run(() => jsonEncode(newProducts.map((p) => p.toJson()).toList()));

  // Save on main thread
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("cached_products", encodedData);
}

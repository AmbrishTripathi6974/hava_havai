import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ProductRepository {
  final String baseUrl = "https://dummyjson.com/products";
  final String cacheKey = "cached_products";

  Future<List<Product>> fetchProducts(int page, int pageSize) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl?limit=$pageSize&skip=${page * pageSize}"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Product> products = (data["products"] as List).map((e) => Product.fromJson(e)).toList();

        // Cache products efficiently
        _cacheProducts(products);

        return products;
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      return await _getCachedProducts();
    }
  }

  /// 🚀 **Efficient Product Caching (Uses Isolate Only for Encoding)**
  Future<void> _cacheProducts(List<Product> newProducts) async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch existing products from SharedPreferences
    final cachedData = prefs.getString(cacheKey);
    List<Product> existingProducts = [];
    if (cachedData != null) {
      existingProducts = (jsonDecode(cachedData) as List).map((e) => Product.fromJson(e)).toList();
    }

    // Merge products without duplicates
    final updatedProducts = {...existingProducts, ...newProducts}.toList();

    // Encode JSON in an isolate
    final encodedData = await Isolate.run(() => jsonEncode(updatedProducts.map((p) => p.toJson()).toList()));

    // Store in SharedPreferences (Main Thread)
    await prefs.setString(cacheKey, encodedData);
  }

  /// ✅ **Retrieve Cached Products**
  Future<List<Product>> _getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      return (jsonDecode(cachedData) as List).map((e) => Product.fromJson(e)).toList();
    }
    return [];
  }
}

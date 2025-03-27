import 'package:flutter/material.dart';
import 'package:hava_havai/views/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hava_havai/app.dart';
import 'package:hava_havai/models/product_model.dart';

import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(ProductAdapter()); // Register adapter

  if (!Hive.isBoxOpen('product_cache')) {
    await Hive.openBox<Product>(
        'product_cache'); // ✅ Ensure the box is opened only once
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBinding(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen as first screen
        '/home': (context) => HomeScreen(), // Define Home Screen route
      },
    ));
  }
}

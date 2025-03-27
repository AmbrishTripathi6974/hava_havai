import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hava_havai/blocs/product/product_bloc.dart';
import 'package:hava_havai/repositories/product_repository.dart';
import 'package:hava_havai/views/home_screen.dart';
import 'package:hava_havai/blocs/cart/cart_bloc.dart';
import 'package:hava_havai/blocs/cart/cart_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ProductRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cartBloc = CartBloc();
              cartBloc.add(LoadCart()); // Loads cart initially
              return cartBloc;
            },
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

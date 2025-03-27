import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hava_havai/blocs/cart/cart_bloc.dart';
import 'package:hava_havai/blocs/cart/cart_event.dart';
import 'package:hava_havai/blocs/product/product_bloc.dart';
import 'package:hava_havai/repositories/product_repository.dart';

class AppBinding extends StatelessWidget {
  final Widget child;

  const AppBinding({super.key, required this.child});

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
              cartBloc.add(LoadCart()); // Load cart initially
              return cartBloc;
            },
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

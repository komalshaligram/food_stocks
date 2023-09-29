import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/basket/basket_bloc.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';

import '../utils/themes/app_colors.dart';

class BasketRoute {
  static Widget get route => const BasketScreen();
}

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BasketBloc(),
      child: const BasketScreenWidget(),
    );
  }
}


class BasketScreenWidget extends StatelessWidget {
  const BasketScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {
      },
      child: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: Center(child: Text('Basket Screen')),
          );
        },
      ),
    );
  }

}

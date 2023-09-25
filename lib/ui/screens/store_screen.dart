import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';

class StoreRoute {
  static Widget get route => const StoreScreen();
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoreScreenWidget();
  }
}


class StoreScreenWidget extends StatelessWidget {
  const StoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.isRedirected) {
          Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name);
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
                child: Text('Store Screen')
            ),
          );
        },
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';

class SplashRoute {
  static Widget get route => const SplashScreen();
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            return state.when(splashWidget,
                loaded: () {
              Navigator.pushNamed(context, RouteDefine.loginScreen.name);
                  return Container(color: Colors.amber,);
                },
                error: () => const Text('error is occured'),
                initial: splashWidget);
          },
        ),
      ),
    );

  }

  Widget splashWidget(){
    return Container(
      height: 100,
      width: 100,
      color: Colors.blue,
      child:  SvgPicture.asset(
          AppImagePath.splashLogo,
          width: 500,
          height: 500,
        )
    );
  }
}
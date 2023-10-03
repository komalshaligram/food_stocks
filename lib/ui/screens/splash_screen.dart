import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';


class SplashRoute {
  static Widget get route => const SplashScreen();
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashEvent.splashLoaded()),
      child: const SplashScreenWidget(),
    );
  }
}


class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state.isRedirected) {
          /* SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
          if(preferencesHelper.getUserLoggedIn()){
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name);
          }*/
          Navigator.pushNamed(context, RouteDefine.connectScreen.name);

        }


      },
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SvgPicture.asset(
                AppImagePath.splashLogo,
                height: getScreenHeight(context) * 0.12,
                width: getScreenWidth(context) * 0.47,
              ),
            ),
          );
        },
      ),
    );
  }

}

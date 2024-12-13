import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/splash/splash_bloc.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_img_path.dart';
import '../../ui/utils/themes/app_strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';

class SplashRoute {
  static Widget get route => const SplashScreen();
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => SplashBloc()
        ..add(SplashEvent.splashLoaded(
            pushNavigation: args?[AppStrings.pushNavigationString] ?? '')),
      child: const SplashScreenWidget(),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);


  void getVersion(SharedPreferencesHelper preferencesHelper) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    preferencesHelper.setAppVersion(version: version);
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state.isRedirected) {
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());
          getVersion(preferencesHelper);

          printData('${preferencesHelper.getUserLoggedIn()}');

          if (preferencesHelper.getUserLoggedIn()) {
            Navigator.pushReplacementNamed(
                context, RouteDefine.bottomNavScreen.name, arguments: {
              AppStrings.pushNavigationString: state.pushNavigation
            });
          } else {
            Navigator.pushReplacementNamed(
                context, RouteDefine.connectScreen.name);
          }
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: AnimatedOpacity(
                  curve: Curves.decelerate,
                  opacity: state.isAnimate ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: AnimatedScale(
                    curve: Curves.decelerate,
                    scale: state.isAnimate ? 1 : 1.2,
                    duration: const Duration(milliseconds: 600),
                    child: SvgPicture.asset(
                      AppImagePath.splashLogo,
                      height: getScreenHeight(context) * 0.30,
                      width: getScreenWidth(context) * 0.65,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
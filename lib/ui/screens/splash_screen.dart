import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
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
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashEvent.splashLoaded()),
      child: const SplashScreenWidget(),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  getVersion(SharedPreferencesHelper preferencesHelper) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    debugPrint("package info : ${packageInfo.toString()}");
    String version = packageInfo.version;
    preferencesHelper.setAppVersion(version: version);
    debugPrint("splash pref = ${preferencesHelper.getUserLoggedIn()}");
  }

  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.id}');
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state.isRedirected) {
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());
          getVersion(preferencesHelper);
          getDeviceId();
          print(preferencesHelper.getUserLoggedIn());
          if (preferencesHelper.getUserLoggedIn()) {
            Navigator.pushReplacementNamed(
                context, RouteDefine.bottomNavScreen.name);
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
                child: SvgPicture.asset(
                  AppImagePath.splashLogo,
                  height: getScreenHeight(context) * 0.12,
                  width: getScreenWidth(context) * 0.47,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

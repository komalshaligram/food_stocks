import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
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
    debugPrint('splash args = $args');
    return BlocProvider(
      create: (context) => SplashBloc()
        ..add(SplashEvent.splashLoaded(
            pushNavigation: args?[AppStrings.pushNavigationString] ?? '')),
      child: SplashScreenWidget(),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  SplashScreenWidget({Key? key}) : super(key: key);

  String? deviceId;

  getVersion(SharedPreferencesHelper preferencesHelper) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    debugPrint("package info : ${packageInfo.toString()}");
    String version = packageInfo.version;
    preferencesHelper.setAppVersion(version: version);
    debugPrint("splash pref = ${preferencesHelper.getUserLoggedIn()}");
  }

  getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      debugPrint('deviceId:$deviceId');
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    return deviceId;
  }

void appFlyerSetup() {
    AppsflyerSdk? _appsflyerSdk;
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: dotenv.env["DEV_KEY"] ?? '',
        showDebug: true,
        appId: Platform.isAndroid?'com.foodstock.dev':'id6468264054',
        timeToWaitForATTUserAuthorization: 15);
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: false);
    _appsflyerSdk.onAppOpenAttribution((res) {
      debugPrint("onAppOpenAttribution res: " + res.toString());
      return _appsflyerSdk?.logEvent('App Open', res);
    });
    _appsflyerSdk.onInstallConversionData((res) {
      debugPrint("onInstallConversionData res: " + res.toString());
      return _appsflyerSdk?.logEvent('App Install', res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if(Platform.isAndroid){
        //  appFlyerSetup();
        }
        if (state.isRedirected) {
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());
          getVersion(preferencesHelper);
          getDeviceId();

          debugPrint('${preferencesHelper.getUserLoggedIn()}');
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
                  duration: Duration(milliseconds: 1000),
                  child: AnimatedScale(
                    curve: Curves.decelerate,
                    scale: state.isAnimate ? 1 : 1.2,
                    duration: Duration(milliseconds: 600),
                    child: SvgPicture.asset(
                      AppImagePath.splashLogo,
                      height: getScreenHeight(context) * 0.12,
                      width: getScreenWidth(context) * 0.47,
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

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
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashEvent.splashLoaded()),
      child:  SplashScreenWidget(),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {

   SplashScreenWidget({Key? key}) : super(key: key);

   String? deviceId;

  getVersion(SharedPreferencesHelper preferencesHelper) async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    debugPrint("package info : ${packageInfo.toString()}");
    String version = packageInfo.version;
    preferencesHelper.setAppVersion(version: version);
    debugPrint("splash pref = ${preferencesHelper.getUserLoggedIn()}");
  }


   getDeviceId() async {
    try {
       deviceId = await PlatformDeviceId.getDeviceId;
       print('deviceId:$deviceId');
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    return deviceId;
  }

  void appFlyerSetup(){
    AppsflyerSdk? _appsflyerSdk;
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: dotenv.env["DEV_KEY"]??'',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15);
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.initSdk(registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: false);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      return _appsflyerSdk?.logEvent('App Open', res);
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      return _appsflyerSdk?.logEvent('App Install', res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        appFlyerSetup();
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


//eti3Gz3RRYuUgZVbNrqt5z:APA91bH29l6pxfxQtwh9l3xTQtoCcXhROpI1zX-1oSb3W2QOFW-RycCY63dMS1l41e-dUHG2J4Xmr2FRIL1TR6WvT6uu6vgd9xiyyIgaUuE8p81kOr9zySa5OwJUjeKdFBigKQVkiSq-
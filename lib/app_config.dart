import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  final String flavor;
  final String appName;
  final String appBaseUrl;
  final Color primaryColor;

  AppConfig(
      {required this.flavor,
      required this.appName,
      required this.appBaseUrl,
      required this.primaryColor});

  factory AppConfig.dev() {
    return AppConfig(
        flavor: 'dev',
        appName: 'Tavili Dev',
        appBaseUrl: 'https://devapi.foodstock.shtibel.com/api',
        primaryColor: Colors.blue);
  }

  factory AppConfig.stag() {
    return AppConfig(
        flavor: 'prod',
        appName: 'Tavili',
        appBaseUrl: 'https://api.foodstock.shtibel.com/api',
        primaryColor: Colors.red);
  }


  static Future<void> initializeAppConfig(BuildContext context) async {
    final String? flavor =
        await const MethodChannel('flavor').invokeMethod<String>('getFlavor');
    switch (flavor) {
      case 'dev':
        AppConfigManager.setAppConfig(AppConfig.dev());
        break;
      case 'prod':
        AppConfigManager.setAppConfig(AppConfig.stag());
        break;

      default:
        AppConfigManager.setAppConfig(AppConfig.dev());
        break;
    }
    (context as Element).markNeedsBuild();

    debugPrint('STARTED WITH FLAVOR ${AppConfigManager.appConfig!.flavor}');
  }
//
 static Future<String> getAppUrl() async {
   final String? flavor =
       await const MethodChannel('flavor').invokeMethod<String>('getFlavor');
   switch (flavor) {
     case 'dev':
       return AppConfig.dev().appBaseUrl;
     case 'prod':
       return AppConfig.stag().appBaseUrl;

     default:
       return AppConfig.dev().appBaseUrl;
   }
 }
}

class AppConfigManager {
  static AppConfig? _appConfig;

  static AppConfig? get appConfig {
    return _appConfig;
  }

  static void setAppConfig(AppConfig appConfig) {
    _appConfig = appConfig;
  }
}

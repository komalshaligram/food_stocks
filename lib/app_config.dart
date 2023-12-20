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
        appName: 'Food Stock Dev',
        appBaseUrl: 'http://192.168.1.46:8080/api',
        primaryColor: Colors.blue);
  }

  factory AppConfig.stag() {
    return AppConfig(
        flavor: 'stag',
        appName: 'Food Stock Stag',
        appBaseUrl: 'http://192.168.1.46:3000/api',
        primaryColor: Colors.red);
  }

  factory AppConfig.prod() {
    return AppConfig(
        flavor: 'prod',
        appName: 'Food Stock',
        appBaseUrl: 'http://182.70.118.201:3000/api',
        primaryColor: Colors.green);
  }

  static Future<void> initializeAppConfig(BuildContext context) async {
    final String? flavor =
        await const MethodChannel('flavor').invokeMethod<String>('getFlavor');
    switch (flavor) {
      case 'dev':
        AppConfigManager.setAppConfig(AppConfig.dev());
        break;
      case 'stag':
        AppConfigManager.setAppConfig(AppConfig.stag());
        break;
      case 'prod':
        AppConfigManager.setAppConfig(AppConfig.prod());
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
     case 'stag':
       return AppConfig.stag().appBaseUrl;
     case 'prod':
       return AppConfig.prod().appBaseUrl;
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

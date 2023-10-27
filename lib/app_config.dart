import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  final String flavor;
  final String appName;
  final Color primaryColor;

  AppConfig(
      {required this.flavor,
      required this.appName,
      required this.primaryColor});

  factory AppConfig.dev() {
    return AppConfig(
        flavor: 'dev', appName: 'Food Stock Dev', primaryColor: Colors.blue);
  }

  factory AppConfig.stag() {
    return AppConfig(
        flavor: 'stag', appName: 'Food Stock', primaryColor: Colors.green);
  }

  factory AppConfig.prod() {
    return AppConfig(
        flavor: 'prod', appName: 'Food Stock Prod', primaryColor: Colors.red);
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

    print('STARTED WITH FLAVOR ${AppConfigManager.appConfig!.flavor}');
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

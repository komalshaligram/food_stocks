import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_stock/data/model/app_config.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/env_config.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/screens/my_app_screen.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //await dotenv.load(fileName: ".env");
    AppConfig productionAppConfig = EnvironmentConfig().devAppConfig;
    Widget app = await initializeApp(productionAppConfig);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Firebase.initializeApp();
    await PushNotificationService().setupInteractedMessage();
    DioClient.baseUrl = EnvironmentConfig().devAppConfig.baseUrl;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SharedPreferencesHelper preferencesHelper =
    SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    if (!preferencesHelper.getUserLoggedIn()) {
      await Permission.notification.isDenied.then((isPermissionDenied) async {
        if (isPermissionDenied) {
          await Permission.notification.request();
        }
      });
    }
    runApp(app);
  },
          (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));

}

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/ui/screens/my_app_screen.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';


final shorebirdCodePush = ShorebirdCodePush();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await PushNotificationService().setupInteractedMessage();
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
    runApp(
       MyApp(appName: 'TAVILI'),
    );
  },
          (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}








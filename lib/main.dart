import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/screens/my_app_screen.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/push_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  printData("__________BackgroundHandler______");
    await Firebase.initializeApp();
    printData("Handling in main${message.toString()}");
    printData("Handling a background message:${message.messageId}");
    printData("Handling a background message:${message.data.toString()}");
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await PushNotificationService().setupInteractedMessage();
    await dotenv.load(fileName: '.env');
    if (Platform.isAndroid) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
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

    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}
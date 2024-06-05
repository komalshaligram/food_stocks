import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/ui/screens/my_app_screen.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("__________BackgroundHandler______");
    await Firebase.initializeApp();
    debugPrint("Handling in main${message.toString()}");
    debugPrint("Handling a background message:${message.messageId}");
    debugPrint("Handling a background message:${message.data.toString()}");
    var data = json.decode(message.data['data'].toString());

    FlutterAppBadger.updateBadgeCount(PushNotificationService().notificationCount+1);
    if(data!=null){
      debugPrint('notifrom main');
    /*  PushNotificationService().showNotification(
          notiId: message.notification.hashCode,
          androidIcon:message.notification?.android?.smallIcon,
          data: data,
          isNavigate: true,
          showNotification: true,
          isAppOpen: true
      );*/
  }
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await PushNotificationService().setupInteractedMessage();
    await dotenv.load(fileName: '.env');
    if(Platform.isAndroid){
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
    runApp(MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}
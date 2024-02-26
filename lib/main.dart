import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:food_stock/data/services/my_behavior.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/services/locale_provider.dart';
import 'app_config.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

final shorebirdCodePush = ShorebirdCodePush();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseMessaging.
    instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      FlutterAppBadger.removeBadge();
      debugPrint("onMessageOpenedApp: $message");

      debugPrint('notification payload:1 ${message.notification}');
      //Map valueMap = (message.data);

    });
    /*FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // DO YOUR THING HERE
        debugPrint("onMessageOpenedApp: $message");
        debugPrint('notification payload:1 ${message.notification}');
      }
    });*/
    await PushNotificationService().setupInteractedMessage();
    //await dotenv.load(fileName: ".env");
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
      const MyApp(),
    );
  },
          (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}


@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message:${message.messageId}");
  debugPrint("Handling a background message:${message.data.toString()}");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppConfig.initializeAppConfig(context);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider()..setAppLocale(),
      builder: (context, child) {
        return MaterialApp(
          key: scaffoldKey,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: Provider.of<LocaleProvider>(context).locale,
          title: AppConfigManager.appConfig?.appName ?? AppStrings.appName,
          initialRoute: RouteDefine.splashScreen.name,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.mainColor,
              selectionColor: AppColors.mainColor,
              selectionHandleColor: Colors.transparent,
            ),
            primarySwatch: Colors.green,
            canvasColor: Colors.white,
            cardColor: AppColors.whiteColor,
            snackBarTheme: SnackBarThemeData(
              backgroundColor: AppColors.mainColor,
              actionTextColor: AppColors.textColor,
            ),
          ),
          scrollBehavior: MyBehavior(),
          onGenerateRoute: AppRouting.generateRoute,
        );
      },
    );
  }
}
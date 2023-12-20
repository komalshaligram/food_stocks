import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await PushNotificationService().setupInteractedMessage();
    await dotenv.load(fileName: ".env");
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const MyApp(),
        ),
      ),
    );
  },
          (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
      LocaleProvider()
        ..setAppLocale(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Provider
              .of<LocaleProvider>(context)
              .locale,
          title: AppConfigManager.appConfig?.appName ?? AppStrings.appName,
          initialRoute: RouteDefine.splashScreen.name,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            cardColor: AppColors.whiteColor,
            primarySwatch: Colors.green,
          ),
          scrollBehavior: MyBehavior(),
          onGenerateRoute: AppRouting.generateRoute,
        );
      },
    );
  }
}

/*

{
"senderId": null,
"category": null,
"collapseKey": "com.foodstock.dev",
"contentAvailable": false,
"data": {
"data":
{
"_id":"657c51518991f43ea806ecdc",
"messageId":"657c200b244c4ecdb8dd902d",
"type":"messages",
"userId":"6565c6845a62a2165f00b085",
"isRead":false,
"isSuccess":false,
"message":{
"title":"Sale Sale Sale",
"body":"<p><strong>Sale Body</strong></p>",
"imageUrl":"","link":"undefined/undefined"
}
}
},
"from": "229653257750",
"messageId": "0:1702646110700210%7dcf6cf27dcf6cf2",
"messageType": null,
"mutableContent": false,
"notification":{
"title": "Sale Sale Sale",
"titleLocArgs": [],
"titleLocKey": null,
"body":" <p><strong>Sale Body</strong></p>",
"bodyLocArgs": [],
"bodyLocKey": null,
"android": {
"channelId": null,
"clickAction": null,
"color": null,
"count": null,
"imageUrl": null,
"link": null,
"priority": 0,
"smallIcon": null,
"sound": null,
"ticker": null,
"tag": null,
"visibility": 0
},
"apple": null,
"web": null
},
"sentTime": "1702646110690",
"threadId": null,
"ttl": "2419200"
}*/

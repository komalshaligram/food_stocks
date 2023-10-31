import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_stock/data/services/my_behavior.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';
import 'data/services/locale_provider.dart';
import 'app_config.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await PushNotificationService().setupInteractedMessage();
    await dotenv.load(fileName: ".env");
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
      AppConfig.initializeAppConfig(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider()..setAppLocale(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Provider.of<LocaleProvider>(context).locale,
          title: AppStrings.appName,
          initialRoute: RouteDefine.splashScreen.name,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            primarySwatch: Colors.blue,
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

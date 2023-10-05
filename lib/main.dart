import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/more_details/more_details_bloc.dart';
import 'package:food_stock/data/services/my_behavior.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';
import 'data/services/locale_provider.dart';



Language selectedLang = Language.Hebrew;


void main() async {
/*  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();*/

/*  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;*/

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MoreDetailsBloc()..add(MoreDetailsEvent.addFilterListEvent()),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const MyApp(),
        ),
      ),
    ),
  );
/*  runZonedGuarded<Future<void>>(() async {

  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));*/
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

*//*  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };*//*
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MoreDetailsBloc()..add(MoreDetailsEvent.addFilterListEvent()),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const MyApp(),
        ),
      ),
    ),
  );
}*/


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider()..setAppLocale(Locale('he')),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: provider.locale,
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
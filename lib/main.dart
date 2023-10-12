import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/more_details/more_details_bloc.dart';
import 'package:food_stock/data/services/my_behavior.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';
import 'data/services/locale_provider.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await PushNotificationService().setupInteractedMessage();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MoreDetailsBloc()..add(MoreDetailsEvent.addFilterListEvent()),
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
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider()..setAppLocale(Locale('en')),
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

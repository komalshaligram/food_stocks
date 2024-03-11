
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/my_app/my_app_bloc.dart';
import 'package:food_stock/data/model/app_config.dart';
import 'package:food_stock/data/services/my_behavior.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';
import '../../env_config.dart';
import '../../data/services/locale_provider.dart';
import '../../main.dart';

Future<Widget> initializeApp(AppConfig appConfig) async {
  await _init(appConfig);
  return MyApp(appName: appConfig.appName);
}

_init(AppConfig appConfig) async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  });
}

class MyApp extends StatelessWidget {
  final String appName;
  MyApp({required this.appName,super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAppBloc(),
      child: MyAppWidget(appName),
    );
  }
}

class MyAppWidget extends StatefulWidget {
  final String appName;
  const MyAppWidget(this.appName, {super.key});

  @override
  State<MyAppWidget> createState() => _MyAppWidgetState();
}

class _MyAppWidgetState extends State<MyAppWidget> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      context.read<MyAppBloc>().add(MyAppEvent.updateProfileDetailsEvent(context: context));
    }
    super.didChangeAppLifecycleState(state);
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
          title: widget.appName,
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
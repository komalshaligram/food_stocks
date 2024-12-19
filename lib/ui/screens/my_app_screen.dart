import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import '../../bloc/my_app/my_app_bloc.dart';
import '../../data/services/my_behavior.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';
import '../../app_config.dart';

import '../../data/services/locale_provider.dart';
import '../../main.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAppBloc(),
      child: const MyAppWidget(),
    );
  }
}

class MyAppWidget extends StatefulWidget {
  const MyAppWidget({super.key});

  @override
  State<MyAppWidget> createState() => _MyAppWidgetState();
}

class _MyAppWidgetState extends State<MyAppWidget> with WidgetsBindingObserver{
  final Smartlook smartLook = Smartlook.instance;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppConfig.initializeAppConfig(context);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    });
    WidgetsBinding.instance.addObserver(this);
   smartLook.start();
   smartLook.preferences.setProjectKey(dotenv.env['SMART_LOOK_KEY']!);
    //smartLook.log.enableLogging();
    smartLook.sensitivity.changeWidgetClassSensitivity(
      classType: TextField,
      isSensitive: false,
    );
    smartLook.sensitivity.changeWidgetClassSensitivity(
      classType: TextFormField,
      isSensitive: false,
    );
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
        return SmartlookRecordingWidget(
          child: MaterialApp(
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
                  selectionHandleColor:AppColors.mainColor,
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
            ),
        );
      },
    );
  }
}
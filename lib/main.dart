import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/profile/profile_bloc.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';

import 'package:food_stock/ui/utils/themes/app_colors.dart';


import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/file_upload/file_upload_bloc.dart';
import 'bloc/profile3/profile3_bloc.dart';

Language selectedLang = Language.Hebrew;


void main() =>
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SplashBloc(),
          ),
          BlocProvider(
            create: (context) => FileUploadBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
          BlocProvider(
            create: (context) => Profile3Bloc(),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(selectedLang.toString());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('he'),
      title: 'Food Stock',
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

      onGenerateRoute: AppRouting.generateRoute,
    );
  }
}
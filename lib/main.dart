

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/splash/splash_bloc.dart';

import 'package:food_stock/routes/app_routes.dart';

import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

GetIt getIt = GetIt.instance;



void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) => SplashBloc()..add(SplashEvent.splashLoaded()),
          child: const MyApp(),
        )),
  ),
);



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('he'),
      title: 'Food Stock',
      initialRoute: RouteDefine.splashScreen.name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppRouting.generateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('he'), // Hebrew
      ],
    );
  }
}
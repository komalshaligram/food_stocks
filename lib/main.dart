import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'bloc/file_upload/file_upload_bloc.dart';
import 'data/services/locale_provider.dart';
Language selectedLang = Language.Hebrew;

//
// void main() =>
//     runApp(
//       MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => SplashBloc(),
//           ),
//           BlocProvider(
//             create: (context) => FileUploadBloc(),
//           ),
//           BlocProvider(
//             create: (context) => ProfileBloc(),
//           ),
//           BlocProvider(
//             create: (context) => Profile3Bloc(),
//           ),
//           BlocProvider(
//             create: (context) => OperationTimeBloc(),
//           ),
//
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: Directionality(
//             textDirection: TextDirection.rtl,
//               child: const MyApp(),
//           ),
//         ),
//       ),
//     );
void main() => runApp(
  MultiBlocProvider(
    providers: [
    BlocProvider(
      create: (context) => FileUploadBloc(),
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider()..setAppLocale(Locale('he')),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: provider.locale,
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
      },
    );
  }
}
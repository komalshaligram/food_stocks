import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/my_app/my_app_bloc.dart';
import '../../data/services/my_behavior.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../app_config.dart';
import '../../data/services/deep_link_launch_coordinator.dart';
import '../../data/services/locale_provider.dart';
import '../../data/services/startup_navigation.dart';
import '../../main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MyAppBloc(), child: const MyAppWidget());
  }
}

class MyAppWidget extends StatefulWidget {
  const MyAppWidget({super.key});

  @override
  State<MyAppWidget> createState() => _MyAppWidgetState();
}

class _MyAppWidgetState extends State<MyAppWidget> with WidgetsBindingObserver {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _deepLinkSub;
  String? _lastHandledDeepLink;
  bool _isHandlingDeepLink = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    });

    WidgetsBinding.instance.addObserver(this);

    _initDeepLinks();

    super.initState();
  }

  /// Sets up handling for incoming App Links / Universal Links
  /// (https://tiny.tavili.net/openApp).
  Future<void> _initDeepLinks() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _scheduleDeepLink(initialUri);
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'getInitialLink failed');
    }

    _deepLinkSub = _appLinks.uriLinkStream.listen(
      _scheduleDeepLink,
      onError: (Object e, StackTrace s) {
        FirebaseCrashlytics.instance.recordError(e, s, reason: 'uriLinkStream error');
      },
    );
  }

  void _scheduleDeepLink(Uri uri) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_handleDeepLink(uri, attempt: 0));
    });
  }

  String? _currentRouteName() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return null;
    }

    Route<dynamic>? currentRoute;
    navigator.popUntil((route) {
      currentRoute = route;
      return true;
    });
    return currentRoute?.settings.name;
  }

  /// Cold start (still on splash): record the link and let splash navigate once.
  /// Warm start (past splash): navigate immediately.
  /// When route name is null the stack may be mid-transition — retry.
  Future<void> _handleDeepLink(Uri uri, {int attempt = 0}) async {
    if (!DeepLinkLaunchCoordinator.isOpenAppLink(uri)) {
      return;
    }

    final linkKey = uri.toString();
    if (_isHandlingDeepLink || _lastHandledDeepLink == linkKey) {
      return;
    }

    final routeName = _currentRouteName();
    if (routeName == null) {
      if (attempt < 30) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            unawaited(_handleDeepLink(uri, attempt: attempt + 1));
          }
        });
      }
      return;
    }

    if (DeepLinkLaunchCoordinator.isSplashRoute(routeName)) {
      DeepLinkLaunchCoordinator.markOpenedFromDeepLink();
      _lastHandledDeepLink = linkKey;
      return;
    }

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      if (attempt < 20) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            unawaited(_handleDeepLink(uri, attempt: attempt + 1));
          }
        });
      }
      return;
    }

    if (!navigator.mounted) {
      return;
    }

    _isHandlingDeepLink = true;
    try {
      await StartupNavigation.replaceWithStartupRoute();
      _lastHandledDeepLink = linkKey;
    } finally {
      _isHandlingDeepLink = false;
    }
  }

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<MyAppBloc>().add(MyAppEvent.updateProfileDetailsEvent(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider()..setAppLocale(),
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            locale: Provider.of<LocaleProvider>(context).locale,
            title: AppConfigManager.appConfig?.appName ?? AppStrings.appName,
            initialRoute: RouteDefine.splashScreen.name,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (final supported in supportedLocales) {
                  if (supported.languageCode == locale.languageCode) {
                    return supported;
                  }
                }
              }
              return supportedLocales.first;
            },
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.mainColor, selectionColor: AppColors.mainColor, selectionHandleColor: AppColors.mainColor),
              primarySwatch: Colors.green,
              canvasColor: Colors.white,
              cardColor: AppColors.whiteColor,
              scaffoldBackgroundColor: AppColors.pageColor,
              snackBarTheme: SnackBarThemeData(backgroundColor: AppColors.mainColor, actionTextColor: AppColors.textColor),
            ),
            scrollBehavior: MyBehavior(),
            onGenerateRoute: AppRouting.generateRoute,
          );
        });
  }
}

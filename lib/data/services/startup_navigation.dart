import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';

class StartupNavigation {
  StartupNavigation._();

  static bool _isNavigating = false;

  static Future<String> resolveStartupRoute() async {
    final preferences = SharedPreferencesHelper(
      prefs: await SharedPreferences.getInstance(),
    );
    return preferences.getUserLoggedIn()
        ? RouteDefine.bottomNavScreen.name
        : RouteDefine.connectScreen.name;
  }

  static Future<void> replaceWithStartupRoute({
    BuildContext? context,
    Map<String, dynamic>? arguments,
  }) async {
    if (_isNavigating) {
      return;
    }

    _isNavigating = true;
    try {
      final routeName = await resolveStartupRoute();
      final navigator = navigatorKey.currentState;

      if (navigator != null && navigator.mounted) {
        navigator.pushNamedAndRemoveUntil(
          routeName,
          (_) => false,
          arguments: arguments,
        );
        return;
      }

      if (context != null && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          routeName,
          (_) => false,
          arguments: arguments,
        );
      }
    } finally {
      _isNavigating = false;
    }
  }
}

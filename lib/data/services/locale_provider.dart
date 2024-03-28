import 'package:flutter/material.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> setAppLocale({Locale? locale}) async {
    SharedPreferencesHelper preferencesHelper =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    if (locale == null) {
      String appLang = preferencesHelper.getAppLanguage();
      locale = Locale(appLang);
    }
    _locale = locale;
    debugPrint('lang ${locale.languageCode}');
    await preferencesHelper.setAppLanguage(languageCode: locale.languageCode);
    notifyListeners();
  }
}
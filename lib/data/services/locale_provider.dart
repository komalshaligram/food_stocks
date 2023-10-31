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
    preferencesHelper.setAppLanguage(languageCode: locale.languageCode);
    notifyListeners();
  }

  // void changeLocaleSettings(Locale newLocale) async {
  //   if(newLocale == Locale('en')) {
  //     _locale = Locale('en');
  //   } else if(newLocale==Locale('he')){
  //     _locale = Locale('he');
  //   }
  //    SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  //   preferencesHelper.setAppLanguage(language: language)
  //   // SharedPreferences prefs = ;
  //   // await prefs.setString("code", _locale?.countryCode??"en");
  //   notifyListeners();
  // }
  //
  // Future getLocaleFromSettings() async {
  //   SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  //   String code = preferencesHelper.getAppLanguage();
  //   Locale newLocale = Locale(code);
  //   if(newLocale == Locale('en')) {
  //     _locale = Locale('en');
  //   } else if(newLocale==Locale('he')){
  //     _locale = Locale('he');
  //   }
  // }

}
import 'package:flutter/material.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale = const Locale(AppStrings.hebrewString);
  Locale? get locale => _locale;

  static String _normalizeLanguageCode(String languageCode) {
    final code = languageCode.toLowerCase();
    if (code == AppStrings.englishString || code.startsWith('en')) {
      return AppStrings.englishString;
    }
    if (code == AppStrings.hebrewString || code.startsWith('he')) {
      return AppStrings.hebrewString;
    }
    return AppStrings.hebrewString;
  }

  Future<void> setAppLocale({Locale? locale}) async {
    SharedPreferencesHelper preferences =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    final languageCode = _normalizeLanguageCode(
      locale?.languageCode ?? preferences.getAppLanguage(),
    );
    _locale = Locale(languageCode);
    debugPrint('lang $languageCode');
    await preferences.setAppLanguage(languageCode: languageCode);
    notifyListeners();
  }
}

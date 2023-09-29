import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String lang = "lang";
  static const String userLoggedIn = "LOGGED_IN";

  final SharedPreferences prefs;

  SharedPreferencesHelper({required this.prefs});

  Future<void> setAppLanguage({required String languageCode}) async {
    await prefs.setString(lang, languageCode);
  }

  String getAppLanguage() {
    return prefs.getString(lang) ?? 'he';
  }

  Future<void> setUserLoggedIn({bool isLoggedIn = false}) async {
    await prefs.setBool(userLoggedIn, isLoggedIn);
  }

  bool getUserLoggedIn() {
    return prefs.getBool(userLoggedIn) ?? false;
  }
}

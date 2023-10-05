import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String lang = "lang";
  static const String userLoggedIn = "LOGGED_IN";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";

  final SharedPreferences prefs;

  SharedPreferencesHelper({required this.prefs});

  Future<void> setAppLanguage({required String languageCode}) async {
    await prefs.setString(lang, languageCode);
  }

  String getAppLanguage() {
    return prefs.getString(lang) ?? 'he';
  }

  Future<void> setUserLoggedIn({bool isLoggedIn = false}) async {
    if (!isLoggedIn) {
      await prefs.remove(accessToken);
      await prefs.remove(refreshToken);
    }
    await prefs.setBool(userLoggedIn, isLoggedIn);
  }

  bool getUserLoggedIn() {
    return prefs.getBool(userLoggedIn) ?? false;
  }

  Future<void> setAuthToken({required String accToken}) async {
    await prefs.setString(accessToken, accToken);
  }

  Future<void> setRefreshToken({required String refToken}) async {
    await prefs.setString(refreshToken, refToken);
  }

  String getAuthToken() {
    return prefs.getString(accessToken) ?? '';
  }

  String getRefreshToken() {
    return prefs.getString(refreshToken) ?? '';
  }
}

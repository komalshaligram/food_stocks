import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String lang = "lang";
  static const String userLoggedIn = "LOGGED_IN";
    String authToken = "authToken";
    String refToken = "refreshToken";


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

  Future<void> setAuthToken({required String accessToken}) async {
    await prefs.setString(authToken, accessToken);
  }
  Future<void> setRefreshToken({required String refreshToken}) async {
    await prefs.setString(refToken, refreshToken);
  }


  String getAuthToken() {
    return prefs.getString(authToken) ?? '';
  }

  String getRefreshToken() {
    return prefs.getString(refToken) ?? '';
  }


}

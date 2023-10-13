import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String lang = "lang";
  static const String userLoggedIn = "loggedIn";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";
  static const String userId = "userId";
  static const String userName = "userName";
  static const String userImage = "userImage";
  static const String userCompanyLogo = "companyLogo";
  static const String appVersion = 'appVersion';
  static const String fcmToken = 'fcmToken';

  final SharedPreferences prefs;

  SharedPreferencesHelper({required this.prefs});

  Future<void> setAppLanguage({required String languageCode}) async {
    await prefs.setString(lang, languageCode);
  }

  Future<void> setUserLoggedIn({bool isLoggedIn = false}) async {
    if (!isLoggedIn) {
      await prefs.remove(accessToken);
      await prefs.remove(refreshToken);
      await prefs.remove(userId);
      await prefs.remove(userName);
      await prefs.remove(userImage);
      await prefs.remove(userCompanyLogo);
    }
    await prefs.setBool(userLoggedIn, isLoggedIn);
  }

  Future<void> setAuthToken({required String accToken}) async {
    await prefs.setString(accessToken, accToken);
  }

  Future<void> setRefreshToken({required String refToken}) async {
    await prefs.setString(refreshToken, refToken);
  }

  Future<void> setUserId({required String id}) async {
    await prefs.setString(userId, id);
  }

  Future<void> setAppVersion({required String version}) async {
    await prefs.setString(appVersion, version);
  }

  Future<void> setFCMToken({required String fcmToken}) async {
    await prefs.setString(fcmToken, fcmToken);
  }

  Future<void> setUserName({required String name}) async {
    await prefs.setString(userName, name);
  }

  Future<void> setUserImageUrl({required String imageUrl}) async {
    await prefs.setString(userImage, imageUrl);
  }

  Future<void> setUserCompanyLogoUrl({required String logoUrl}) async {
    await prefs.setString(userCompanyLogo, logoUrl);
  }

  String getAppLanguage() {
    return prefs.getString(lang) ?? 'he';
  }

  bool getUserLoggedIn() {
    return prefs.getBool(userLoggedIn) ?? false;
  }

  String getAuthToken() {
    return prefs.getString(accessToken) ?? '';
  }
  String getFCMToken() {
    return prefs.getString(fcmToken) ?? '';
  }


  String getRefreshToken() {
    return prefs.getString(refreshToken) ?? '';
  }

  String getUserId() {
    return prefs.getString(userId) ?? '';
  }

  String getAppVersion(){
    return prefs.getString(appVersion)??'1.0.0';
  }

  String getUserName() {
    return prefs.getString(userName) ?? '';
  }

  String getUserImageUrl() {
    return prefs.getString(userImage) ?? '';
  }

  String getUserCompanyLogoUrl() {
    return prefs.getString(userCompanyLogo) ?? '';
  }
}

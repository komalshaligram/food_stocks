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
  static const String userCartCount = "cartCount";
  static const String userMessageCount = "messageCount";
  static const String appVersion = 'appVersion';
  static const String fcmToken = 'fcmToken';
  static const String userCartId = 'userCartId';
  static const String phoneNumber = 'phoneNumber';
  static const String walletId = 'walletId';
  static const String userCartProducts = 'userCartProducts';
  static const String userCartProductIds = 'userCartProductIds';

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
      await prefs.remove(userCartCount);
      await prefs.remove(userMessageCount);
      await prefs.remove(phoneNumber);
      await prefs.remove(userCartId);
      await prefs.remove(walletId);
      await prefs.remove(lang);
      await prefs.remove(userLoggedIn);
      await prefs.remove(appVersion);
      await prefs.remove(userCartProductIds);
      await prefs.remove(userCartProducts);
      await prefs.remove(fcmToken);
    }
    await prefs.setBool(userLoggedIn, isLoggedIn);
  }

  Future<void> removeProfileImage() async {
    await prefs.remove(userImage);
  }

  Future<void> removeCompanyLogo() async {
    await prefs.remove(userCompanyLogo);
  }
  Future<void> removeAuthToken() async {
    await prefs.remove(accessToken);
  }
  Future<void> removeRefreshToken() async {
    await prefs.remove(refreshToken);
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

  Future<void> setFCMToken({required String fcmTokenId}) async {
    await prefs.setString(fcmToken, fcmTokenId);
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

  Future<void> setCartCount({required int count}) async {
    await prefs.setInt(userCartCount, count);
  }

  Future<void> setMessageCount({required int count}) async {
    await prefs.setInt(userMessageCount, count);
  }

  Future<void> setCartId({required String cartId}) async {
    await prefs.setString(userCartId, cartId);
  }

  Future<void> setPhoneNumber({required String userPhoneNumber}) async {
    await prefs.setString(phoneNumber, userPhoneNumber);
  }

  Future<void> setWalletId({required String UserWalletId}) async {
    await prefs.setString(walletId, UserWalletId);
  }

  Future<void> setCartProductIdList(
      {required List<String> cartProductIds}) async {
    await prefs.setStringList(userCartProductIds, cartProductIds);
  }

  Future<void> setCartProductList({required List<String> cartProducts}) async {
    await prefs.setStringList(userCartProducts, cartProducts);
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

  String getAppVersion() {
    return prefs.getString(appVersion) ?? '1.0.0';
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

  int getCartCount() {
    return prefs.getInt(userCartCount) ?? 0;
  }

  int getMessageCount() {
    return prefs.getInt(userMessageCount) ?? 0;
  }

  String getCartId() {
    return prefs.getString(userCartId) ?? '';
  }

  String getPhoneNumber() {
    return prefs.getString(phoneNumber) ?? '';
  }

  String getWalletId() {
    return prefs.getString(walletId) ?? '';
  }

  List<String> getCartProductIdList() {
    return prefs.getStringList(userCartProductIds) ?? [];
  }

  List<String> getCartProductList() {
    return prefs.getStringList(userCartProducts) ?? [];
  }
}

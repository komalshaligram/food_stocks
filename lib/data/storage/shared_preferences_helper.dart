import '../../ui/utils/themes/app_strings.dart';
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
  static const String reqApiUrl = 'reqApiUrl';
  static const String apiPram = 'apiPram';
  static const String isCelebrationAnimation = 'isCelebrationAnimation';
  static const String orderId = 'orderId';
  static const String gridView = 'gridView';
  static const String bottleTax = 'bottleTax';
  static const String bankTransferDetail = 'bankTransferDetail';
  static const String emailId = 'userEmailId';
  static const String guestUser = 'guestUser';
  static const String companyProductGrid = 'isCompanyProductGrid';
  static const String supplierProductGrid = 'isSupplierProductGrid';
  static const String planogramProductGrid = 'isPlanogramProductGrid';
  static const String recommendationProductGrid = 'isrecommendationProductGrid';
  static const String salesProductGrid ='isSalesproductGrid';
  static const String reorderProductGrid = 'isReorderProductGrid';
  static const String subUser = 'isSubUser';
  static const String companyName = 'companyName';
  static const String includedVat = 'showSale';
  static const String saleOn = 'showVat';
  static const String userCity = 'userCity';
  static const String userStreetName = 'userStreetName';
  static const String userStreetNumber = 'userStreetNumber';
  static const String fax = 'fax';
  static const String zip = 'zip';
  static const String logo = 'logo';

  static const String accountAdmin = 'accountAdmin';
  static const String seeWallet = 'seeWallet';
  static const String addBasket = 'addBasket';
  static const String createOrder = 'createOrder';
  static const String seeOrder = 'seeOrder';
  static const String approveOrder = 'approveOrder';
  static const String duplicateOrder = 'duplicateOrder';
  static const String updateBusinessInfo = 'updateBusinessInfo';
  static const String updateAdditionalInfo = 'updateAdditionalInfo';
  static const String updateTimeInfo = 'updateTimeInfo';
  static const String seeFormsFiles = 'seeFormsFiles';
  static const String manageSubUser = 'manageSubUser';
  static const String subUserId = 'subUserId';
  static const String canSeeInvoices = 'canSeeInvoices';
  static const String appOnMaintenance= 'isAppOnMaintenance';
  static const String paymentMethod = 'selectedPaymentMethod';
  static const String paymentMethodCount = 'paymentMethodCount';
  static const String availableAllPayment = 'availableAllPayment';
  static const String paymentMethods = 'paymentMethods';
  static const String isWalletApproved ='isWalletApproved';
  static const String canSeeReturns = 'canSeeReturns';
  static const String orderStatusDetail = 'orderStatusDetail';
  static const String statusDetail = 'statusDetail';
  static const String paymentStatusDetail = 'paymentStatusDetail';
  static const String returnStatusDetail = 'returnStatusDetail';

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
      await prefs.remove(subUser);
      await prefs.remove(companyName);
      await prefs.remove(emailId);
      await prefs.remove(saleOn);
      await prefs.remove(includedVat);
      await prefs.remove(userCity);
      await prefs.remove(userStreetName);
      await prefs.remove(userStreetNumber);
      await prefs.remove(fax);
      await prefs.remove(zip);
      await prefs.remove(logo);
      await prefs.remove(isWalletApproved);


      await prefs.remove(accountAdmin);
      await prefs.remove(seeWallet);
      await prefs.remove(createOrder);
      await prefs.remove(seeOrder);
      await prefs.remove(approveOrder);
      await prefs.remove(duplicateOrder);
      await prefs.remove(updateAdditionalInfo);
      await prefs.remove(updateBusinessInfo);
      await prefs.remove(updateTimeInfo);
      await prefs.remove(seeFormsFiles);
      await prefs.remove(manageSubUser);
      await prefs.remove(addBasket);
      await prefs.remove(subUserId);
      await prefs.remove(canSeeInvoices);
      await prefs.remove(appOnMaintenance);
      await prefs.remove(paymentMethod);
      await prefs.remove(paymentMethodCount);
      await prefs.remove(availableAllPayment);
      await prefs.remove(paymentMethods);
      await prefs.remove(canSeeReturns);
      await prefs.remove(orderStatusDetail);
      await prefs.remove(statusDetail);
      await prefs.remove(paymentStatusDetail);
      await prefs.remove(returnStatusDetail);

    }
    await prefs.setBool(userLoggedIn, isLoggedIn);
  }


  Future<void> setPaymentMethod({required String method}) async {
    await prefs.setString(paymentMethod, method);
  }

  Future<void> setPaymentMethodCount({required String count}) async {
    await prefs.setString(paymentMethodCount, count);
  }

  Future<void> removeProfileImage() async {
    await prefs.remove(userImage);
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

  Future<void> setOrderStatusInfo({required String statusData}) async {
    await prefs.setString(orderStatusDetail, statusData);
  }
  Future<void> setStatusInfo({required String statusData}) async {
    await prefs.setString(statusDetail, statusData);
  }
  Future<void> setPaymentStatusInfo({required String statusData}) async {
    await prefs.setString(paymentStatusDetail, statusData);
  }
  Future<void> setReturnStatusInfo({required String statusData}) async {
    await prefs.setString(returnStatusDetail, statusData);
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

  Future<void> setWalletId({required String userWalletId}) async {
    await prefs.setString(walletId, userWalletId);
  }

  Future<void> setApiUrl({required String apiUrl}) async {
    await prefs.setString(reqApiUrl, apiUrl);
  }

  Future<void> setReqPram({required String reqPram}) async {
    await prefs.setString(apiPram, reqPram);
  }

  Future<void> setIsAppOnMaintenance({required bool isAppOnMaintenance}) async {
    await prefs.setBool(appOnMaintenance, isAppOnMaintenance);
  }
  Future<void> setIsWalletApproved({required bool walletApproved}) async {
    await prefs.setBool(isWalletApproved, walletApproved);
  }

  Future<void> setOrderId({required String productOrderId}) async {
    await prefs.setString(orderId, productOrderId);
  }
  Future<void> setIsGridView({required bool isGridView}) async {
    await prefs.setBool(gridView, isGridView);
  }
  Future<void> setBottleTax({required double bottleDeposit}) async {
    await prefs.setDouble(bottleTax, bottleDeposit);
  }
  Future<void> setBankTransferDetail({required String details}) async {
    await prefs.setString(bankTransferDetail, details);
  }
  Future<void> setIsGuestUser({bool isGuestUser = false}) async {
    await prefs.setBool(guestUser, isGuestUser);
  }
  Future<void> setEmailId({required String userEmailId}) async {
    await prefs.setString(emailId, userEmailId);
  }
  Future<void> setCompanyGridListView({required bool isCompanyProductGrid}) async {
    await prefs.setBool(companyProductGrid, isCompanyProductGrid);
  }
  Future<void> setSupplierProductGridListView({required bool isSupplierProductGrid}) async {
    await prefs.setBool(supplierProductGrid, isSupplierProductGrid);
  }
  Future<void> setPlanogramProductGridListView({required bool isPlanogramProductGrid}) async {
    await prefs.setBool(planogramProductGrid, isPlanogramProductGrid);
  }
  Future<void> setReorderProductGridListView({required bool isReorderProductGrid}) async {
    await prefs.setBool(reorderProductGrid, isReorderProductGrid);
  }
  Future<void> setRecommendationProductGridListView({required bool isRecommendationProductGrid}) async {
    await prefs.setBool(recommendationProductGrid, isRecommendationProductGrid);
  }
  Future<void> setSalesProductGridListView({required bool isSalesProductGrid}) async {
    await prefs.setBool(salesProductGrid, isSalesProductGrid);
  }

  Future<void> setIsSubUser({required bool isSubUser}) async {
    await prefs.setBool(subUser, isSubUser);
  }

  Future<void> setBusinessName({required String businessName}) async {
    await prefs.setString(companyName, businessName);
  }

  Future<void> setIsIncludedVat({required bool isIncludedVat}) async {
    await prefs.setBool(includedVat, isIncludedVat);
  }

  Future<void> setIsSaleOn({required bool isSaleOn}) async {
    await prefs.setBool(saleOn, isSaleOn);
  }
  Future<void> setCity({required String city}) async {
    await prefs.setString(userCity, city);
  }
  Future<void> setStreetName({required String streetName}) async {
    await prefs.setString(userStreetName, streetName);
  }
  Future<void> setStreetNumber({required String streetNumber}) async {
    await prefs.setString(userStreetNumber, streetNumber);
  }
  Future<void> setFaxNumber({required String faxNumber}) async {
    await prefs.setString(fax, faxNumber);
  }
  Future<void> setZipCode({required String zipCode}) async {
    await prefs.setString(zip, zipCode);
  }
  Future<void> setUserLogo({required String logoImage}) async {
    await prefs.setString(logo, logoImage);
  }

  //permission

  Future<void> setAccountAdmin({required bool isAccountAdmin}) async {
    await prefs.setBool(accountAdmin, isAccountAdmin);
  }

  Future<void> setCanSeeWallet({required bool isSeeWallet}) async {
    await prefs.setBool(seeWallet, isSeeWallet);
  }

  Future<void> setCanAddBasket({required bool isAddBasket}) async {
    await prefs.setBool(addBasket, isAddBasket);
  }

  Future<void> setCanCreateOrder({required bool isCreateOrder}) async {
    await prefs.setBool(createOrder, isCreateOrder);
  }

  Future<void> setCanSeeOrder({required bool isSeeOrder}) async {
    await prefs.setBool(seeOrder, isSeeOrder);
  }

  Future<void> setAvailableAllPayment({required bool isAvailableAllPayment}) async {
    await prefs.setBool(availableAllPayment, isAvailableAllPayment);
  }

  Future<void> setCanApproveOrder({required bool isApproveOrder}) async {
    await prefs.setBool(approveOrder, isApproveOrder);
  }

  Future<void> setCanDuplicateOrder({required bool isDuplicateOrder}) async {
    await prefs.setBool(duplicateOrder, isDuplicateOrder);
  }

  Future<void> setCanUpdateBusinessInfo({required bool isUpdateBusinessInfo}) async {
    await prefs.setBool(updateBusinessInfo, isUpdateBusinessInfo);
  }

  Future<void> setCanUpdateAdditionalInfo({required bool isUpdateAdditionalInfo}) async {
    await prefs.setBool(updateAdditionalInfo, isUpdateAdditionalInfo);
  }

  Future<void> setCanUpdateTimeInfo({required bool isUpdateTimeInfo}) async {
    await prefs.setBool(updateTimeInfo, isUpdateTimeInfo);
  }


  Future<void> setCanSeeFormsFiles({required bool isSeeFormsFiles}) async {
    await prefs.setBool(seeFormsFiles, isSeeFormsFiles);
  }

  Future<void> setManageSubUser({required bool isManageSubUser}) async {
    await prefs.setBool(manageSubUser, isManageSubUser);
  }

  Future<void> setSubUserId({required String id}) async {
    await prefs.setString(subUserId, id);
  }

  Future<void> setCanSeeInvoices({required bool isCanSeeInvoices}) async {
    await prefs.setBool(canSeeInvoices, isCanSeeInvoices);
  }

  Future<void> setPaymentMethodTypes({required List<String> methods}) async {
    await prefs.setStringList(paymentMethods, methods);
  }

  Future<void> setCanSeeReturns({required bool isCanSeeReturns}) async {
    await prefs.setBool(canSeeReturns, isCanSeeReturns);
  }


  String getAppLanguage() {
    return prefs.getString(lang) ?? AppStrings.hebrewString;
  }

  bool getUserLoggedIn() {
    return prefs.getBool(userLoggedIn) ?? false;
  }
  bool getWalletApproved() {
    return prefs.getBool(isWalletApproved) ?? false;
  }

  String getAuthToken() {
    return prefs.getString(accessToken) ?? '';
  }

  String getFCMToken() {
    return prefs.getString(fcmToken) ?? '';
  }

  String getOrderStatusInfo() {
    return prefs.getString(orderStatusDetail) ?? '';
  }
  String getStatusInfo() {
    return prefs.getString(statusDetail) ?? '';
  }
  String getPaymentStatusInfo() {
    return prefs.getString(paymentStatusDetail) ?? '';
  }
  String getReturnStatusInfo() {
    return prefs.getString(returnStatusDetail) ?? '';
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

  double getBottleTax() {
    return prefs.getDouble(bottleTax) ?? 0.0;
  }
  String getWalletId() {
    return prefs.getString(walletId) ?? '';
  }
  String getApiUrl() {
    return prefs.getString(reqApiUrl) ?? '';
  }
  String getRqPram() {
    return prefs.getString(apiPram) ?? '';
  }

  String getOrderId() {
    return prefs.getString(orderId) ?? '';
  }
  bool getIsGridView() {
    return prefs.getBool(gridView) ?? true;
  }
  String getEmailId() {
    return prefs.getString(emailId) ?? '';
  }
  bool getGuestUser() {
    return prefs.getBool(guestUser) ?? false;
  }
  bool getCompanyProductGrid() {
    return prefs.getBool(companyProductGrid) ?? true;
  }
  bool getSupplierProductGrid() {
    return prefs.getBool(supplierProductGrid) ?? true;
  }
  bool getPlanogramProductGrid() {
    return prefs.getBool(planogramProductGrid) ?? true;
  }
  bool getRecommendationProductGrid() {
    return prefs.getBool(recommendationProductGrid) ?? true;
  }
  bool getSalesProductGrid() {
    return prefs.getBool(salesProductGrid) ?? true;
  }
  bool getReorderProductGrid() {
    return prefs.getBool(reorderProductGrid) ?? true;
  }

  bool getSubUser() {
    return prefs.getBool(subUser) ?? false;
  }

  String getBusinessName() {
    return prefs.getString(companyName) ?? '';
  }

  bool getShowSale() {
    return prefs.getBool(saleOn) ?? false;
  }

  bool getIsIncludedVat() {
    return prefs.getBool(includedVat) ?? false;
  }

  String getCity() {
    return prefs.getString(userCity) ?? '';
  }
  String getStreetName() {
    return prefs.getString(userStreetName) ?? '';
  }
  String getStreetNumber() {
    return prefs.getString(userStreetNumber) ?? '';
  }
  String getFax() {
    return prefs.getString(fax) ?? '';
  }
  String getZip() {
    return prefs.getString(zip) ?? '';
  }
  String getLogo() {
    return prefs.getString(logo) ?? '';
  }
  List<String> getPaymentMethodTypes() {
    return prefs.getStringList(paymentMethods) ?? [];
  }
  //permission

  bool getCanAccountAdmin() {
    return prefs.getBool(accountAdmin) ?? true;
  }

  bool getCanSeeWallet() {
    return prefs.getBool(seeWallet) ?? true;
  }

  bool getCanAddToBasket() {
    return prefs.getBool(addBasket) ?? true;
  }

  bool getCanCreateOrder() {
    return prefs.getBool(createOrder) ?? true;
  }

  bool getCanSeeOrder() {
    return prefs.getBool(seeOrder) ?? true;
  }

  bool getCanApproveOrder() {
    return prefs.getBool(approveOrder) ?? true;
  }

  bool getCanDuplicateOrder() {
    return prefs.getBool(duplicateOrder) ?? true;
  }

  bool getCanUpdateBusinessInfo() {
    return prefs.getBool(updateBusinessInfo) ?? true;
  }

  bool getCanUpdateAdditionalInfo() {
    return prefs.getBool(updateAdditionalInfo) ?? true;
  }
  bool getCanUpdateTimeInfo() {
    return prefs.getBool(updateTimeInfo) ?? true;
  }
  bool getCanSeeFormsFiles() {
    return prefs.getBool(seeFormsFiles) ?? true;
  }
 String getBankTransferDetail()  {
    return prefs.getString(bankTransferDetail)??'';
  }
  bool getCanSeeReturns()  {
    return prefs.getBool(canSeeReturns)??false;
  }
  bool getCanManageSubUser() {
    return prefs.getBool(manageSubUser) ?? true;
  }

  String getSubUserId() {
    return prefs.getString(subUserId) ?? '';
  }

  bool getCanSeeInvoices() {
    return prefs.getBool(canSeeInvoices) ?? true;
  }

  bool getAppOnMaintenance() {
    return prefs.getBool(appOnMaintenance) ?? false;
  }

  String getPaymentMethod() {
    return prefs.getString(paymentMethod) ?? '';
  }
  String getPaymentMethodCount() {
    return prefs.getString(paymentMethodCount) ?? '1';
  }
  bool getAvailablePayment() {
    return prefs.getBool(availableAllPayment) ?? false;
  }
}
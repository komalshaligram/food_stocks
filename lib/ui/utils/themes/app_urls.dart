class AppUrls {
  static const String baseUrl =
      'http://182.70.118.201:3000/api' /*'http://192.168.1.80:3001/api'*/;

  static const String baseFileUrl =
      'http://182.70.118.201:3000/public/' /*'http://192.168.1.80:3001/public/'*/;

  static const String existingUserLoginUrl = '/v1/auth/verifyContactAndSendOTP';
  static const String loginOTPUrl = '/v1/auth/clientLogin';
  static const String newUserLoginUrl = '/v1/auth/verifyContactAndSendOTP';

  static const String RegistrationUrl = '/v1/clients/createClient';
  static const String fileUploadUrl = '/v1/files/upload';
  static const String fileUpdateUrl = '/v1/admin/updateFiles';
  static const String businessTypesUrl = '/v1/settings/ClientTypes';
  static const String getProfileDetailsUrl = '/v1/admin/getAllClients';
  static const String updateProfileDetailsUrl = '/v1/clients/updateClient';
  static const String formsListUrl = '/v1/settings/ClientForms';
  static const String filesListUrl = '/v1/settings/ClientFiles';
  static const String operationTimeUrl = '/v1/clients/operationTime';
  static const String cityListUrl = '/v1/settings/Cities';
  static const String removeFileUrl = '/v1/files/remove';
  static const String getProductCategoriesUrl = '/v1/settings/Categories';
  static const String getProductSalesUrl = '/v1/sales/getSales';
  static const String getSuppliersUrl = '/v1/suppliers/getSupplier';
  static const String getSupplierProductsUrl =
      '/api/v1/products/getAllProducts';
}

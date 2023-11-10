class AppUrls {
  static const String baseUrl = /*'http://192.168.1.46:8080/api'*/

      /*'http://192.168.1.46:3000/api'*/
      'http://182.70.118.201:3000/api' /*'http://192.168.1.204:3000/api'*/;

  static const String baseFileUrl =
      'http://182.70.118.201:3000/public/' /*'http://192.168.1.46:8080/public/'*/;

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
  static const String getProductCategoriesUrl = '/v1/store/getCategories';
  static const String getProductSalesUrl = '/v1/sales/getSales';
  static const String getSaleProductsUrl = '/v1/store/SaleProducts';
  static const String getSuppliersUrl = '/v1/suppliers/getSupplier';
  static const String getSupplierProductsUrl =
      '/v1/supplierProduct/getSupplierProducts';
  static const String getProductDetailsUrl = '/v1/store/ProductDetail';
  static const String getPlanogramProductsUrl =
      '/v1/store/getPalnogramProducts';

// static const String getProductSuppliersUrl = '/v1/supplierProduct/getSupplierProducts';
  static const String createOrderUrl = '/v1/orders/createOrder';
  static const String getAllOrderUrl = '/v1/orders/getAllOrders';
  static const String verifyProductStockUrl = '/v1/store/verifyStock';
  static const String getAllCartUrl = '/v1/cart/listingCartProducts/';
  static const String getOrderById = '/v1/orders/getOrderById/';
  static const String verifyStockUrl = '/v1/store/verifyStock';
  static const String updateCartProductUrl = '/v1/cart/updateCartProducts/';
  static const String listingCartProductsSupplierUrl =
      '/v1/cart/listingCartProductsSupplier/';
  static const String getIssueUrl =
      '/v1/orders/6540dd1bb186f807d4ce24f0/issues';
  static const String createIssueUrl = '/issues/createIssue';
  static const String ordersUrl = '/v1/orders/';
  static const String deliveryConfirmUrl = '/delivery/confirm';
  static const String clearCartUrl = '/v1/cart/clearCart/';
  static const String removeCartProductUrl = '/v1/cart/removeProduct';
  static const String walletRecordUrl =
      '/v1/walletTransaction/getWalletRecords';
  static const String totalExpenseByYearUrl =
      '/v1/walletTransaction/getTotalExpensesByYear';
  static const String getAllWalletTransactionUrl =
      '/v1/walletTransaction/getAllWalletTransactions';
  static const String getSubCategoriesUrl = '/v1/store/getSubCategories';
  static const String getCompaniesUrl = '/v1/store/getBrand';
  static const String insertProductInCartUrl = '/v1/cart/addProduct/';
}

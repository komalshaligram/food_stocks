import 'package:flutter/material.dart';
import 'package:food_stock/ui/screens/return_summary_screen.dart';
import 'package:food_stock/ui/screens/scan_return_product_screen.dart';
import 'package:food_stock/ui/widget/common_pdf_viewer.dart';
import '../../ui/screens/manage_credit_card.dart';

import '../../ui/screens/bottom_nav_screen.dart';
import '../../ui/screens/home_screen.dart';
import '../../ui/screens/login_screen.dart';
import '../../ui/screens/message_content_screen.dart';
import '../../ui/screens/message_screen.dart';
import '../../ui/screens/activity_time_screen.dart';
import '../../ui/screens/order_screen.dart';
import '../../ui/screens/pesach_products_screen.dart';
import '../../ui/screens/planogram_product_screen.dart';
import '../../ui/screens/product_category_screen.dart';
import '../../ui/screens/product_sale_screen.dart';
import '../../ui/screens/profile_menu_screen.dart';
import '../../ui/screens/otp_screen.dart';
import '../../ui/screens/recommendation_products_screen.dart';
import '../../ui/screens/reorder_screen.dart';
import '../../ui/screens/splash_screen.dart';
import '../../ui/screens/store_category_screen.dart';
import '../../ui/screens/supplier_products_screen.dart';
import '../ui/screens/account_permission_screen.dart';
import '../ui/screens/bank_info_screen.dart';
import '../ui/screens/bank_transfer_screen.dart';
import '../ui/screens/basket_screen.dart';
import '../ui/screens/brands_permission_screen.dart';
import '../ui/screens/categories_permission_screen.dart';
import '../ui/screens/client_form_details_screen.dart';
import '../ui/screens/company_product_screen.dart';
import '../ui/screens/company_screen.dart';
import '../ui/screens/connect_screen.dart';
import '../ui/screens/create_product_return_list.dart';
import '../ui/screens/credit_card_details_screen.dart';
import '../ui/screens/form_data_screen.dart';
import '../ui/screens/invoice_pdf_screen.dart';
import '../ui/screens/invoice_screen.dart';
import '../ui/screens/file_upload_screen.dart';
import '../ui/screens/order_details_screen.dart';
import '../ui/screens/order_successful_screen.dart';
import '../ui/screens/order_summary_screen.dart';
import '../ui/screens/owner1_form_screen.dart';
import '../ui/screens/owner2_form_screen.dart';
import '../ui/screens/preview_screen.dart';
import '../ui/screens/privacy_policy_screen.dart';
import '../ui/screens/product_details_screen.dart';
import '../ui/screens/product_return_info_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/more_details_screen.dart';
import '../ui/screens/return_driver.dart';
import '../ui/screens/return_list_screen.dart';
import '../ui/screens/shipment_verification_screen.dart';
import '../ui/screens/store_screen.dart';
import '../ui/screens/sub_users_profile_screen.dart';
import '../ui/screens/sub_users_screen.dart';
import '../ui/screens/supplier_permission_screen.dart';
import '../ui/screens/supplier_screen.dart';
import '../ui/screens/wallet_screen.dart';
import '../ui/screens/way_of_payment_screen.dart';
import '../ui/screens/client_form_details_screen.dart';

enum RouteDefine {
  ///ADD NAME OF ROUTE SCREEN
  ///
  splashScreen,
  loginScreen,
  registerScreen,
  connectScreen,
  profileScreen,
  moreDetailsScreen,
  activityTimeScreen,
  bottomNavScreen,
  homeScreen,
  menuScreen,
  basketScreen,
  walletScreen,
  orderScreen,
  questionAndAnswerScreen,
  appContentScreen,
  messageScreen,
  messageContentScreen,
  storeScreen,
  otpScreen,
  fileUploadScreen,
  profileMenuScreen,
  orderDetailsScreen,
  productDetailsScreen,
  shipmentVerificationScreen,
  storeCategoryScreen,
  orderSummaryScreen,
  orderSuccessfulScreen,
  supplierScreen,
  supplierProductsScreen,
  productSaleScreen,
  planogramProductScreen,
  productCategoryScreen,
  companyScreen,
  companyProductsScreen,
  recommendationProductsScreen,
  reorderScreen,
  pesachScreen,
  formDataScreen,
  bankInfoScreen, privacyPolicyScreen,
  previewScreen,
  invoiceScreen,
  invoicePdfScreen,
  subUsersScreen,
  subUsersProfileScreen,
  accountPermissionScreen,
  categoriesPermissionScreen,
  brandPermissionScreen,
  supplierPermissionScreen,
  wayOfPaymentScreen,
  creditCardDetailsScreen,
  manageCreditCardScreen,
  bankTransferScreen,
  owner1FormScreen,
  owner2FormScreen,
  returnListScreen,
  scanReturnProduct,
  productReturnInfoScreen,
  createProductReturnListScreen,
  returnSummaryScreen,
  clientFormDetailsScreen,
  returnDriverScreen
}

class AppRouting {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      ///ADD ROUTE
      RouteDefine.splashScreen.name: (_) => SplashRoute.route,
      RouteDefine.connectScreen.name: (_) => ConnectRoute.route,
      RouteDefine.profileScreen.name: (_) => ProfileRoute.route,
      RouteDefine.moreDetailsScreen.name: (_) => MoreDetailsRoute.route,
      RouteDefine.activityTimeScreen.name: (_) => ActivityTimeScreenRoute.route,
      RouteDefine.fileUploadScreen.name: (_) => FileUploadScreenRoute.route,
      RouteDefine.loginScreen.name: (_) => LogInRoute.route,
      RouteDefine.bottomNavScreen.name: (_) => BottomNavRoute.route,
      RouteDefine.homeScreen.name: (_) => HomeRoute.route,
    //  RouteDefine.menuScreen.name: (_) => MenuRoute.route,
      RouteDefine.basketScreen.name: (_) => BasketRoute.route,
      RouteDefine.walletScreen.name: (_) => WalletRoute.route,
      RouteDefine.storeScreen.name: (_) => StoreRoute.route,
      RouteDefine.orderScreen.name: (_) => OrderRoute.route,
      RouteDefine.messageScreen.name: (_) => MessageRoute.route,
      RouteDefine.messageContentScreen.name: (_) => MessageContentRoute.route,
      RouteDefine.otpScreen.name: (_) => OTPRoute.route,
      RouteDefine.profileMenuScreen.name: (_) => ProfileMenuRoute.route,
      RouteDefine.orderDetailsScreen.name: (_) => OrderDetailsRoute.route,
      RouteDefine.productDetailsScreen.name: (_) => ProductDetailsRoute.route,
      RouteDefine.shipmentVerificationScreen.name: (_) =>
          ShipmentVerificationRoute.route,
      RouteDefine.storeCategoryScreen.name: (_) => StoreCategoryRoute.route,
      RouteDefine.orderSummaryScreen.name: (_) => OrderSummaryRoute.route,
      RouteDefine.orderSuccessfulScreen.name: (_) => OrderSuccessfulRoute.route,
      RouteDefine.supplierScreen.name: (_) => SupplierRoute.route,
      RouteDefine.supplierProductsScreen.name: (_) =>
          SupplierProductsRoute.route,
      RouteDefine.productSaleScreen.name: (_) => ProductSaleRoute.route,
      RouteDefine.planogramProductScreen.name: (_) =>
          PlanogramProductRoute.route,
      RouteDefine.productCategoryScreen.name: (_) => ProductCategoryRoute.route,
      RouteDefine.companyScreen.name: (_) => CompanyRoute.route,
      RouteDefine.companyProductsScreen.name: (_) => CompanyProductsRoute.route,
      RouteDefine.recommendationProductsScreen.name: (_) =>
          RecommendationProductsRoute.route,
      RouteDefine.reorderScreen.name: (_) => ReorderRoute.route,
      RouteDefine.formDataScreen.name: (_) => FormDataRoute.route,
      RouteDefine.bankInfoScreen.name: (_) => BankInfoRoute.route,
      RouteDefine.privacyPolicyScreen.name: (_) => PrivacyPolicyRoute.route,
      RouteDefine.pesachScreen.name: (_) => PesachProductsRoute.route,
      RouteDefine.previewScreen.name: (_) => PreviewScreenRoute.route,
      RouteDefine.invoiceScreen.name: (_) => InvoiceRoute.route,
      RouteDefine.invoicePdfScreen.name: (_) => InvoicePdfRoute.route,
      RouteDefine.subUsersScreen.name: (_) => SubUsersRoute.route,
      RouteDefine.subUsersProfileScreen.name: (_) => SubUsersProfileRoute.route,
      RouteDefine.accountPermissionScreen.name: (_) => AccountPermissionRoute.route,
      RouteDefine.categoriesPermissionScreen.name: (_) => CategoriesPermissionRoute.route,
      RouteDefine.brandPermissionScreen.name: (_) => BrandsPermissionRoute.route,
      RouteDefine.supplierPermissionScreen.name: (_) => SupplierPermissionRoute.route,
      RouteDefine.wayOfPaymentScreen.name: (_) => WayOfPaymentRoute.route,
      RouteDefine.creditCardDetailsScreen.name: (_) => CreditCardDetailsRoute.route,
      RouteDefine.manageCreditCardScreen.name: (_) => ManageCreditCardRoute.route,
      RouteDefine.bankTransferScreen.name: (_) => BankTransferScreenRoute.route,
      RouteDefine.owner1FormScreen.name: (_) => Owner1FormRoute.route,
      RouteDefine.owner2FormScreen.name: (_) => Owner2FormRoute.route,
      RouteDefine.returnListScreen.name:(_)=>ReturnListRoute.route,
      RouteDefine.scanReturnProduct.name:(_)=>ScanReturnProductRoute.route,
      RouteDefine.productReturnInfoScreen.name:(_)=>ProductReturnInfoRoute.route,
      RouteDefine.createProductReturnListScreen.name:(_)=>CreateProductReturnListRoute.route,
      RouteDefine.returnSummaryScreen.name:(_)=>ReturnSummaryRoute.route,
      RouteDefine.clientFormDetailsScreen.name:(_)=>ClientFormDetailsRoute.route,
      RouteDefine.returnDriverScreen.name:(_)=>ReturnDriverRoute.route,
    };

    final routeBuilder = routes[settings.name];

    return MaterialPageRoute(
      builder: (context) => routeBuilder!(context),
      settings:
          RouteSettings(name: settings.name, arguments: settings.arguments ,),
    );

  }
}
extension RouteExt on Object {
  String get name => toString().substring(toString().indexOf('.') + 1);
}

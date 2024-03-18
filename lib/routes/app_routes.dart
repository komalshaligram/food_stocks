import 'package:flutter/material.dart';
import 'package:food_stock/ui/screens/app_content_screen.dart';
import 'package:food_stock/ui/screens/bottom_nav_screen.dart';
import 'package:food_stock/ui/screens/home_screen.dart';
import 'package:food_stock/ui/screens/login_screen.dart';
import 'package:food_stock/ui/screens/message_content_screen.dart';
import 'package:food_stock/ui/screens/message_screen.dart';
import 'package:food_stock/ui/screens/activity_time_screen.dart';
import 'package:food_stock/ui/screens/order_screen.dart';
import 'package:food_stock/ui/screens/planogram_product_screen.dart';
import 'package:food_stock/ui/screens/product_category_screen.dart';
import 'package:food_stock/ui/screens/product_sale_screen.dart';
import 'package:food_stock/ui/screens/profile_menu_screen.dart';
import 'package:food_stock/ui/screens/question_and_answer_screen.dart';
import 'package:food_stock/ui/screens/otp_screen.dart';
import 'package:food_stock/ui/screens/recommendation_products_screen.dart';
import 'package:food_stock/ui/screens/reorder_screen.dart';
import 'package:food_stock/ui/screens/splash_screen.dart';
import 'package:food_stock/ui/screens/store_category_screen.dart';
import 'package:food_stock/ui/screens/supplier_products_screen.dart';
import '../ui/screens/basket_screen.dart';
import '../ui/screens/company_product_screen.dart';
import '../ui/screens/company_screen.dart';
import '../ui/screens/connect_screen.dart';
import '../ui/screens/file_upload_screen.dart';
import '../ui/screens/order_details_screen.dart';
import '../ui/screens/order_successful_screen.dart';
import '../ui/screens/order_summary_screen.dart';
import '../ui/screens/product_details_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/more_details_screen.dart';
import '../ui/screens/shipment_verification_screen.dart';
import '../ui/screens/store_screen.dart';
import '../ui/screens/supplier_screen.dart';
import '../ui/screens/wallet_screen.dart';

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
      RouteDefine.basketScreen.name: (_) => BasketRoute.route,
      RouteDefine.walletScreen.name: (_) => WalletRoute.route,
      RouteDefine.storeScreen.name: (_) => StoreRoute.route,
      RouteDefine.orderScreen.name: (_) => OrderRoute.route,
      RouteDefine.questionAndAnswerScreen.name: (_) =>
          QuestionAndAnswerRoute.route,
      RouteDefine.appContentScreen.name: (_) => AppContentRoute.route,
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